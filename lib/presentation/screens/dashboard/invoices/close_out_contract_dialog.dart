import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final _currency = NumberFormat.currency(symbol: '\$');

/// What the user chose when told an invoice appears to close out its contract.
enum CloseOutChoice {
  /// Retype as the final invoice, then send.
  markFinalAndSend,

  /// Send as-is — the type is correct after all.
  sendAsIs,
}

/// Prompt shown at send time when the invoice being sent brings billing up to
/// the full contract value (see `closesOutContractProvider`).
///
/// Catches the mistake that otherwise only surfaces after the invoice has been
/// sent and paid as a progress draw — at which point the type can still be
/// corrected, but only after the fact.
///
/// Returns null on cancel (nothing is sent).
Future<CloseOutChoice?> showCloseOutContractDialog(
  BuildContext context, {
  required int contractTotalCents,
  required String currentTypeLabel,
}) {
  return showDialog<CloseOutChoice>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('This invoice closes out the contract'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Billing on this contract now reaches its full value of '
            '${_currency.format(contractTotalCents / 100)}, but this invoice is '
            'typed as a $currentTypeLabel.',
          ),
          const SizedBox(height: 12),
          const Text(
            'Should it be the Final Invoice? A final invoice states the closing '
            'contract statement to the client — the contract, every draw, and '
            'the balance this invoice settles.',
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(CloseOutChoice.sendAsIs),
          child: Text('Send as $currentTypeLabel'),
        ),
        FilledButton(
          onPressed: () =>
              Navigator.of(ctx).pop(CloseOutChoice.markFinalAndSend),
          child: const Text('Mark as Final & Send'),
        ),
      ],
    ),
  );
}
