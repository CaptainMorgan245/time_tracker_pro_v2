import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

/// "Email" tab — Help & Support, ported from the original app's
/// HelpSupportScreen. App info, support/bug/feature mailto links, and a
/// getting-started card. Rendered as a tab body (no Scaffold of its own).
class HelpTab extends StatefulWidget {
  const HelpTab({super.key});

  @override
  State<HelpTab> createState() => _HelpTabState();
}

class _HelpTabState extends State<HelpTab> {
  String _appVersion = '...';

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    if (mounted) setState(() => _appVersion = info.version);
  }

  Future<void> _launchEmail(String subject) async {
    final emailUri = Uri(
      scheme: 'mailto',
      path: 'info@dyconn.ca',
      query: 'subject=$subject',
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open email app')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Icon(Icons.access_time,
                    size: 64, color: Theme.of(context).colorScheme.primary),
                const SizedBox(height: 8),
                const Text('Time Tracker Pro',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                Text('Version $_appVersion',
                    style: TextStyle(color: Colors.grey[600])),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text('NEED HELP?',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                letterSpacing: 1.2)),
        const SizedBox(height: 8),
        ListTile(
          leading: const Icon(Icons.email),
          title: const Text('Contact Support'),
          subtitle: const Text('info@dyconn.ca'),
          onTap: () => _launchEmail('Support Request'),
        ),
        ListTile(
          leading: const Icon(Icons.bug_report),
          title: const Text('Report a Bug'),
          subtitle: const Text('Help us improve the app'),
          onTap: () => _launchEmail('Bug Report - v$_appVersion'),
        ),
        ListTile(
          leading: const Icon(Icons.lightbulb_outline),
          title: const Text('Request a Feature'),
          subtitle: const Text('Share your ideas'),
          onTap: () => _launchEmail('Feature Request'),
        ),
        const SizedBox(height: 24),
        Card(
          color: Colors.blue.shade50,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue.shade700),
                    const SizedBox(width: 8),
                    Text('Getting Started',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.blue.shade700)),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  '1. Add your clients and projects\n'
                  '2. Add employees and set their roles\n'
                  '3. Track time on the Timer screen\n'
                  '4. View reports in Analytics\n'
                  '5. Export data for billing/taxes',
                  style: TextStyle(height: 1.6),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
