import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/site_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<SiteProvider>().fetchSites());
  }

  @override
  Widget build(BuildContext context) {
    final siteProvider = context.watch<SiteProvider>();
    final sites = siteProvider.sites;
    final up = sites.where((s) => s.isUp).length;

    final down = sites.length - up;
    final uptimePercent = sites.isEmpty ? 0 : (up / sites.length) * 100;

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: RefreshIndicator(
        onRefresh: siteProvider.fetchSites,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _StatCard(
                    label: 'Total Sites',
                    value: sites.length.toString(),
                    icon: Icons.language),
                _StatCard(
                    label: 'Up',
                    value: up.toString(),
                    icon: Icons.arrow_upward,
                    color: Colors.green),
                _StatCard(
                    label: 'Down',
                    value: down.toString(),
                    icon: Icons.arrow_downward,
                    color: Colors.red),
                _StatCard(
                    label: 'Uptime %',
                    value: uptimePercent.toStringAsFixed(1),
                    icon: Icons.percent),
              ],
            ),
            const SizedBox(height: 24),
            Card(
              child: SizedBox(
                height: 220,
                child: Center(
                  child: Text('Charts placeholder',
                      style: Theme.of(context).textTheme.bodyLarge),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? color;
  const _StatCard(
      {required this.label,
      required this.value,
      required this.icon,
      this.color});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: 160,
      child: Card(
        color: color?.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color ?? scheme.primary),
              const SizedBox(height: 8),
              Text(value,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold)),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }
}
