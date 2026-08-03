import 'dart:async';

import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/billing_calc.dart';
import '../../core/invoice_calc.dart';
import '../../data/local/drift/app_database.dart';
import '../../data/local/repositories/invoice_repository.dart';
import 'client_project_providers.dart';
import 'cost_entry_providers.dart';
import 'database_provider.dart';
import 'reference_data_providers.dart';
import 'time_entry_providers.dart';

// ---------------------------------------------------------------------------
// Repository + base streams
// ---------------------------------------------------------------------------

final invoiceRepositoryProvider = Provider<InvoiceRepository>((ref) {
  return InvoiceRepository(ref.watch(databaseProvider).invoicesDao);
});

final invoicesStreamProvider = StreamProvider<List<DbInvoice>>((ref) {
  return ref.watch(invoiceRepositoryProvider).watchAll();
});

final invoicePaymentsStreamProvider =
    StreamProvider<List<DbInvoicePayment>>((ref) {
  return ref.watch(databaseProvider).invoicePaymentsDao.watchAll();
});

final companySettingsStreamProvider =
    StreamProvider<DbCompanySetting?>((ref) {
  return ref.watch(databaseProvider).companySettingsDao.watchSettings();
});

// ---------------------------------------------------------------------------
// Derived status
// ---------------------------------------------------------------------------

enum InvoiceStatus { draft, sent, partial, paid, voided }

/// Single source of truth for "is this invoice fully paid", given [paidCents]
/// (the sum of its non-void payments — see [paidCentsByInvoice]).
///
/// 1-cent tolerance: v1 totals and payments were independently rounded from
/// dollars, so a genuinely fully-paid invoice can land a cent short.
bool isInvoiceFullyPaid(DbInvoice i, int paidCents) =>
    i.totalAmount > 0 && paidCents >= i.totalAmount - 1;

/// Derives an invoice's status from its flags plus [paidCents] — the sum of its
/// non-void payments (see [paidCentsByInvoice]).
InvoiceStatus invoiceStatusOf(DbInvoice i, int paidCents) {
  if (i.isDeleted != 0) return InvoiceStatus.voided;
  if (isInvoiceFullyPaid(i, paidCents)) return InvoiceStatus.paid;
  if (paidCents > 0) return InvoiceStatus.partial;
  if (i.isSent != 0) return InvoiceStatus.sent;
  return InvoiceStatus.draft;
}

/// Sums non-void payments per invoice id (in cents). Voided payments are
/// excluded so they no longer count toward an invoice's amount paid.
Map<int, int> paidCentsByInvoice(List<DbInvoicePayment> payments) {
  final byInvoice = <int, int>{};
  for (final p in payments) {
    if (p.isVoid != 0) continue;
    byInvoice[p.invoiceId] = (byInvoice[p.invoiceId] ?? 0) + p.amount;
  }
  return byInvoice;
}

/// Amount paid (sum of non-void payments, in cents) per invoice id. The single
/// source for the paid-cents rule — status/balance consumers read this instead
/// of re-summing payments themselves. Derived from [invoicePaymentsStreamProvider].
final paidCentsByInvoiceProvider = Provider<AsyncValue<Map<int, int>>>((ref) {
  return ref.watch(invoicePaymentsStreamProvider).whenData(paidCentsByInvoice);
});

// ---------------------------------------------------------------------------
// List: filter state + grouped rows
// ---------------------------------------------------------------------------

enum InvoiceTab { active, paid }

class InvoiceListFilter {
  const InvoiceListFilter({this.tab = InvoiceTab.active, this.showVoided = false});
  final InvoiceTab tab;
  final bool showVoided;

  InvoiceListFilter copyWith({InvoiceTab? tab, bool? showVoided}) =>
      InvoiceListFilter(tab: tab ?? this.tab, showVoided: showVoided ?? this.showVoided);
}

class InvoiceListFilterNotifier extends Notifier<InvoiceListFilter> {
  @override
  InvoiceListFilter build() => const InvoiceListFilter();

  void setTab(InvoiceTab tab) => state = state.copyWith(tab: tab);
  void toggleVoided(bool v) => state = state.copyWith(showVoided: v);
}

final invoiceListFilterProvider =
    NotifierProvider<InvoiceListFilterNotifier, InvoiceListFilter>(
  InvoiceListFilterNotifier.new,
);

class InvoiceListItem {
  const InvoiceListItem({
    required this.invoice,
    required this.clientName,
    required this.projectName,
    required this.status,
  });
  final DbInvoice invoice;
  final String clientName;
  final String projectName;
  final InvoiceStatus status;
}

class InvoiceProjectGroup {
  const InvoiceProjectGroup({
    required this.projectName,
    required this.items,
    required this.total,
  });
  final String projectName;
  final List<InvoiceListItem> items;
  final double total;
}

