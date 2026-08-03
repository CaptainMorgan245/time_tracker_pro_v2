/// Pure invoice-level money math (cents) + invoice-number formatting, shared by
/// the invoice-creation screens. Per-line math (rates, markups) lives in
/// `billing_calc.dart`; this file is the whole-invoice assembly. No
/// Drift/Riverpod here — plain functions over ints/strings.

/// Tax amount in **cents** for a [baseCents] base at [ratePercent] (e.g. 5.0 for
/// 5%). Rounded to the nearest cent.
int taxAmountCents(int baseCents, double ratePercent) =>
    (baseCents * ratePercent / 100).round();

/// The `invoiceType` values that draw against a fixed-price **contract**, and so
/// consume its balance: the deposit, each progress draw, and the reconciling
/// final invoice. `'extras'` is deliberately absent — T&M extras are billed
/// *above* the contract and must never reduce its remaining balance.
///
/// Single source for that rule: both `fixedPriceBilled` (contract summary) and
/// the final-invoice reconciliation read it, so "previously billed" means the
/// same set of invoices in both places.
const contractInvoiceTypes = {'deposit', 'progress', 'final'};

/// Computed invoice totals, all in **cents**.
class InvoiceTotals {
  const InvoiceTotals({
    required this.subtotal,
    required this.tax1,
    required this.tax2,
    required this.total,
  });

  final int subtotal;
  final int tax1;
  final int tax2;
  final int total;
}

/// Builds totals from a [subtotalCents] base, an optional [discountCents]
/// (subtracted before tax), and up to two tax rates in percent (null or 0 =
/// not applied).
InvoiceTotals computeInvoiceTotals({
  required int subtotalCents,
  int discountCents = 0,
  double? tax1Rate,
  double? tax2Rate,
}) {
  final taxable = subtotalCents - discountCents;
  final t1 = taxAmountCents(taxable, tax1Rate ?? 0);
  final t2 = taxAmountCents(taxable, tax2Rate ?? 0);
  return InvoiceTotals(
    subtotal: subtotalCents,
    tax1: t1,
    tax2: t2,
    total: taxable + t1 + t2,
  );
}

/// Formats a **year-scoped** invoice number as `PREFIX-YYYY-NNN` (3-digit zero
/// pad) — e.g. `INV-2026-024`. An empty [prefix] yields `YYYY-NNN`.
///
/// This is the app's canonical format. An earlier v2 build emitted a flat
/// `PREFIX-0024` instead, which is why some historical rows carry that shape;
/// see [nextInvoiceNumber] for how those are handled.
String formatInvoiceNumber(String prefix, int year, int sequence) {
  final seq = sequence.toString().padLeft(3, '0');
  final p = prefix.trim();
  return p.isEmpty ? '$year-$seq' : '$p-$year-$seq';
}

/// The sequence number [invoiceNumber] carries **for [year]**, or 0 if it isn't
/// a number belonging to that year.
///
/// Splits on `-`, finds the segment equal to the year, and parses the segment
/// after it — so it reads both `PREFIX-YYYY-NNN` and `YYYY-NNN`. Anything else
/// (notably the flat `PREFIX-NNNN` shape, or a number from a different year)
/// yields 0 and therefore cannot influence the sequence.
int invoiceNumberSequenceFor(String invoiceNumber, int year) {
  final parts = invoiceNumber.split('-');
  final yearStr = year.toString();
  for (var i = 0; i < parts.length - 1; i++) {
    if (parts[i].trim() == yearStr) {
      return int.tryParse(parts[i + 1].trim()) ?? 0;
    }
  }
  return 0;
}

/// Next invoice number for [year], given the [existingNumbers] already in use,
/// the [prefix] and the configured [startingNumber].
///
/// Continues from the highest sequence **already used in [year]** (per
/// [invoiceNumberSequenceFor]); numbers in any other format or from another year
/// are ignored outright rather than contributing a numeric value. When [year]
/// has no numbers yet, the sequence opens at [startingNumber] — so each new year
/// restarts rather than continuing the previous year's count.
String nextInvoiceNumber(
  Iterable<String> existingNumbers, {
  required String prefix,
  required int startingNumber,
  required int year,
}) {
  var highest = 0;
  for (final s in existingNumbers) {
    final n = invoiceNumberSequenceFor(s, year);
    if (n > highest) highest = n;
  }
  final sequence = highest == 0 ? startingNumber : highest + 1;
  return formatInvoiceNumber(prefix, year, sequence);
}
