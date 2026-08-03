import 'package:flutter/material.dart';

/// What the user chose on the first-run welcome card.
enum WelcomeAction { getStarted, later }

/// Shows the large, dismissible first-run welcome card. Returns the chosen
/// [WelcomeAction], or null if dismissed via the barrier / back gesture.
Future<WelcomeAction?> showWelcomeCard(BuildContext context) {
  return showDialog<WelcomeAction>(
    context: context,
    builder: (_) => const _WelcomeCard(),
  );
}

/// First-run welcome card. Intentionally simple: explains only the four core
/// things needed to use the timer, with no mention of taxes, markups, burden
/// rates, or backup import. Dismissible — nothing is forced.
class _WelcomeCard extends StatelessWidget {
  const _WelcomeCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.waving_hand,
                      color: theme.colorScheme.primary, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text('Welcome to Time Tracker Pro',
                        style: theme.textTheme.titleLarge),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text('To start tracking time, you just need a few things:',
                  style: theme.textTheme.bodyMedium),
              const SizedBox(height: 16),
              _item(context, Icons.person_outline, 'A person',
                  'The worker whose time you log.'),
              _item(context, Icons.business_outlined, 'A client',
                  'Who the work is for.'),
              _item(context, Icons.folder_outlined, 'A project',
                  'What you log time against (belongs to a client).'),
              _item(context, Icons.label_outline, 'Cost codes',
                  'Optional tags to categorise time.'),
              const SizedBox(height: 12),
              Text(
                'You can add these any time — nothing is required up front.',
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.hintColor),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () =>
                        Navigator.of(context).pop(WelcomeAction.later),
                    child: const Text('Maybe Later'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: () =>
                        Navigator.of(context).pop(WelcomeAction.getStarted),
                    child: const Text('Get Started'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _item(
      BuildContext context, IconData icon, String title, String subtitle) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleSmall),
                Text(subtitle, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