/// Filtered + grouped-by-project invoice rows for the list screen.
final invoiceRowsProvider = Provider<AsyncValue<List<InvoiceProjectGroup>>>((ref) {
  final invoicesA = ref.watch(invoicesStreamProvider);
  final paidA = ref.watch(paidCentsByInvoiceProvider);
  final clientsA = ref.watch(clientsStreamProvider);
  final projectsA = ref.watch(projectsStreamProvider);
  final filter = ref.watch(invoiceListFilterProvider);

  return _combine([invoicesA, paidA, clientsA, projectsA], () {
    final invoices = invoicesA.requireValue;
    final paid = paidA.requireValue;
    final clientName = {for (final c in clientsA.requireValue) c.id: c.name};
    final projectName = {
      for (final p in projectsA.requireValue) p.id: p.projectName
    };

    bool fullyPaid(DbInvoice i) => isInvoiceFullyPaid(i, paid[i.id] ?? 0);

    Iterable<DbInvoice> selected;
    if (filter.showVoided) {
      selected = invoices.where((i) => i.isDeleted != 0);
    } else if (filter.tab == InvoiceTab.paid) {
      selected = invoices.where((i) => i.isDeleted == 0 && fullyPaid(i));
    } else {
      selected = invoices.where((i) => i.isDeleted == 0 && !fullyPaid(i));
    }

    final items = selected
        .map((i) => InvoiceListItem(
              invoice: i,
              clientName: clientName[i.clientId] ?? '—',
              projectName: projectName[i.projectId] ?? 'No Project',
              status: invoiceStatusOf(i, paid[i.id] ?? 0),
            ))
        .toList()
      ..sort((a, b) => b.invoice.invoiceDate.compareTo(a.invoice.invoiceDate));

    final byProject = <String, List<InvoiceListItem>>{};
    for (final it in items) {
      byProject.putIfAbsent(it.projectName, () => []).add(it);
    }
    final names = byProject.keys.toList()..sort();
    return [
      for (final name in names)
        InvoiceProjectGroup(
          projectName: name,
          items: byProject[name]!,
          total: byProject[name]!
              .fold(0.0, (s, it) => s + it.invoice.totalAmount / 100),
        ),
    ];
  });
});

// ---------------------------------------------------------------------------
// Detail
// ---------------------------------------------------------------------------

class InvoiceDetailData {
  const InvoiceDetailData({
    required this.invoice,
    required this.payments,
    required this.clientName,
    required this.clientPhone,
    required this.projectName,
    required this.projectCity,
    required this.company,
    required this.status,
    required this.isFixedPrice,
    required this.contractValue,
    required this.totalBilled,
    required this.totalGstCollected,
    required this.paidCents,
  });

  final DbInvoice invoice;

  /// All payment rows for this invoice (void and non-void), newest-relevant
  /// order not guaranteed.
  final List<DbInvoicePayment> payments;
  final String clientName;
  final String? clientPhone;
  final String projectName;
  final String? projectCity;
  final DbCompanySetting? company;
  final InvoiceStatus status;

  final bool isFixedPrice;
  final double contractValue;
  final double totalBilled;
  final double totalGstCollected;

  /// Sum of non-void payments, in cents. Sourced from [paidCentsByInvoiceProvider]
  /// (the single paid-cents source), not re-derived from [payments] here.
  final int paidCents;

  double get balanceDue => (invoice.totalAmount - paidCents) / 100;

  double get remaining => contractValue - totalBilled;
  double get totalCollected => totalBilled + totalGstCollected;
}

final invoiceDetailProvider =
    Provider.family<AsyncValue<InvoiceDetailData?>, int>((ref, id) {
  final invoicesA = ref.watch(invoicesStreamProvider);
  final paymentsA = ref.watch(invoicePaymentsStreamProvider);
  final paidA = ref.watch(paidCentsByInvoiceProvider);
  final clientsA = ref.watch(clientsStreamProvider);
  final projectsA = ref.watch(projectsStreamProvider);
  final companyA = ref.watch(companySettingsStreamProvider);

  return _combine([invoicesA, paymentsA, paidA, clientsA, projectsA, companyA],
      () {
    final invoices = invoicesA.requireValue;
    final matches = invoices.where((i) => i.id == id);
    if (matches.isEmpty) return null;
    final inv = matches.first;

    final payments = paymentsA.requireValue
        .where((p) => p.invoiceId == id)
        .toList();
    final paidCents = paidA.requireValue[id] ?? 0;

    final client = _firstOrNull(
        clientsA.requireValue.where((c) => c.id == inv.clientId));
    final project = _firstOrNull(
        projectsA.requireValue.where((p) => p.id == inv.projectId));

    final isFixed =
        project?.pricingModel == 'fixed' && (project?.projectPrice ?? 0) > 0;
    final billed = isFixed
        ? fixedPriceBilled(invoices, inv.projectId)
        : (billedCents: 0, gstCents: 0);

    return InvoiceDetailData(
      invoice: inv,
      payments: payments,
      clientName: client?.name ?? '—',
      clientPhone: client?.phoneNumber,
      projectName: project?.projectName ?? '—',
      projectCity: project?.city,
      company: companyA.requireValue,
      status: invoiceStatusOf(inv, paidCents),
      isFixedPrice: isFixed,
      contractValue: (project?.projectPrice ?? 0) / 100,
      totalBilled: billed.billedCents / 100,
      totalGstCollected: billed.gstCents / 100,
      paidCents: paidCents,
    );
  });
});

// ---------------------------------------------------------------------------
// Actions (the only place that writes / orchestrates)
// ---------------------------------------------------------------------------

