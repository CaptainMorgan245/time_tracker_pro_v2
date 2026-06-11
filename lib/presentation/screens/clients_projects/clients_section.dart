import 'package:flutter/material.dart';

import '../../../data/local/drift/app_database.dart';
import 'client_form.dart';

/// Non-scrolling clients section: a bold header followed by client cards.
/// Designed to sit inside the page's ListView (so it can be shown side-by-side
/// with projects on wide screens, or stacked on narrow ones). Matches the old
/// app's `_buildClientListTile` formatting.
class ClientsSection extends StatelessWidget {
  const ClientsSection({super.key, required this.title, required this.clients});

  final String title;
  final List<DbClient> clients;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ...clients.map((client) => _tile(context, client)),
      ],
    );
  }

  Widget _tile(BuildContext context, DbClient client) {
    final isInactive = client.isActive == 0;
    return Card(
      margin: const EdgeInsets.only(bottom: 6),
      color: isInactive ? Colors.grey.shade300 : null,
      child: InkWell(
        onTap: () => _edit(context, client),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 4, 2, 4),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      client.name + (isInactive ? ' (Inactive)' : ''),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: isInactive ? Colors.grey.shade700 : null,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Contact: ${client.contactPerson ?? 'N/A'} | '
                      'Phone: ${client.phoneNumber ?? 'N/A'}',
                      style: TextStyle(
                        fontSize: 11,
                        color: isInactive ? Colors.grey.shade600 : null,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.edit,
                    size: 18, color: isInactive ? Colors.grey : Colors.blue),
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
                constraints: const BoxConstraints(),
                onPressed: () => _edit(context, client),
              ),
              const SizedBox(width: 4),
            ],
          ),
        ),
      ),
    );
  }

  void _edit(BuildContext context, DbClient client) {
    showDialog(
      context: context,
      builder: (_) => ClientForm(existing: client),
    );
  }
}
