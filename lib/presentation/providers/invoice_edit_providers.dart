import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/billing_calc.dart';
import '../../core/invoice_calc.dart';
import '../../data/local/drift/app_database.dart';
import 'cost_entry_providers.dart';
import 'database_provider.dart';
import 'invoice_providers.dart';
import 'reference_data_providers.dart';

/// Editing an existing invoice — the read models + write action that Issue 1
/// (edit button) and Issue 3 (in-place T&M edit) run on. Deliberately kept out
/// of the already-large `invoice_providers.dart`.
///
/// Snapshot policy: v2 stores no per-line billed value, so we never silently
/// reflow an existing line at a changed rate. Instead we detect *drift* — the
/// invoice's stored `labourSubtotal`/`materialsSubtotal` vs a live recompute of
/// the same billed lines — and block a line-changing save until the user
/// resolves it. See [EditableTmInvoiceData].

// ---------------------------------------------------------------------------
// Stream reads: the lines already billed to an invoice
// ---------------------------------------------------------------------------

final billedTimeForInvoiceProvider =
    StreamProvider.family<List<DbTimeEntry>, int>((ref, invoiceId) {
  return ref.watch(databaseProvider).timeEntriesDao.watchByInvoice(invoiceId);
});

final billedMaterialsForInvoiceProvider =
    StreamProvider.family<List<DbMaterial>, int>((ref, invoiceId) {
  return ref.watch(databaseProvider).materialsDao.watchByInvoice(invoiceId);
});

// ---------------------------------------------------------------------------
// Editable T&M lines: (unbilled invoiceable) ∪ (already billed to this invoice)
// ---------------------------------------------------------------------------

/// The candidate lines for editing a T&M invoice plus everything needed to run
/// the drift check. [lines] is the union rendered in the picker; the lines
/// already on this invoice are pre-selected via [billedTimeIds]/[billedMaterialIds].
class EditableTmInvoiceData {
  const EditableTmInvoiceData({
    required this.invoice,
    required this.lines,
    required this.billedTimeIds,
    required this.billedMaterialIds,
    required this.liveBilledLabourCents,
    required this.liveBilledMaterialsCents,
    required this.paidCents,
  });

  final DbInvoice invoice;

  /// Union of the project's unbilled invoiceable lines and the lines currently
  /// billed to [invoice]. Billed lines come first.
  final TmInvoiceLines lines;

  /// Ids currently billed to this invoice (the initial selection).
  final Set<int> billedTimeIds;
  final Set<int> billedMaterialIds;

  /// Live-recomputed subtotal of the *currently billed* lines only, at today's
  /// rates/markup. Compared against the invoice's stored subtotals to detect
  /// drift.
  final int liveBilledLabourCents;
  final int liveBilledMaterialsCents;

  /// Sum of non-void payments (cents) — for the shrink-below-paid guard preview.
  final int paidCents;

  bool get driftLabour => liveBilledLabourCents != invoice.labourSubtotal;
  bool get driftMaterials => liveBilledMaterialsCents != invoice.materialsSubtotal;
  bool get hasDrift => driftLabour || driftMaterials;

  /// The lines currently billed to this invoice.
  Iterable<TmTimeLine> get billedTimeLines =>
      lines.timeLines.where((l) => billedTimeIds.contains(l.id));

  /// Hours on the billed lines.
  double get billedHours =>
      billedTimeLines.fold<double>(0, (s, l) => s + l.hours);

  /// The hourly rate the STORED `labourSubtotal` implies, in cents. Derived by
  /// division because v2 keeps no per-line billed value — so it is an AVERAGE
  /// across the billed lines and not necessarily any single line's original
  /// rate. Present it as approximate. Null when there are no billed hours.
  int? get billedLabourRateCents {
    final h = billedHours;
    if (h <= 0) return null;
    return (invoice.labourSubtotal / h).round();
  }

  /// The rate those same lines resolve to TODAY (see `hourlyRateCents`), or null
  /// when they no longer share a single rate — e.g. a crew on differing role
  /// rates, where no one figure describes the invoice.
  int? get currentLabourRateCents {
    final rates = <int>{for (final l in billedTimeLines) l.rateCents};
    return rates.length == 1 ? rates.single : null;
  }
}

