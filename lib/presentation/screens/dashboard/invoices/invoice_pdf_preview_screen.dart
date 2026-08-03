import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

/// In-app PDF preview for an already-rendered invoice.
///
/// Exists so the preview is a normal pushed route the user can back out of.
/// `Printing.layoutPdf` hands straight off to the platform print UI, which on
/// some devices offers no visible way back — here the AppBar owns a Close
/// button, and [PdfPreview]'s own action bar still provides print and share.
///
/// Takes the finished [bytes] rather than a builder: the caller already built
/// them (and reported any failure), so this screen can't fail to render.
class InvoicePdfPreviewScreen extends StatelessWidget {
  const InvoicePdfPreviewScreen({
    super.key,
    required this.invoiceNumber,
    required this.bytes,
  });

  final String invoiceNumber;
  final Uint8List bytes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice $invoiceNumber'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          tooltip: 'Close preview',
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: PdfPreview(
        build: (_) => bytes,
        initialPageFormat: PdfPageFormat.letter,
        // The invoice is laid out for Letter; letting the user reformat here
        // would only re-render the same fixed layout on a different sheet.
        canChangePageFormat: false,
        canChangeOrientation: false,
        canDebug: false,
        pdfFileName: 'Invoice_$invoiceNumber.pdf',
      ),
    );
  }
}