class InvoiceActions extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  InvoiceRepository get _repo => ref.read(invoiceRepositoryProvider);
  AppDatabase get _db => ref.read(databaseProvider);

  Future<void> markSent(DbInvoice inv) => _run(() async {
        await _repo.update(inv.toCompanion(false).copyWith(isSent: const Value(1)));
      });

  Future<void> recordPayment(
    DbInvoice inv, {
    required double amount,
    required String method,
    String? reference,
    required DateTime date,
    String? notes,
  }) =>
      _run(() async {
        final amountCents = (amount * 100).round();
        final now = DateTime.now().toIso8601String();
        await _db.invoicePaymentsDao.insertRow(
          InvoicePaymentsCompanion.insert(
            invoiceId: inv.id,
            amount: amountCents,
            paymentDate: date.toIso8601String(),
            paymentMethod: Value(method),
            paymentReference: Value(reference),
            paymentNotes: Value(notes),
            createdAt: now,
          ),
        );
      });

  Future<void> softDelete(
    DbInvoice inv, {
    required String reasonCode,
    String? notes,
  }) =>
      _run(() async {
        await _repo.update(inv.toCompanion(false).copyWith(
              isDeleted: const Value(1),
              deletedDate: Value(DateTime.now().toIso8601String()),
              deletedReasonCode: Value(reasonCode),
              deletedNotes: Value(notes),
            ));
        // Release linked records for extras (above-contract) invoices.
        if (inv.invoiceType == 'extras') {
          await _db.timeEntriesDao.clearInvoiceLink(inv.id);
          await _db.materialsDao.clearInvoiceLink(inv.id);
        }
      });

  Future<void> _run(Future<void> Function() op) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(op);
  }
}

final invoiceActionsProvider =
    NotifierProvider<InvoiceActions, AsyncValue<void>>(InvoiceActions.new);

// ---------------------------------------------------------------------------
// Fixed-price contract summary
// ---------------------------------------------------------------------------

/// Amount already drawn against a fixed-price contract: the sum of `subtotal`
/// and `tax1Amount` (in cents) across [projectId]'s non-deleted progress/deposit
/// invoices. Single source for both the detail screen and invoice creation.
/// D1: total amount invoiced to date for a project — the sum of `subtotal`
/// (cents) across **all non-deleted invoices** for the project, regardless of
/// `invoiceType` (T&M + fixed-price progress/deposit + extras). Used by the
/// analytics financial summary; distinct from [fixedPriceBilled], which is
/// scoped to fixed-price progress/deposit draws for the contract screens.
int invoicedToDate(List<DbInvoice> invoices, int projectId) {
  var billed = 0;
  for (final i in invoices) {
    if (i.projectId == projectId && i.isDeleted == 0) {
      billed += i.subtotal;
    }
  }
  return billed;
}

/// Amount invoiced as **'extras'** for a project: the sum of `subtotal` (cents)
/// across its non-deleted `invoiceType == 'extras'` invoices — the T&M /
/// Billable-coded work invoiced separately from a fixed-price contract's
/// progress/deposit draws. Used by the analytics summary to show a fixed-price
/// project's above-contract extras component distinct from its contract margin.
int extrasInvoicedToDate(List<DbInvoice> invoices, int projectId) {
  var billed = 0;
  for (final i in invoices) {
    if (i.projectId == projectId &&
        i.isDeleted == 0 &&
        i.invoiceType == 'extras') {
      billed += i.subtotal;
    }
  }
  return billed;
}

({int billedCents, int gstCents}) fixedPriceBilled(
    List<DbInvoice> invoices, int projectId) {
  var billed = 0;
  var gst = 0;
  for (final i in invoices) {
    if (i.projectId == projectId &&
        i.isDeleted == 0 &&
        contractInvoiceTypes.contains(i.invoiceType)) {
      billed += i.subtotal;
      gst += i.tax1Amount;
    }
  }
  return (billedCents: billed, gstCents: gst);
}

/// Contract snapshot for a fixed-price [projectId] — drives the create screen's
/// summary card. All money in cents.
class FixedPriceSummary {
  const FixedPriceSummary({
    required this.project,
    required this.clientName,
    required this.contractValueCents,
    required this.billedCents,
    required this.gstCollectedCents,
  });

  final DbProject project;
  final String clientName;
  final int contractValueCents;
  final int billedCents;
  final int gstCollectedCents;

  int get balanceRemainingCents => contractValueCents - billedCents;
}

/// Fixed-price contract summary for [projectId]. Null if the project is missing
/// or isn't a priced fixed-price project.
final fixedPriceSummaryProvider =
    Provider.family<AsyncValue<FixedPriceSummary?>, int>((ref, projectId) {
  final invoicesA = ref.watch(invoicesStreamProvider);
  final projectsA = ref.watch(projectsStreamProvider);
  final clientsA = ref.watch(clientsStreamProvider);

  return _combine([invoicesA, projectsA, clientsA], () {
    final project =
        _firstOrNull(projectsA.requireValue.where((p) => p.id == projectId));
    if (project == null ||
        project.pricingModel != 'fixed' ||
        (project.projectPrice ?? 0) <= 0) {
      return null;
    }
    final billed = fixedPriceBilled(invoicesA.requireValue, projectId);
    final clientName = _firstOrNull(
            clientsA.requireValue.where((c) => c.id == project.clientId))
        ?.name;
    return FixedPriceSummary(
      project: project,
      clientName: clientName ?? '—',
      contractValueCents: project.projectPrice ?? 0,
      billedCents: billed.billedCents,
      gstCollectedCents: billed.gstCents,
    );
  });
});

/// The next invoice number that would be generated, for live preview on the
/// create screen. The authoritative number is regenerated inside the create
/// transaction (see [InvoiceCreateActions.createInvoice]).
final nextInvoiceNumberProvider = Provider<AsyncValue<String>>((ref) {
  final invoicesA = ref.watch(invoicesStreamProvider);
  final companyA = ref.watch(companySettingsStreamProvider);
  return _combine([invoicesA, companyA], () {
    final company = companyA.requireValue;
    return nextInvoiceNumber(
      invoicesA.requireValue.map((i) => i.invoiceNumber),
      prefix: company?.invoicePrefix ?? 'INV',
      startingNumber: company?.invoiceStartingNumber ?? 1,
      year: DateTime.now().year,
    );
  });
});

