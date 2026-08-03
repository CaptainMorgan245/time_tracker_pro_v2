import '../data/local/drift/app_database.dart';

/// Pure billing math shared by the time-entry records screen and (Phase 2)
/// invoice creation, so labour rates and material markups are computed in
/// exactly one place. All money is in integer **cents** — the stored unit — so
/// callers don't re-introduce rounding differences. No Drift/Riverpod here:
/// these are plain functions over row objects + lookup maps.

/// Hourly bill rate for a time entry, in **cents**. Resolution order:
///
///   1. the project's own `billedHourlyRate` (hourly-model projects only);
///   2. [companyDefaultRateCents] — the company **Default Billing Rate**
///      (`settings.companyHourlyRate`), used when the project carries no rate
///      of its own;
///   3. the employee's role `standardRate`;
///   4. 0.
///
/// Step 2 is a DELIBERATE DEVIATION from the original app, which fell straight
/// from a blank project rate to the role rate — i.e. billed the client at an
/// employee COST rate, silently, for every project created without a rate.
///
/// [companyDefaultRateCents] is a **required named** parameter for exactly that
/// reason: it cannot be skipped by omission, because a new call site that
/// forgets it fails to compile. Do not give it a default value and do not make
/// it positional — that guarantee is the whole point.
///
/// Distinct from `settings.burdenRate`, which is the internal cost figure and
/// must never bill a client — see [labourCostCents].
int hourlyRateCents(
  DbProject project,
  int? employeeId,
  Map<int, DbEmployee> employeeById,
  Map<int, DbRole> roleById, {
  required int? companyDefaultRateCents,
}) {
  if (project.pricingModel == 'hourly' && project.billedHourlyRate != null) {
    return project.billedHourlyRate!;
  }
  if (companyDefaultRateCents != null && companyDefaultRateCents > 0) {
    return companyDefaultRateCents;
  }
  final emp = employeeId == null ? null : employeeById[employeeId];
  final titleId = emp?.titleId;
  if (titleId != null) {
    final role = roleById[titleId];
    if (role != null) return role.standardRate;
  }
  return 0;
}

/// Billable labour for a time entry, in **cents**, from a rate in cents and a
/// billed duration in seconds. Rounded to the nearest cent.
int labourValueCents(int rateCents, double billedSeconds) =>
    (rateCents * billedSeconds / 3600).round();

/// The **actual employee pay rate** for a time entry, in **cents**: the
/// individual employee's `hourlyRate`, falling back to their role's
/// `standardRate` when they have no individual rate, then 0. Used for
/// fixed-price labour cost, where cost is what the people who logged the time
/// are actually paid — not the burden rate or the project's billing rate.
int employeeRateCents(
  int? employeeId,
  Map<int, DbEmployee> employeeById,
  Map<int, DbRole> roleById,
) {
  final emp = employeeId == null ? null : employeeById[employeeId];
  final rate = emp?.hourlyRate;
  if (rate != null) return rate;
  final titleId = emp?.titleId;
  if (titleId != null) {
    final role = roleById[titleId];
    if (role != null) return role.standardRate;
  }
  return 0;
}

/// Company **cost** of labour in cents: [billableHours] × the company burden
/// rate (in **dollars**, from `settings.burdenRate`), rounded to the nearest
/// cent. A null or zero burden rate yields 0 — the caller is responsible for
/// flagging that the burden rate is unconfigured. This is deliberately distinct
/// from [labourValueCents]/[hourlyRateCents] (the billed/revenue side): cost is
/// the burden rate, never the billing rate.
int labourCostCents(double billableHours, double? burdenRateDollars) {
  final rate = burdenRateDollars ?? 0;
  if (rate <= 0) return 0;
  return (billableHours * rate * 100).round();
}

/// Effective expense markup percent for a project (e.g. 15.0 for +15%).
/// Projects always carry their own `expenseMarkupPercentage` (non-null,
/// defaults to 15); [fallbackPercent] is used only when no project is supplied.
/// NB: the global/company-level markup lives on the app `settings` row
/// (`expenseMarkupPercentage`), not on `company_settings`.
double effectiveMarkupPercent(DbProject? project, {double fallbackPercent = 0}) =>
    project?.expenseMarkupPercentage ?? fallbackPercent;

/// Marked-up billable amount for a material/expense, in **cents**. [costCents]
/// is the raw cost; [markupPercent] is e.g. 15.0 for +15%. Pure math — the
/// caller decides whether markup applies at all (e.g. company expenses are
/// typically billed without markup).
int markedUpCostCents(int costCents, double markupPercent) =>
    (costCents * (1 + markupPercent / 100)).round();

/// Semantic classification of a cost code, driving how its entries roll up in
/// the analytics Project Financial Summary.
///
/// Distinct from `cost_codes.is_billable`, which governs T&M invoice line
/// selection only. The three non-billable categories ([contract], [noCharge],
/// [internal]) are all `is_billable = 0` yet feed project financials completely
/// differently, so a single flag can't express them:
///   - [contract]   — Contract Work: real cost covered by a fixed contract
///                    price; the fixed-price cost basis. Never a T&M line item.
///   - [billable]   — Billable: the T&M-invoiceable work. On a fixed-price
///                    project these are above-contract "extras".
///   - [noCharge]   — No Charge: deliberate write-off; tracked as its own
///                    figure, excluded from cost (unbilled by choice, not loss).
///   - [internal]   — overhead; excluded from client-facing project financials.
///   - [needsReview]— NOT a stored value: the fallback for an entry whose cost
///                    code is null or carries an unrecognised/empty `category`.
///                    Excluded from every total and surfaced for a human to fix.
enum CostCodeCategory { contract, billable, noCharge, internal, needsReview }

/// Resolves an entry's `cost_code_id` to its [CostCodeCategory] via [byId]
/// (id → cost code). A null id, a missing code, or an unrecognised/empty
/// `category` string all resolve to [CostCodeCategory.needsReview].
CostCodeCategory classifyCostCode(int? costCodeId, Map<int, DbCostCode> byId) {
  if (costCodeId == null) return CostCodeCategory.needsReview;
  switch (byId[costCodeId]?.category) {
    case 'contract':
      return CostCodeCategory.contract;
    case 'billable':
      return CostCodeCategory.billable;
    case 'no_charge':
      return CostCodeCategory.noCharge;
    case 'internal':
      return CostCodeCategory.internal;
    default:
      return CostCodeCategory.needsReview;
  }
}

/// The user-selectable cost-code categories, in display order, as stored value →
/// label. Deliberately EXCLUDES the null "needs review" state: every cost code
/// must be created with one of these four real categories. Null only ever exists
/// as leftover legacy data, never an active choice.
const Map<String, String> selectableCostCodeCategories = {
  'contract': 'Contract Work',
  'billable': 'Billable',
  'no_charge': 'No Charge',
  'internal': 'Internal',
};

/// Display label for a stored category value. A null/unrecognised value (legacy
/// data only) shows as "Needs Review".
String costCodeCategoryLabel(String? category) =>
    selectableCostCodeCategories[category] ?? 'Needs Review';

/// Derives `is_billable` from a category — only `billable` codes are Time &
/// Materials invoice line items. Single source of truth so the flag can't drift
/// from the category.
int isBillableForCategory(String? category) =>
    category == 'billable' ? 1 : 0;
