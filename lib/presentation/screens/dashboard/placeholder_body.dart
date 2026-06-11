import 'package:flutter/material.dart';

/// Shared "coming soon" body used by the four dashboard placeholder tabs until
/// each feature is built out.
class PlaceholderBody extends StatelessWidget {
  const PlaceholderBody({
    super.key,
    required this.icon,
    required this.title,
    required this.detail,
  });

  final IconData icon;
  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: Colors.grey.shade500),
            const SizedBox(height: 12),
            Text(title,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(detail, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