// ---------------------------------------------------------------------------
// Invoice creation (transactional)
// ---------------------------------------------------------------------------

/// Creates an invoice and (optionally) marks the given time/material rows billed
/// to it, atomically. State is the new invoice id on success (for navigation),
/// null when idle.
class InvoiceCreateActions extends AsyncNotifier<int?> {
  @override
  FutureOr<int?> build() => null;

  AppDatabase get _db => ref.read(databaseProvider);

  /// Inserts [companion] and links [timeIds]/[materialIds] in one transaction.
  /// The invoice number is generated inside the transaction from current data
  /// (any `invoiceNumber` already on [companion] is overwritten) to avoid races.
  /// Returns the new id, or null if the write failed (see [state] for the error).
  Future<int?> createInvoice(
    InvoicesCompanion companion, {
    List<int> timeIds = const [],
    List<int> materialIds = const [],
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard<int?>(() {
      return _db.transaction(() async {
        final company = await _db.companySettingsDao.getSettings();
        final existing = await _db.invoicesDao.getAll();
        final number = nextInvoiceNumber(
          existing.map((i) => i.invoiceNumber),
          prefix: company.invoicePrefix,
          startingNumber: company.invoiceStartingNumber,
          // Numbered by the year it's issued (matching v1), not by the invoice
          // date — a back-dated invoice still takes a current-year number.
          year: DateTime.now().year,
        );
        final id = await _db.invoicesDao
            .insertRow(companion.copyWith(invoiceNumber: Value(number)));
        await _db.timeEntriesDao.markBilled(timeIds, id);
        await _db.materialsDao.markBilled(materialIds, id);
        return id;
      });
    });
    return state.maybeWhen(data: (v) => v, orElse: () => null);
  }
}

final invoiceCreateActionsProvider =
    AsyncNotifierProvider.autoDispose<InvoiceCreateActions, int?>(
  InvoiceCreateActions.new,
);

// ---------------------------------------------------------------------------
// Fixed-price invoice form (all state + validation live here, not in a widget)
// ---------------------------------------------------------------------------

/// Immutable state for the Fixed Price Invoice form. Holds every field value
/// plus validation/totals. Text controllers live in the widget layer
/// ([FixedPriceInvoiceScreen]); this notifier owns only raw state.
class FixedPriceFormState {
  const FixedPriceFormState({
    required this.invoiceType,
    required this.date,
    required this.amountCents,
    required this.poNumber,
    required this.workDescription,
    required this.notes,
    required this.internalNotes,
    required this.tax1Name,
    required this.tax1Rate,
    required this.tax2Enabled,
    required this.tax2Name,
    required this.tax2Rate,
    required this.seeded,
  });

  // 'deposit' | 'progress' | 'final'. For 'final' the amount is not entered at
  // all — it's reconciled (see `final_invoice_providers.dart`), so `amountCents`
  // and `totals` below are unused on that path.
  final String invoiceType;
  final DateTime date;
  final int amountCents;
  final String poNumber;
  final String workDescription;

  /// Client-facing notes. Printed as its own PDF section whenever non-empty,
  /// independent of [workDescription] (see `InvoicePdfService._notes`). NB this
  /// diverges from v1, where `notes` only backfilled an empty work description.
  final String notes;

  /// Never printed on the invoice; shown on the detail screen only.
  final String internalNotes;
  final String tax1Name;
  final double tax1Rate;
  final bool tax2Enabled;
  final String tax2Name;
  final double tax2Rate;

  /// Whether tax defaults have been prefilled from company settings yet.
  final bool seeded;

  bool get isValid => amountCents > 0;
  String? get amountError => amountCents > 0 ? null : 'Enter an amount';

  InvoiceTotals get totals => computeInvoiceTotals(
        subtotalCents: amountCents,
        tax1Rate: tax1Rate,
        tax2Rate: tax2Enabled ? tax2Rate : null,
      );

  FixedPriceFormState copyWith({
    String? invoiceType,
    DateTime? date,
    int? amountCents,
    String? poNumber,
    String? workDescription,
    String? notes,
    String? internalNotes,
    String? tax1Name,
    double? tax1Rate,
    bool? tax2Enabled,
    String? tax2Name,
    double? tax2Rate,
    bool? seeded,
  }) =>
      FixedPriceFormState(
        invoiceType: invoiceType ?? this.invoiceType,
        date: date ?? this.date,
        amountCents: amountCents ?? this.amountCents,
        poNumber: poNumber ?? this.poNumber,
        workDescription: workDescription ?? this.workDescription,
        notes: notes ?? this.notes,
        internalNotes: internalNotes ?? this.internalNotes,
        tax1Name: tax1Name ?? this.tax1Name,
        tax1Rate: tax1Rate ?? this.tax1Rate,
        tax2Enabled: tax2Enabled ?? this.tax2Enabled,
        tax2Name: tax2Name ?? this.tax2Name,
        tax2Rate: tax2Rate ?? this.tax2Rate,
        seeded: seeded ?? this.seeded,
      );
}

/// Holds the Fixed Price Invoice form's raw state + validation only. Text
/// controllers are owned by the widget layer (see [FixedPriceInvoiceScreen]),
/// which pushes edits in through the setters below.
class FixedPriceInvoiceForm extends Notifier<FixedPriceFormState> {
  @override
  FixedPriceFormState build() => FixedPriceFormState(
        invoiceType: 'progress',
        date: DateTime.now(),
        amountCents: 0,
        poNumber: '',
        workDescription: '',
        notes: '',
        internalNotes: '',
        tax1Name: 'GST',
        tax1Rate: 0,
        tax2Enabled: false,
        tax2Name: '',
        tax2Rate: 0,
        seeded: false,
      );

