import 'package:flutter/material.dart';

import 'coming_soon_body.dart';

/// Destination for the hub's "Personnel" button. Stub for now — will show the
/// per-employee rollup (from `personnelReportProvider`).
class PersonnelReportScreen extends StatelessWidget {
  const PersonnelReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Personnel Summary')),
      body: const ComingSoonBody(
        icon: Icons.people_outline,
        title: 'Personnel Summary',
      ),
    );
  }
}
