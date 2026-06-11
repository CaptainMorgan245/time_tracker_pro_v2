import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/local/drift/app_database.dart';
import '../../providers/client_project_providers.dart';
import 'client_form.dart';
import 'clients_section.dart';
import 'project_form.dart';
import 'projects_section.dart';

/// Clients & Projects management page, laid out to match the original app:
/// a "Show Archived" toggle and Add Client / Add Project buttons on top, then
/// clients and projects shown side-by-side on wide screens (>800px) or stacked
/// on narrow ones. Lists are reactive via the stream providers.
class ClientsProjectsScreen extends ConsumerStatefulWidget {
  const ClientsProjectsScreen({super.key});

  @override
  ConsumerState<ClientsProjectsScreen> createState() =>
      _ClientsProjectsScreenState();
}

class _ClientsProjectsScreenState
    extends ConsumerState<ClientsProjectsScreen> {
  bool _showInactive = false;

  void _addClient() => showDialog(
        context: context,
        builder: (_) => const ClientForm(),
      );

  void _addProject() => showDialog(
        context: context,
        builder: (_) => const ProjectForm(),
      );

  @override
  Widget build(BuildContext context) {
    final clientsAsync = ref.watch(clientsStreamProvider);
    final projectsAsync = ref.watch(projectsStreamProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Clients & Projects')),
      body: Column(
        children: [
          _buildTopButtons(),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final wide = constraints.maxWidth > 800;
                // Show a spinner until both lists have loaded.
                if (clientsAsync.isLoading || projectsAsync.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (clientsAsync.hasError) {
                  return Center(child: Text('Error: ${clientsAsync.error}'));
                }
                if (projectsAsync.hasError) {
                  return Center(child: Text('Error: ${projectsAsync.error}'));
                }
                final clients = clientsAsync.asData!.value;
                final projects = projectsAsync.asData!.value;
                return _buildLists(wide, clients, projects);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE8720C),
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(45),
            ),
            onPressed: () => setState(() => _showInactive = !_showInactive),
            child: Text(_showInactive
                ? 'Show Active Clients and Projects'
                : 'Show Archived Clients and Projects'),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.person_add, color: Colors.white),
                  label: const Text('Add Client'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: _addClient,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add_business, color: Colors.black87),
                  label: const Text('Add Project'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreen,
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: _addProject,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLists(
    bool wide,
    List<DbClient> clients,
    List<DbProject> projects,
  ) {
    final shownClients = _showInactive
        ? clients.where((c) => c.isActive == 0).toList()
        : clients.where((c) => c.isActive != 0).toList();
    final shownProjects = _showInactive
        ? projects.where((p) => p.isCompleted != 0).toList()
        : projects.where((p) => p.isCompleted == 0).toList();
    final clientNames = {for (final c in clients) c.id: c.name};

    final clientsSection = ClientsSection(
      title: _showInactive ? 'Inactive Clients' : 'Current Clients',
      clients: shownClients,
    );
    final projectsSection = ProjectsSection(
      title: _showInactive ? 'Completed Projects' : 'Current Projects',
      projects: shownProjects,
      clientNames: clientNames,
    );

    if (wide) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView(
                children: [clientsSection, const SizedBox(height: 32)],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ListView(children: [projectsSection]),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        const Divider(height: 1, thickness: 1),
        const SizedBox(height: 16),
        clientsSection,
        const SizedBox(height: 32),
        projectsSection,
      ],
    );
  }
}
