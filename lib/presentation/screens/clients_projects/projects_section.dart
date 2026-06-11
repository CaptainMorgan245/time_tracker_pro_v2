import 'package:flutter/material.dart';

import '../../../data/local/drift/app_database.dart';
import 'project_form.dart';

/// Non-scrolling projects section: a bold header followed by project cards.
/// Mirrors the old app's `_buildProjectListTile` formatting (price/rate in the
/// subtitle, greyed-out when completed). [clientNames] maps clientId → name.
class ProjectsSection extends StatelessWidget {
  const ProjectsSection({
    super.key,
    required this.title,
    required this.projects,
    required this.clientNames,
  });

  final String title;
  final List<DbProject> projects;
  final Map<int, String> clientNames;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ...projects.map((project) => _tile(context, project)),
      ],
    );
  }

  Widget _tile(BuildContext context, DbProject project) {
    final String priceOrRate;
    if (project.pricingModel == 'hourly') {
      priceOrRate = '\$${project.billedHourlyRate?.toStringAsFixed(2) ?? '0.00'}/hr';
    } else {
      priceOrRate = '\$${project.projectPrice?.toStringAsFixed(2) ?? '0.00'} Fixed';
    }

    final isCompleted = project.isCompleted != 0;
    final clientName = clientNames[project.clientId] ?? 'N/A';

    return Card(
      margin: const EdgeInsets.only(bottom: 6),
      color: isCompleted ? Colors.grey.shade300 : null,
      child: InkWell(
        onTap: () => _edit(context, project),
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
                      project.projectName + (isCompleted ? ' (Completed)' : ''),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: isCompleted ? Colors.grey.shade700 : null,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Client: $clientName | $priceOrRate',
                      style: TextStyle(
                        fontSize: 11,
                        color: isCompleted ? Colors.grey.shade600 : null,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.edit,
                    size: 18, color: isCompleted ? Colors.grey : Colors.blue),
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
                constraints: const BoxConstraints(),
                onPressed: () => _edit(context, project),
              ),
              const SizedBox(width: 4),
            ],
          ),
        ),
      ),
    );
  }

  void _edit(BuildContext context, DbProject project) {
    showDialog(
      context: context,
      builder: (_) => ProjectForm(existing: project),
    );
  }
}
