import 'package:flutter/material.dart';

/// Bottom action bar carrying a document's Print / Preview and Share PDF
/// buttons, shared by the client and project statement screens.
///
/// Deliberately the same shape as the invoice detail screen's action bar —
/// `FilledButton.tonalIcon` + `OutlinedButton.icon` in a [Wrap], over an
/// elevated [Material] — so a statement's export controls read identically to an
/// invoice's. They sit here rather than as `AppBar` actions because the AppBar
/// is solid blue-grey with white foreground (see `main.dart`), where a tonal
/// fill and an outlined button lose almost all of their contrast.
///
/// The [Wrap] and the height cap mirror the invoice bar's construction rather
/// than solving for a small screen — this app targets tablets (Galaxy Tab S7 /
/// iPad Mini and up), where these buttons fit on one row with room to spare.
/// They are kept because the reference bar has them and a future third action
/// would otherwise have nowhere to go.
///
/// Both callbacks accept null, which disables the corresponding button — used
/// while there is no statement to export yet.
class PdfActionBar extends StatelessWidget {
  const PdfActionBar({super.key, this.onPreview, this.onShare});

  final VoidCallback? onPreview;
  final VoidCallback? onShare;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      // Pushed route — without this the buttons render under the system
      // navigation bar on tablet.
      child: SafeArea(
        top: false,
        child: ConstrainedBox(
          // Cap the bar height so a wrapped row scrolls rather than pushing the
          // buttons off-screen — carried over from the invoice bar.
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.4,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: [
                  FilledButton.tonalIcon(
                    onPressed: onPreview,
                    icon: const Icon(Icons.picture_as_pdf),
                    label: const Text('Print / Preview'),
                  ),
                  OutlinedButton.icon(
                    onPressed: onShare,
                    icon: const Icon(Icons.share),
                    label: const Text('Share PDF'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
