import 'package:flutter/material.dart';

import 'placeholder_body.dart';

/// Placeholder for the Analytics tab (index 2). The original app showed
/// reports and charts here.
class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderBody(
      icon: Icons.analytics,
      title: 'Analytics',
      detail: 'Reports and charts will live here.',
    );
  }
}
