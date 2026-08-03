import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/invoice_calc.dart';
import '../../data/local/drift/app_database.dart';
import 'client_project_providers.dart';
import 'invoice_providers.dart';

/// The **final invoice** for a fixed-price contract: the closing invoice that
/// reconciles the contract price against everything already drawn against it
/// (deposit + progress draws), and states the result as a client-facing
/// statement.
///
/// Deliberately its own file — the read model, the reconciliation and the insert
/// companion all live here rather than in the already-oversized
/// `invoice_providers.dart`.
///
/// **Reconciliation method** (both components independently clamped at zero, so
/// an over-drawn contract closes at zero rather than going negative):
/// ```
/// subtotal = contract price      - Σ previously billed subtotals
/// GST      = GST on contract price - Σ previously billed tax1
/// ```
/// GST is reconciled against the *whole contract* rather than recomputed as
/// `rate × subtotal`. Those differ by a cent whenever the draws rounded away
/// from the contract's own GST, and the contract figure is the one that has to
/// come out right — so the reconciled value is what gets stored in
/// `invoices.tax1Amount`, not a re-derived one.
///
/// All money is integer **cents**. No user input feeds the amount: it is fully
/// determined by the contract and the prior invoices.

// ---------------------------------------------------------------------------
// Read model
// ---------------------------------------------------------------------------

/// One previously-billed contract invoice, as a line on the statement.
class FinalInvoiceLine {
  const FinalInvoiceLine({
    required this.label,
    required this.date,
    required this.amountCents,
  });

  /// Client-facing line label — 'Deposit' / 'Draw' (see [_lineLabels]).
  final String label;

  /// The date the invoice was recorded in the app (`invoices.invoiceDate`).
  /// Printed under a generic "Date" heading; it is not a payment-clearing date.
  final DateTime date;

  /// Tax-inclusive line amount: the invoice's `subtotal + tax1Amount`.
  ///
  /// Not `totalAmount`, so that `Contract Total − Total Billed = Balance Due`
  /// foots exactly against the same basis the reconciliation uses. Identical to
  /// `totalAmount` for every deposit/draw the fixed-price form can create (it
  /// writes no discount); they part company only if a draw carried a second tax,
  /// which the contract total — GST-only by definition — has no line for.
  final int amountCents;
}

/// A fixed-price contract's closing position: the contract, every draw already
/// billed against it, and the reconciled remainder that the final invoice bills.
class FinalInvoiceStatement {
  const FinalInvoiceStatement({
    required this.project,
    required this.contractPriceCents,
    required this.contractGstCents,
    required this.priorLines,
    required this.subtotalCents,
    required this.gstCents,
    required this.tax1Name,
    required this.tax1Rate,
  });

  final DbProject project;

  /// Contract price excluding GST (`projects.projectPrice`).
  final int contractPriceCents;

  /// GST on the full contract price at [tax1Rate].
  final int contractGstCents;

  /// Previously billed contract invoices, oldest first.
  final List<FinalInvoiceLine> priorLines;

  /// Reconciled amount this invoice bills, excluding GST (clamped ≥ 0).
  final int subtotalCents;

  /// Reconciled GST this invoice bills (clamped ≥ 0).
  final int gstCents;

  final String tax1Name;
  final double tax1Rate;

  int get contractTotalCents => contractPriceCents + contractGstCents;

  /// Sum of the statement's prior lines — shown to the client as "Total Paid to
  /// Date". Tax-inclusive.
  int get totalBilledToDateCents =>
      priorLines.fold<int>(0, (s, l) => s + l.amountCents);

  /// The amount this invoice bills, tax-inclusive. Equals
  /// `contractTotal − totalBilledToDate` whenever neither component clamped.
  int get balanceDueCents => subtotalCents + gstCents;

  /// True when the contract is already fully drawn — there is nothing left to
  /// bill, so no final invoice should be created.
  bool get isSettled => balanceDueCents == 0;

  /// True when the draws have exceeded the contract, which is what clamping hid.
  /// Surfaced so the create screen can say so instead of silently showing $0.00.
  bool get isOverDrawn => totalBilledToDateCents > contractTotalCents;
}

/// Statement inputs. [tax1Rate] is passed in rather than read from company
/// settings so the contract's GST always matches the rate on the invoice itself
/// — the create screen passes the form's current rate, the detail/PDF path
/// passes the saved `invoices.tax1Rate`.
///
/// [excludeInvoiceId] omits one invoice from "previously billed": pass the final
/// invoice's own id when rendering or editing a *saved* final invoice, otherwise
/// it would reconcile against itself and bill zero.
typedef FinalInvoiceParams = ({
  int projectId,
  double tax1Rate,
  String tax1Name,
  int? excludeInvoiceId,
});

/// Statement params for re-rendering an **already saved** final [inv] — its own
/// stored rate/name, and itself excluded from "previously billed". The one place
/// that mapping lives, so the detail screen and its PDF can't drift apart.
FinalInvoiceParams finalInvoiceParamsFor(DbInvoice inv) => (
      projectId: inv.projectId,
      tax1Rate: inv.tax1Rate ?? 0,
      tax1Name: inv.tax1Name ?? 'GST',
      excludeInvoiceId: inv.id,
    );

