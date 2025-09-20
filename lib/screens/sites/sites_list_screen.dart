import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/site_provider.dart';
import 'site_form_screen.dart';
import 'site_detail_screen.dart';
import '../../widgets/site_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/site_provider.dart';
import 'site_form_screen.dart';
import 'site_detail_screen.dart';
import '../../widgets/site_card.dart';
import '../../widgets/error_retry.dart';

class SitesListScreen extends StatefulWidget {
  const SitesListScreen({super.key});

  @override
  State<SitesListScreen> createState() => _SitesListScreenState();
}

class _SitesListScreenState extends State<SitesListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<SiteProvider>().fetchSites());
  }

  Future<void> _addSite() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const SiteFormScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SiteProvider>();
    final sites = provider.sites;

    Widget body;
    if (provider.error != null && !provider.loading && sites.isEmpty) {
      body = ErrorRetry(
        message: provider.error!,
        onRetry: provider.fetchSites,
      );
    } else if (provider.loading && sites.isEmpty) {
      body = const Center(child: CircularProgressIndicator());
    } else if (sites.isEmpty) {
      body = Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.language_outlined, size: 48),
              const SizedBox(height: 12),
              const Text('No sites yet'),
              const SizedBox(height: 12),
              FilledButton(onPressed: _addSite, child: const Text('Add Site')),
            ],
          ),
        ),
      );
    } else {
      body = ListView.builder(
        itemCount: sites.length,
        itemBuilder: (context, index) {
          final s = sites[index];
          return SiteCard(
            site: s,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => SiteDetailScreen(site: s)),
            ),
            onEdit: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => SiteFormScreen(site: s)),
              );
            },
            onDelete: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Delete Site'),
                  content: Text('Are you sure you want to delete "${s.name}"?'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.of(ctx).pop(false),
                        child: const Text('Cancel')),
                    FilledButton(
                      onPressed: () => Navigator.of(ctx).pop(true),
                      style:
                          FilledButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );
              if (confirm == true) {
                final ok = await provider.deleteSite(s.id);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(ok ? 'Deleted' : 'Delete failed')),
                  );
                }
              }
            },
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Sites')),
      floatingActionButton: FloatingActionButton(
        onPressed: _addSite,
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: provider.fetchSites,
        child: body is ListView
            ? body
            : ListView(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.75,
                    child: body,
                  )
                ],
              ),
      ),
    );
  }
}