  /// One-time prefill of tax fields from company defaults. No-op once seeded.
  ///
  /// NB unit mismatch: company `defaultTax*Rate` is stored as a FRACTION
  /// (0.05 = 5%), whereas invoices store tax rates as a PERCENT (5.0). The form
  /// works in percent, so multiply by 100 here.
  void seedFromCompany(DbCompanySetting? c) {
    if (state.seeded || c == null) return;
    state = state.copyWith(
      tax1Name: c.defaultTax1Name,
      tax1Rate: c.defaultTax1Rate * 100,
      tax2Enabled: c.defaultTax2Rate != null,
      tax2Name: c.defaultTax2Name ?? '',
      tax2Rate: (c.defaultTax2Rate ?? 0) * 100,
      seeded: true,
    );
  }

  void setType(String t) => state = state.copyWith(invoiceType: t);
  void setDate(DateTime d) => state = state.copyWith(date: d);
  void setAmountText(String s) =>
      state = state.copyWith(amountCents: _parseCents(s));
  void setPoNumber(String s) => state = state.copyWith(poNumber: s);
  void setWorkDescription(String s) =>
      state = state.copyWith(workDescription: s);
  void setNotes(String s) => state = state.copyWith(notes: s);
  void setInternalNotes(String s) => state = state.copyWith(internalNotes: s);
  void setTax1Name(String s) => state = state.copyWith(tax1Name: s);
  void setTax1Rate(String s) =>
      state = state.copyWith(tax1Rate: double.tryParse(s.trim()) ?? 0);
  void toggleTax2(bool v) => state = state.copyWith(tax2Enabled: v);
  void setTax2Name(String s) => state = state.copyWith(tax2Name: s);
  void setTax2Rate(String s) =>
      state = state.copyWith(tax2Rate: double.tryParse(s.trim()) ?? 0);

  /// Builds the insert companion for [project] from the current form state.
  /// `invoiceNumber` is left blank — the create action fills it in-transaction.
  InvoicesCompanion buildCompanion(DbProject project) {
    final s = state;
    final t = s.totals;
    final po = s.poNumber.trim();
    final desc = s.workDescription.trim();
    final note = s.notes.trim();
    final internal = s.internalNotes.trim();
    return InvoicesCompanion.insert(
      invoiceNumber: '',
      invoiceDate: s.date.toIso8601String(),
      clientId: project.clientId,
      projectId: project.id,
      projectAddress: Value(project.streetAddress),
      invoiceType: Value(s.invoiceType),
      subtotal: Value(t.subtotal),
      tax1Name: Value(s.tax1Name),
      tax1Rate: Value(s.tax1Rate),
      tax1Amount: Value(t.tax1),
      tax2Name: s.tax2Enabled ? Value(s.tax2Name) : const Value.absent(),
      tax2Rate: s.tax2Enabled ? Value(s.tax2Rate) : const Value.absent(),
      tax2Amount: Value(t.tax2),
      totalAmount: Value(t.total),
      poNumber: po.isEmpty ? const Value.absent() : Value(po),
      workDescription: desc.isEmpty ? const Value.absent() : Value(desc),
      notes: note.isEmpty ? const Value.absent() : Value(note),
      internalNotes:
          internal.isEmpty ? const Value.absent() : Value(internal),
    );
  }

  static int _parseCents(String s) {
    final cleaned = s.replaceAll(',', '').replaceAll(r'$', '').trim();
    final d = double.tryParse(cleaned);
    if (d == null || d < 0) return 0;
    return (d * 100).round();
  }
}

final fixedPriceInvoiceFormProvider =
    NotifierProvider.autoDispose<FixedPriceInvoiceForm, FixedPriceFormState>(
  FixedPriceInvoiceForm.new,
);

// ---------------------------------------------------------------------------
// Time & Materials invoice — resolved candidate lines
// ---------------------------------------------------------------------------

/// A billable unbilled time entry, with its computed value (cents).
class TmTimeLine {
  const TmTimeLine({
    required this.id,
    required this.label,
    required this.hours,
    required this.valueCents,
    required this.rateCents,
  });
  final int id;
  final String label;
  final double hours;
  final int valueCents;

  /// The resolved hourly rate this line was valued at (see `hourlyRateCents`).
  /// Carried so the creation screen can label the Labour total with the rate
  /// actually in effect, instead of dividing value by hours and inheriting the
  /// rounding. Screen-only — never printed on the invoice.
  final int rateCents;
}

/// A billable unbilled material/expense, with raw cost and marked-up billable
/// amount (both cents).
class TmMaterialLine {
  const TmMaterialLine({
    required this.id,
    required this.label,
    required this.costCents,
    required this.billableCents,
  });
  final int id;
  final String label;
  final int costCents;
  final int billableCents;
}

/// Resolved candidate lines for a Time & Materials invoice on a project: the
/// unbilled time entries and (non-company-expense) materials, each with its
/// billable value computed via `billing_calc`.
class TmInvoiceLines {
  const TmInvoiceLines({
    required this.project,
    required this.clientName,
    required this.timeLines,
    required this.materialLines,
    required this.markupPercent,
  });
  final DbProject project;
  final String clientName;
  final List<TmTimeLine> timeLines;
  final List<TmMaterialLine> materialLines;

