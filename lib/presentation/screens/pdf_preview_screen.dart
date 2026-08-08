import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

/// In-app preview for an already-rendered PDF — invoices and statements alike.
///
/// Exists so the preview is a normal pushed route the user can back out of.
/// `Printing.layoutPdf` hands straight off to the platform print UI, which on
/// some devices offers no visible way back — here the AppBar owns a Close
/// button, and [PdfPreview]'s own action bar still provides print and share.
///
/// Takes the finished [bytes] rather than a builder: the caller already built
/// them (and reported any failure), so this screen can't fail to render.
class PdfPreviewScreen extends StatelessWidget {
  const PdfPreviewScreen({
    super.key,
    required this.title,
    required this.fileName,
    required this.bytes,
  });

  /// AppBar title, e.g. `Invoice INV-2026-015` or `Kelly Fry — Statement`.
  final String title;

  /// Suggested filename for print/share, including the `.pdf` extension.
  final String fileName;

  final Uint8List bytes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: const Icon(Icons.close),
          tooltip: 'Close preview',
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: PdfPreview(
        build: (_) => bytes,
        initialPageFormat: PdfPageFormat.letter,
        // Every document here is laid out for Letter; letting the user reformat
        // would only re-render the same fixed layout on a different sheet.
        canChangePageFormat: false,
        canChangeOrientation: false,
        canDebug: false,
        pdfFileName: fileName,
      ),
    );
  }
}