const _lineLabels = {
  'deposit': 'Deposit',
  'progress': 'Draw',
  'final': 'Final Invoice',
};

/// Reconciled closing statement for fixed-price project `param.projectId`. Null
/// if the project is missing or isn't a priced fixed-price project — the same
/// gate `fixedPriceSummaryProvider` applies.
final finalInvoiceStatementProvider = Provider.family<
    AsyncValue<FinalInvoiceStatement?>, FinalInvoiceParams>((ref, param) {
  final invoicesA = ref.watch(invoicesStreamProvider);
  final projectsA = ref.watch(projectsStreamProvider);

  return _combine([invoicesA, projectsA], () {
    final project = _firstOrNull(
        projectsA.requireValue.where((p) => p.id == param.projectId));
    if (project == null ||
        project.pricingModel != 'fixed' ||
        (project.projectPrice ?? 0) <= 0) {
      return null;
    }

    final prior = invoicesA.requireValue
        .where((i) =>
            i.projectId == param.projectId &&
            i.isDeleted == 0 &&
            i.id != param.excludeInvoiceId &&
            contractInvoiceTypes.contains(i.invoiceType))
        .toList()
      ..sort((a, b) => a.invoiceDate.compareTo(b.invoiceDate));

    final lines = <FinalInvoiceLine>[];
    var priorSubtotal = 0;
    var priorGst = 0;
    for (final i in prior) {
      priorSubtotal += i.subtotal;
      priorGst += i.tax1Amount;
      lines.add(FinalInvoiceLine(
        label: _lineLabels[i.invoiceType] ?? i.invoiceType,
        // Rows always carry a parseable ISO date; epoch is a last resort that
        // keeps a malformed row on the statement instead of dropping its amount.
        date: DateTime.tryParse(i.invoiceDate) ??
            DateTime.fromMillisecondsSinceEpoch(0),
        amountCents: i.subtotal + i.tax1Amount,
      ));
    }

    final contractPrice = project.projectPrice ?? 0;
    final contractGst = taxAmountCents(contractPrice, param.tax1Rate);

    return FinalInvoiceStatement(
      project: project,
      contractPriceCents: contractPrice,
      contractGstCents: contractGst,
      priorLines: lines,
      // Clamped with a conditional rather than num.clamp, which returns num and
      // would need an explicit int cast at every use site.
      subtotalCents:
          contractPrice - priorSubtotal < 0 ? 0 : contractPrice - priorSubtotal,
      gstCents: contractGst - priorGst < 0 ? 0 : contractGst - priorGst,
      tax1Name: param.tax1Name,
      tax1Rate: param.tax1Rate,
    );
  });
});

// ---------------------------------------------------------------------------
// Insert companion
// ---------------------------------------------------------------------------

/// Builds the `'final'` invoice insert companion from a reconciled [statement].
///
/// Writes the reconciled `subtotal`/`tax1Amount` verbatim — it does **not** run
/// [computeInvoiceTotals], because that would recompute GST as `rate × subtotal`
/// and discard the reconciliation. `invoiceNumber` is left blank for
/// `InvoiceCreateActions.createInvoice` to fill in-transaction.
InvoicesCompanion buildFinalInvoiceCompanion(
  FinalInvoiceStatement statement, {
  required DateTime date,
  String? poNumber,
  String? workDescription,
  String? notes,
  String? internalNotes,
}) {
  final project = statement.project;
  return InvoicesCompanion.insert(
    invoiceNumber: '',
    invoiceDate: date.toIso8601String(),
    clientId: project.clientId,
    projectId: project.id,
    projectAddress: Value(project.streetAddress),
    invoiceType: const Value('final'),
    subtotal: Value(statement.subtotalCents),
    tax1Name: Value(statement.tax1Name),
    tax1Rate: Value(statement.tax1Rate),
    tax1Amount: Value(statement.gstCents),
    totalAmount: Value(statement.balanceDueCents),
    poNumber: (poNumber ?? '').isEmpty ? const Value.absent() : Value(poNumber),
    workDescription: (workDescription ?? '').isEmpty
        ? const Value.absent()
        : Value(workDescription),
    notes: (notes ?? '').isEmpty ? const Value.absent() : Value(notes),
    internalNotes: (internalNotes ?? '').isEmpty
        ? const Value.absent()
        : Value(internalNotes),
  );
}

// ---------------------------------------------------------------------------
// helpers (invoice_providers.dart's copies are private to that library)
// ---------------------------------------------------------------------------

T? _firstOrNull<T>(Iterable<T> it) => it.isEmpty ? null : it.first;

AsyncValue<R> _combine<R>(List<AsyncValue<Object?>> values, R Function() build) {
  for (final v in values) {
    if (v.hasError) {
      return AsyncValue.error(v.error!, v.stackTrace ?? StackTrace.current);
    }
  }
  if (values.any((v) => !v.hasValue)) return AsyncValue<R>.loading();
  return AsyncValue.data(build());
}