  /// The project's effective expense markup, in percent — the difference between
  /// a material line's [TmMaterialLine.costCents] (what the picker shows) and its
  /// [TmMaterialLine.billableCents] (what the invoice bills).
  ///
  /// Derived here rather than in the widget so the markup rule stays in the
  /// provider layer; the picker only displays it. 0 means cost is billed as-is,
  /// so there is nothing to disclose.
  final double markupPercent;

  bool get isEmpty => timeLines.isEmpty && materialLines.isEmpty;
}

/// The unbilled time entries and materials **eligible for Time & Materials
/// invoicing** on a project: the raw unbilled streams filtered to entries whose
/// cost code has `is_billable = 1` (currently only "Billable"). Entries coded
/// Contract Work / No Charge / Internal, or with no cost code at all, are
/// excluded — they must never appear as selectable T&M line items.
///
/// This is the SINGLE SOURCE OF TRUTH for T&M invoiceability, applied
/// identically to T&M and fixed-price projects. On a fixed-price project these
/// are the above-contract "extras"; Contract Work is excluded because it's
/// already covered by the contract price — which is what makes opening
/// fixed-price projects to the T&M picker safe from double-billing.
class InvoiceableEntries {
  const InvoiceableEntries({required this.timeEntries, required this.materials});

  final List<DbTimeEntry> timeEntries;
  final List<DbMaterial> materials;

  bool get isEmpty => timeEntries.isEmpty && materials.isEmpty;
}

/// Invoiceable (unbilled + `is_billable`-coded) time entries and materials for
/// [projectId]. The ONE place the T&M `is_billable` rule lives; every
/// invoice-selection consumer reads this rather than the raw unbilled streams.
final invoiceableEntriesProvider =
    Provider.family<AsyncValue<InvoiceableEntries>, int>((ref, projectId) {
  final timeA = ref.watch(unbilledTimeEntriesProvider(projectId));
  final materialsA = ref.watch(unbilledMaterialsProvider(projectId));
  final costCodesA = ref.watch(costCodesStreamProvider);

  return _combine([timeA, materialsA, costCodesA], () {
    final billableCostCodeIds = <int>{
      for (final c in costCodesA.requireValue)
        if (c.isBillable == 1) c.id,
    };
    bool invoiceable(int? costCodeId) =>
        costCodeId != null && billableCostCodeIds.contains(costCodeId);
    return InvoiceableEntries(
      timeEntries:
          timeA.requireValue.where((e) => invoiceable(e.costCodeId)).toList(),
      materials: materialsA.requireValue
          .where((m) => invoiceable(m.costCodeId))
          .toList(),
    );
  });
});

/// Resolved candidate T&M lines for [projectId]: consumes
/// [invoiceableEntriesProvider] (so the `is_billable` filter is already applied)
/// and computes each line's billable value + label. Company-expense materials
/// (`isCompanyExpense != 0`) are excluded — never billable. Null if the project
/// is missing.
final tmInvoiceLinesProvider =
    Provider.family<AsyncValue<TmInvoiceLines?>, int>((ref, projectId) {
  final invoiceableA = ref.watch(invoiceableEntriesProvider(projectId));
  final projectsA = ref.watch(projectsStreamProvider);
  final clientsA = ref.watch(clientsStreamProvider);
  final employeesA = ref.watch(employeesStreamProvider);
  final rolesA = ref.watch(rolesStreamProvider);
  final costCodesA = ref.watch(costCodesStreamProvider);
  final settingsA = ref.watch(appSettingsStreamProvider);

  return _combine([
    invoiceableA,
    projectsA,
    clientsA,
    employeesA,
    rolesA,
    costCodesA,
    settingsA,
  ], () {
    final project =
        _firstOrNull(projectsA.requireValue.where((p) => p.id == projectId));
    if (project == null) return null;

    final employeeById = {for (final e in employeesA.requireValue) e.id: e};
    final roleById = {for (final r in rolesA.requireValue) r.id: r};
    final companyDefaultRateCents = settingsA.requireValue?.companyHourlyRate;
    final costCodeById = {for (final c in costCodesA.requireValue) c.id: c};
    final clientName =
        _firstOrNull(clientsA.requireValue.where((c) => c.id == project.clientId))
            ?.name;
    final markup = effectiveMarkupPercent(project);
    final invoiceable = invoiceableA.requireValue;

    final timeLines = <TmTimeLine>[];
    for (final e in invoiceable.timeEntries) {
      final billedSeconds = (e.finalBilledDurationSeconds ?? 0).toDouble();
      final rateCents = hourlyRateCents(
        project,
        e.employeeId,
        employeeById,
        roleById,
        companyDefaultRateCents: companyDefaultRateCents,
      );
      final parts = <String>['${(billedSeconds / 3600).toStringAsFixed(2)} h'];
      final emp = e.employeeId == null ? null : employeeById[e.employeeId];
      if (emp != null) parts.add(emp.name);
      final cc = e.costCodeId == null ? null : costCodeById[e.costCodeId];
      if (cc != null) parts.add(cc.name);
      if ((e.workDetails ?? '').isNotEmpty) parts.add(e.workDetails!);
      timeLines.add(TmTimeLine(
        id: e.id,
        label: parts.join(' · '),
        hours: billedSeconds / 3600,
        valueCents: labourValueCents(rateCents, billedSeconds),
        rateCents: rateCents,
      ));
    }

    final materialLines = <TmMaterialLine>[];
    for (final m in invoiceable.materials) {
      if (m.isCompanyExpense != 0) continue; // never billable on T&M
      final cc = m.costCodeId == null ? null : costCodeById[m.costCodeId];
      materialLines.add(TmMaterialLine(
        id: m.id,
        label: cc == null ? m.itemName : '${m.itemName} · ${cc.name}',
        costCents: m.cost,
        billableCents: markedUpCostCents(m.cost, markup),
      ));
    }

    return TmInvoiceLines(
      project: project,
      clientName: clientName ?? '—',
      timeLines: timeLines,
      materialLines: materialLines,
      markupPercent: markup,
    );
  });
});

// ---------------------------------------------------------------------------
// Time & Materials invoice form (state + validation; controllers in the widget)
// ---------------------------------------------------------------------------

/// Immutable state for the Time & Materials form. Selection + discount/tax/meta
/// values; the actual line values come from [tmInvoiceLinesProvider] and are
/// passed into [TimeMaterialsInvoiceForm.totalsFor] / `buildCompanion`.
class TmInvoiceFormState {
  const TmInvoiceFormState({
    required this.selectedTimeIds,
    required this.selectedMaterialIds,
    required this.date,
    required this.poNumber,
    required this.workDescription,
    required this.notes,
    required this.internalNotes,
    required this.discountAmountCents,
    required this.discountPercent,
    required this.discountDescription,
    required this.tax1Name,
    required this.tax1Rate,
    required this.tax2Enabled,
    required this.tax2Name,
    required this.tax2Rate,
    required this.seeded,
  });

