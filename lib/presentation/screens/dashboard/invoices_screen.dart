import 'package:flutter/material.dart';

import 'placeholder_body.dart';

/// Placeholder for the Inv/Est tab (index 3). The original app listed invoices
/// and estimates here.
class InvoicesScreen extends StatelessWidget {
  const InvoicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderBody(
      icon: Icons.receipt_long,
      title: 'Invoices',
      detail: 'Invoices and estimates will live here.',
    );
  }
}
