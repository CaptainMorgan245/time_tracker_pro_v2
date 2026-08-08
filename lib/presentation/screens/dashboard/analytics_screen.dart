import 'package:flutter/material.dart';

import 'analytics/analytics_action_buttons.dart';
import 'analytics/analytics_report_selector.dart';
import 'analytics/project_financial_summary_card.dart';

/// Landing / hub screen for the Analytics module (dashboard tab index 2).
///
/// Mirrors the v1 Analytics page: a row of two dropdowns (Report Type + project
/// selector), a horizontal row of colored action buttons, then a single content
/// card below — the Project Financial Summary.
///
/// Content behaviour matches v1: the card lists every project of the selected
/// report type (each with its own financials); the "Project Summary" button
/// redisplays that list in place (clears the project selection) rather than
/// navigating away; picking a project in the dropdown shows just that project.
/// The other buttons (Personnel, Company Expenses, Select Data) navigate to
/// dedicated screens; Import Time runs the file-pick import.
///
/// Rendered inside the dashboard's [IndexedStack], so it is a plain body widget
/// with no `Scaffold`/`AppBar` of its own (the shell provides those).
class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade400,
      child: const SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AnalyticsReportSelector(),
              SizedBox(height: 16),
              AnalyticsActionButtons(),
              SizedBox(height: 24),
              ProjectFinancialSummaryCard(),
            ],
          ),
        ),
      ),
    );
  }
}