/// Editable-lines model for invoice [param.invoiceId] on project
/// [param.projectId]. Reuses [tmInvoiceLinesProvider] for the unbilled side and
/// the billed streams for this invoice's own lines, so both are reactive (no
/// FutureProvider). Null if the project or invoice can't be resolved.
final editableTmInvoiceLinesProvider = Provider.family<
    AsyncValue<EditableTmInvoiceData?>,
    ({int projectId, int invoiceId})>((ref, param) {
  final unbilledA = ref.watch(tmInvoiceLinesProvider(param.projectId));
  final billedTimeA = ref.watch(billedTimeForInvoiceProvider(param.invoiceId));
  final billedMatA = ref.watch(billedMaterialsForInvoiceProvider(param.invoiceId));
  final invoicesA = ref.watch(invoicesStreamProvider);
  final employeesA = ref.watch(employeesStreamProvider);
  final rolesA = ref.watch(rolesStreamProvider);
  final costCodesA = ref.watch(costCodesStreamProvider);
  final paidA = ref.watch(paidCentsByInvoiceProvider);
  final settingsA = ref.watch(appSettingsStreamProvider);

  return _combine([
    unbilledA,
    billedTimeA,
    billedMatA,
    invoicesA,
    employeesA,
    rolesA,
    costCodesA,
    paidA,
    settingsA,
  ], () {
    final unbilled = unbilledA.requireValue;
    if (unbilled == null) return null;
    final inv = _firstOrNull(
        invoicesA.requireValue.where((i) => i.id == param.invoiceId));
    if (inv == null) return null;

    final project = unbilled.project;
    final employeeById = {for (final e in employeesA.requireValue) e.id: e};
    final roleById = {for (final r in rolesA.requireValue) r.id: r};
    final costCodeById = {for (final c in costCodesA.requireValue) c.id: c};
    final companyDefaultRateCents = settingsA.requireValue?.companyHourlyRate;
    final markup = effectiveMarkupPercent(project);

    // Value the lines already billed to this invoice, at today's rates — the
    // same math the create flow used, so an unchanged line reconciles exactly.
    final billedTimeLines = <TmTimeLine>[];
    for (final e in billedTimeA.requireValue.where((e) => e.isDeleted == 0)) {
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
      billedTimeLines.add(TmTimeLine(
        id: e.id,
        label: parts.join(' · '),
        hours: billedSeconds / 3600,
        valueCents: labourValueCents(rateCents, billedSeconds),
        rateCents: rateCents,
      ));
    }

    final billedMatLines = <TmMaterialLine>[];
    for (final m in billedMatA.requireValue
        .where((m) => m.isDeleted == 0 && m.isCompanyExpense == 0)) {
      final cc = m.costCodeId == null ? null : costCodeById[m.costCodeId];
      billedMatLines.add(TmMaterialLine(
        id: m.id,
        label: cc == null ? m.itemName : '${m.itemName} · ${cc.name}',
        costCents: m.cost,
        billableCents: markedUpCostCents(m.cost, markup),
      ));
    }

    final billedTimeIds = {for (final l in billedTimeLines) l.id};
    final billedMaterialIds = {for (final l in billedMatLines) l.id};

    return EditableTmInvoiceData(
      invoice: inv,
      lines: TmInvoiceLines(
        project: project,
        clientName: unbilled.clientName,
        timeLines: [...billedTimeLines, ...unbilled.timeLines],
        materialLines: [...billedMatLines, ...unbilled.materialLines],
        markupPercent: markup,
      ),
      billedTimeIds: billedTimeIds,
      billedMaterialIds: billedMaterialIds,
      liveBilledLabourCents:
          billedTimeLines.fold(0, (s, l) => s + l.valueCents),
      liveBilledMaterialsCents:
          billedMatLines.fold(0, (s, l) => s + l.billableCents),
      paidCents: paidA.requireValue[param.invoiceId] ?? 0,
    );
  });
});

// ---------------------------------------------------------------------------
// Update action (the only writer here)
// ---------------------------------------------------------------------------

/// Thrown by the edit action for a rule the user must resolve (e.g. reducing the
/// total below what's already been paid). Its [message] is shown verbatim.
class InvoiceEditException implements Exception {
  const InvoiceEditException(this.message);
  final String message;
  @override
  String toString() => message;
}

