import 'package:flutter/material.dart';

/// Temporary body for analytics destination screens that are navigable from the
/// hub but not yet implemented. Replace with the real report as each is built.
class ComingSoonBody extends StatelessWidget {
  const ComingSoonBody({
    super.key,
    required this.icon,
    required this.title,
    this.detail,
  });

  final IconData icon;
  final String title;

  /// Optional line shown above "Coming soon" (e.g. the selected project).
  final String? detail;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 48, color: theme.colorScheme.primary),
          const SizedBox(height: 12),
          Text(title, style: theme.textTheme.titleLarge),
          if (detail != null) ...[
            const SizedBox(height: 4),
            Text(detail!, style: theme.textTheme.bodyLarge),
          ],
          const SizedBox(height: 4),
          Text(
            'Coming soon',
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: theme.hintColor, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}
