import 'package:flutter/material.dart';

/// A titled card showing an editable list of string items. Each row taps (or
/// its edit icon) through to [onEdit] with the item's index. Ported from the
/// original app; shared by the Expenses and Personnel settings tabs.
class AppSettingListCard extends StatelessWidget {
  const AppSettingListCard({
    super.key,
    required this.title,
    required this.items,
    required this.onEdit,
  });

  final String title;
  final List<String> items;
  final void Function(int index) onEdit;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
              child: items.isEmpty
                  ? const Center(child: Text('None yet'))
                  : ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) => ListTile(
                        title: Text(items[index]),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => onEdit(index),
                        ),
                        onTap: () => onEdit(index),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