  final Set<int> selectedTimeIds;
  final Set<int> selectedMaterialIds;
  final DateTime date;
  final String poNumber;
  final String workDescription;

  /// Client-facing notes — printed as its own section whenever non-empty; see
  /// [FixedPriceFormState.notes].
  final String notes;

  /// Never printed on the invoice; detail screen only.
  final String internalNotes;
  final int discountAmountCents;
  final double discountPercent;
  final String discountDescription;
  final String tax1Name;
  final double tax1Rate;
  final bool tax2Enabled;
  final String tax2Name;
  final double tax2Rate;
  final bool seeded;

  bool get isValid =>
      selectedTimeIds.isNotEmpty || selectedMaterialIds.isNotEmpty;

  TmInvoiceFormState copyWith({
    Set<int>? selectedTimeIds,
    Set<int>? selectedMaterialIds,
    DateTime? date,
    String? poNumber,
    String? workDescription,
    String? notes,
    String? internalNotes,
    int? discountAmountCents,
    double? discountPercent,
    String? discountDescription,
    String? tax1Name,
    double? tax1Rate,
    bool? tax2Enabled,
    String? tax2Name,
    double? tax2Rate,
    bool? seeded,
  }) =>
      TmInvoiceFormState(
        selectedTimeIds: selectedTimeIds ?? this.selectedTimeIds,
        selectedMaterialIds: selectedMaterialIds ?? this.selectedMaterialIds,
        date: date ?? this.date,
        poNumber: poNumber ?? this.poNumber,
        workDescription: workDescription ?? this.workDescription,
        notes: notes ?? this.notes,
        internalNotes: internalNotes ?? this.internalNotes,
        discountAmountCents: discountAmountCents ?? this.discountAmountCents,
        discountPercent: discountPercent ?? this.discountPercent,
        discountDescription: discountDescription ?? this.discountDescription,
        tax1Name: tax1Name ?? this.tax1Name,
        tax1Rate: tax1Rate ?? this.tax1Rate,
        tax2Enabled: tax2Enabled ?? this.tax2Enabled,
        tax2Name: tax2Name ?? this.tax2Name,
        tax2Rate: tax2Rate ?? this.tax2Rate,
        seeded: seeded ?? this.seeded,
      );
}

/// Raw state + validation for the T&M form. Text controllers live in the widget
/// (see `TimeMaterialsInvoiceScreen`); selection is toggled through here.
class TimeMaterialsInvoiceForm extends Notifier<TmInvoiceFormState> {
  @override
  TmInvoiceFormState build() => TmInvoiceFormState(
        selectedTimeIds: const {},
        selectedMaterialIds: const {},
        date: DateTime.now(),
        poNumber: '',
        workDescription: '',
        notes: '',
        internalNotes: '',
        discountAmountCents: 0,
        discountPercent: 0,
        discountDescription: '',
        tax1Name: 'GST',
        tax1Rate: 0,
        tax2Enabled: false,
        tax2Name: '',
        tax2Rate: 0,
        seeded: false,
      );

  /// One-time tax prefill from company defaults (fraction → percent, ×100).
  void seedFromCompany(DbCompanySetting? c) {
    if (state.seeded || c == null) return;
    state = state.copyWith(
      tax1Name: c.defaultTax1Name,
      tax1Rate: c.defaultTax1Rate * 100,
      tax2Enabled: c.defaultTax2Rate != null,
      tax2Name: c.defaultTax2Name ?? '',
      tax2Rate: (c.defaultTax2Rate ?? 0) * 100,
      seeded: true,
    );
  }

  void toggleTime(int id) {
    final s = {...state.selectedTimeIds};
    if (!s.add(id)) s.remove(id);
    state = state.copyWith(selectedTimeIds: s);
  }

  void toggleMaterial(int id) {
    final s = {...state.selectedMaterialIds};
    if (!s.add(id)) s.remove(id);
    state = state.copyWith(selectedMaterialIds: s);
  }

