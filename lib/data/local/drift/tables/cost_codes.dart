import 'package:drift/drift.dart';

/// Cost codes for categorising time/materials. Row class: `DbCostCode`.
@DataClassName('DbCostCode')
class CostCodes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique()();

  /// Governs Time & Materials invoice line selection ONLY: 1 = selectable as an
  /// individual T&M line item, 0 = not. Separate from [category] — see below.
  IntColumn get isBillable => integer().withDefault(const Constant(0))();

  /// Semantic classification that drives how a code's entries roll up in the
  /// analytics Project Financial Summary. One of `contract`, `billable`,
  /// `no_charge`, `internal`; null when unassigned (treated as "needs review").
  ///
  /// Distinct from [isBillable] because the three non-billable categories —
  /// `contract` (real cost covered by a fixed contract price), `no_charge`
  /// (deliberate write-off), `internal` (overhead) — are all `is_billable = 0`
  /// yet feed project financials completely differently, so a single flag can't
  /// express them. Populated via the cost-code management screen; existing rows
  /// stay null until set.
  TextColumn get category => text().nullable()();
}
