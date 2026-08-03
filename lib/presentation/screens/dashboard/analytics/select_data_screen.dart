import 'package:flutter/material.dart';

import 'coming_soon_body.dart';

/// Destination for the hub's "Select Data" button — the entry point for custom
/// reporting. Stub for now; the full data-selection UI lands in a later pass.
class SelectDataScreen extends StatelessWidget {
  const SelectDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Data')),
      body: const ComingSoonBody(
        icon: Icons.checklist_rtl_outlined,
        title: 'Select Data',
      ),
    );
  }
}