class InvoiceEditActions extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  AppDatabase get _db => ref.read(databaseProvider);

  /// Sum of non-void payments (cents) for [invoiceId].
  Future<int> _paidCents(int invoiceId) async {
    final payments = await _db.invoicePaymentsDao.getByInvoice(invoiceId);
    return payments
        .where((p) => p.isVoid == 0)
        .fold<int>(0, (s, p) => s + p.amount);
  }

  /// In-place edit of a T&M (`'extras'`) invoice. Recomputes totals from the
  /// passed [labourCents]/[materialsCents] (the caller decides whether those are
  /// the stored aggregates — metadata-only edit — or a live re-sum of a changed
  /// selection), then release-all-then-relink the line links. Payments are never
  /// touched, so `balanceDue` recomputes off the new total. Aborts before any
  /// write if the new total would fall below what's already been paid.
  Future<void> updateTmInvoice({
    required DbInvoice original,
    required int labourCents,
    required int materialsCents,
    required List<int> timeIds,
    required List<int> materialIds,
    required int discountAmountCents,
    required double discountPercent,
    required String? discountDescription,
    required String tax1Name,
    required double tax1Rate,
    required bool tax2Enabled,
    required String tax2Name,
    required double tax2Rate,
    required String? poNumber,
    required String? workDescription,
    required String? notes,
    required String? internalNotes,
    required DateTime date,
  }) =>
      _run(() async {
        final subtotal = labourCents + materialsCents;
        final discountCents = discountAmountCents +
            (subtotal * discountPercent / 100).round();
        final totals = computeInvoiceTotals(
          subtotalCents: subtotal,
          discountCents: discountCents,
          tax1Rate: tax1Rate,
          tax2Rate: tax2Enabled ? tax2Rate : null,
        );
        await _guardBelowPaid(original.id, totals.total);

        await _db.transaction(() async {
          await _db.invoicesDao.updateRow(
            original.toCompanion(false).copyWith(
                  labourSubtotal: Value(labourCents),
                  materialsSubtotal: Value(materialsCents),
                  subtotal: Value(subtotal),
                  discountAmount: Value(discountCents),
                  discountPercent: Value(discountPercent),
                  discountDescription: Value(discountDescription),
                  tax1Name: Value(tax1Name),
                  tax1Rate: Value(tax1Rate),
                  tax1Amount: Value(totals.tax1),
                  tax2Name: tax2Enabled ? Value(tax2Name) : const Value(null),
                  tax2Rate: tax2Enabled ? Value(tax2Rate) : const Value(null),
                  tax2Amount: Value(totals.tax2),
                  totalAmount: Value(totals.total),
                  poNumber: Value(poNumber),
                  workDescription: Value(workDescription),
                  notes: Value(notes),
                  internalNotes: Value(internalNotes),
                  invoiceDate: Value(date.toIso8601String()),
                ),
          );
          // Release every line currently linked, then relink the selection.
          await _db.timeEntriesDao.clearInvoiceLink(original.id);
          await _db.materialsDao.clearInvoiceLink(original.id);
          await _db.timeEntriesDao.markBilled(timeIds, original.id);
          await _db.materialsDao.markBilled(materialIds, original.id);
        });
      });

  /// In-place edit of a fixed-price (`'deposit'`/`'progress'`/`'final'`) invoice.
  /// No line links exist, so this only rewrites the invoice row. Same below-paid
  /// guard.
  ///
  /// [tax1AmountCents] overrides the computed tax1 when non-null. Only the
  /// `'final'` type passes it: its GST is *reconciled* against the whole
  /// contract, not derived as `tax1Rate × amountCents`, and recomputing it here
  /// would silently drop that reconciliation (see `final_invoice_providers.dart`).
  Future<void> updateFixedPriceInvoice({
    required DbInvoice original,
    required String invoiceType,
    required int amountCents,
    required String tax1Name,
    required double tax1Rate,
    required bool tax2Enabled,
    required String tax2Name,
    required double tax2Rate,
    required String? poNumber,
    required String? workDescription,
    required String? notes,
    required String? internalNotes,
    required DateTime date,
    int? tax1AmountCents,
  }) =>
      _run(() async {
        final computed = computeInvoiceTotals(
          subtotalCents: amountCents,
          tax1Rate: tax1Rate,
          tax2Rate: tax2Enabled ? tax2Rate : null,
        );
        final totals = tax1AmountCents == null
            ? computed
            : InvoiceTotals(
                subtotal: amountCents,
                tax1: tax1AmountCents,
                tax2: computed.tax2,
                total: amountCents + tax1AmountCents + computed.tax2,
              );
        await _guardBelowPaid(original.id, totals.total);

        await _db.invoicesDao.updateRow(
          original.toCompanion(false).copyWith(
                invoiceType: Value(invoiceType),
                subtotal: Value(totals.subtotal),
                tax1Name: Value(tax1Name),
                tax1Rate: Value(tax1Rate),
                tax1Amount: Value(totals.tax1),
                tax2Name: tax2Enabled ? Value(tax2Name) : const Value(null),
                tax2Rate: tax2Enabled ? Value(tax2Rate) : const Value(null),
                tax2Amount: Value(totals.tax2),
                totalAmount: Value(totals.total),
                poNumber: Value(poNumber),
                workDescription: Value(workDescription),
                notes: Value(notes),
                internalNotes: Value(internalNotes),
                invoiceDate: Value(date.toIso8601String()),
              ),
        );
      });

  Future<void> _guardBelowPaid(int invoiceId, int newTotalCents) async {
    final paid = await _paidCents(invoiceId);
    if (newTotalCents < paid) {
      final paidStr = (paid / 100).toStringAsFixed(2);
      throw InvoiceEditException(
        'This would put the invoice total below the \$$paidStr already paid. '
        'Remove a different line, or resolve the difference as a credit/refund '
        'first.',
      );
    }
  }

  Future<void> _run(Future<void> Function() op) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(op);
  }
}

final invoiceEditActionsProvider =
    NotifierProvider<InvoiceEditActions, AsyncValue<void>>(
  InvoiceEditActions.new,
);

// ---------------------------------------------------------------------------
// helpers (kept local — invoice_providers.dart's copies are private)
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
