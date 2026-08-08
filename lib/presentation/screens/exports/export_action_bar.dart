import 'package:flutter/material.dart';

/// Bottom bar for an export screen: what the report currently holds on the
/// left, the export action on the right.
///
/// Same construction as `PdfActionBar` — elevated [Material] with an explicit
/// `SafeArea(top: false)`, because on a pushed route without it the button
/// renders under the tablet's system navigation bar.
///
/// [onExport] accepts null, which disables the button — used while the report is
/// still loading or has nothing to write.
class ExportActionBar extends StatelessWidget {
  const ExportActionBar({
    super.key,
    required this.summary,
    required this.onExport,
    this.busy = false,
  });

  /// Left-hand status line, e.g. `42 rows · $3,180.45`.
  final String summary;

  final VoidCallback? onExport;

  /// Swaps the button's icon for a spinner while a write is in flight.
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      elevation: 8,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  summary,
                  style: theme.textTheme.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 12),
              FilledButton.tonalIcon(
                onPressed: busy ? null : onExport,
                icon: busy
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.download),
                label: const Text('Export CSV'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