  void setAllTime(Iterable<int> ids, bool select) {
    final s = {...state.selectedTimeIds};
    select ? s.addAll(ids) : s.removeAll(ids);
    state = state.copyWith(selectedTimeIds: s);
  }

  void setAllMaterials(Iterable<int> ids, bool select) {
    final s = {...state.selectedMaterialIds};
    select ? s.addAll(ids) : s.removeAll(ids);
    state = state.copyWith(selectedMaterialIds: s);
  }

  void setDate(DateTime d) => state = state.copyWith(date: d);
  void setPoNumber(String s) => state = state.copyWith(poNumber: s);
  void setWorkDescription(String s) =>
      state = state.copyWith(workDescription: s);
  void setNotes(String s) => state = state.copyWith(notes: s);
  void setInternalNotes(String s) => state = state.copyWith(internalNotes: s);
  void setDiscountAmountText(String s) =>
      state = state.copyWith(discountAmountCents: _parseCents(s));
  void setDiscountPercentText(String s) =>
      state = state.copyWith(discountPercent: double.tryParse(s.trim()) ?? 0);
  void setDiscountDescription(String s) =>
      state = state.copyWith(discountDescription: s);
  void setTax1Name(String s) => state = state.copyWith(tax1Name: s);
  void setTax1Rate(String s) =>
      state = state.copyWith(tax1Rate: double.tryParse(s.trim()) ?? 0);
  void toggleTax2(bool v) => state = state.copyWith(tax2Enabled: v);
  void setTax2Name(String s) => state = state.copyWith(tax2Name: s);
  void setTax2Rate(String s) =>
      state = state.copyWith(tax2Rate: double.tryParse(s.trim()) ?? 0);

  /// Effective discount in cents for a [subtotalCents] base: flat amount plus
  /// the percent applied to the subtotal.
  int discountCentsFor(int subtotalCents) =>
      state.discountAmountCents +
      (subtotalCents * state.discountPercent / 100).round();

  /// Totals for the given selected [labourCents]/[materialsCents] subtotals.
  InvoiceTotals totalsFor(int labourCents, int materialsCents) {
    final subtotal = labourCents + materialsCents;
    return computeInvoiceTotals(
      subtotalCents: subtotal,
      discountCents: discountCentsFor(subtotal),
      tax1Rate: state.tax1Rate,
      tax2Rate: state.tax2Enabled ? state.tax2Rate : null,
    );
  }

  /// Builds the `'extras'` insert companion from the selected subtotals.
  /// `invoiceNumber` is filled in-transaction by the create action.
  InvoicesCompanion buildCompanion(
    DbProject project, {
    required int labourCents,
    required int materialsCents,
  }) {
    final s = state;
    final subtotal = labourCents + materialsCents;
    final discount = discountCentsFor(subtotal);
    final t = totalsFor(labourCents, materialsCents);
    final po = s.poNumber.trim();
    final desc = s.workDescription.trim();
    final note = s.notes.trim();
    final internal = s.internalNotes.trim();
    final discDesc = s.discountDescription.trim();
    return InvoicesCompanion.insert(
      invoiceNumber: '',
      invoiceDate: s.date.toIso8601String(),
      clientId: project.clientId,
      projectId: project.id,
      projectAddress: Value(project.streetAddress),
      invoiceType: const Value('extras'),
      labourSubtotal: Value(labourCents),
      materialsSubtotal: Value(materialsCents),
      subtotal: Value(subtotal),
      discountAmount: Value(discount),
      discountPercent: Value(s.discountPercent),
      discountDescription:
          discDesc.isEmpty ? const Value.absent() : Value(discDesc),
      tax1Name: Value(s.tax1Name),
      tax1Rate: Value(s.tax1Rate),
      tax1Amount: Value(t.tax1),
      tax2Name: s.tax2Enabled ? Value(s.tax2Name) : const Value.absent(),
      tax2Rate: s.tax2Enabled ? Value(s.tax2Rate) : const Value.absent(),
      tax2Amount: Value(t.tax2),
      totalAmount: Value(t.total),
      poNumber: po.isEmpty ? const Value.absent() : Value(po),
      workDescription: desc.isEmpty ? const Value.absent() : Value(desc),
      notes: note.isEmpty ? const Value.absent() : Value(note),
      internalNotes:
          internal.isEmpty ? const Value.absent() : Value(internal),
    );
  }

  static int _parseCents(String s) {
    final cleaned = s.replaceAll(',', '').replaceAll(r'$', '').trim();
    final d = double.tryParse(cleaned);
    if (d == null || d < 0) return 0;
    return (d * 100).round();
  }
}

final timeMaterialsInvoiceFormProvider =
    NotifierProvider.autoDispose<TimeMaterialsInvoiceForm, TmInvoiceFormState>(
  TimeMaterialsInvoiceForm.new,
);

// ---------------------------------------------------------------------------
// helpers
// ---------------------------------------------------------------------------

T? _firstOrNull<T>(Iterable<T> it) => it.isEmpty ? null : it.first;

/// Propagates the first error, stays loading until all have data, then builds.
AsyncValue<R> _combine<R>(List<AsyncValue<Object?>> values, R Function() build) {
  for (final v in values) {
    if (v.hasError) {
      return AsyncValue.error(v.error!, v.stackTrace ?? StackTrace.current);
    }
  }
  if (values.any((v) => !v.hasValue)) return AsyncValue<R>.loading();
  return AsyncValue.data(build());
}
