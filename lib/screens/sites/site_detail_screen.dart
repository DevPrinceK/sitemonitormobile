import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/site.dart';
import '../../providers/site_provider.dart';
import '../../widgets/uptime_pie_chart.dart';
import '../../widgets/uptime_line_chart.dart';

class SiteDetailScreen extends StatefulWidget {
  final Site site;
  const SiteDetailScreen({super.key, required this.site});

  @override
  State<SiteDetailScreen> createState() => _SiteDetailScreenState();
}

class _SiteDetailScreenState extends State<SiteDetailScreen> {
  String _range = 'weekly';

  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => context.read<SiteProvider>().loadStats(widget.site.id));
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SiteProvider>();
    final stats = provider.currentStats;
    return Scaffold(
      appBar: AppBar(title: Text(widget.site.name)),
      body: RefreshIndicator(
        onRefresh: () => provider.loadStats(widget.site.id),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                FilterChip(
                  label: const Text('Weekly'),
                  selected: _range == 'weekly',
                  onSelected: (v) {
                    setState(() => _range = 'weekly');
                    provider.loadStats(widget.site.id);
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Monthly'),
                  selected: _range == 'monthly',
                  onSelected: (v) {
                    setState(() => _range = 'monthly');
                    provider.loadStats(widget.site.id);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (stats != null) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                              '${stats.totalUptimePercent.toStringAsFixed(2)}%',
                              style: Theme.of(context).textTheme.titleLarge),
                          const Text('Uptime')
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                              '${stats.totalDowntimePercent.toStringAsFixed(2)}%',
                              style: Theme.of(context).textTheme.titleLarge),
                          const Text('Downtime')
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: SizedBox(
                    height: 220,
                    child: UptimePieChart(
                        uptime: stats.totalUptimePercent,
                        downtime: stats.totalDowntimePercent)),
              ),
              const SizedBox(height: 16),
              Card(
                child: SizedBox(
                  height: 300,
                  child: UptimeLineChart(points: stats.points),
                ),
              ),
            ] else ...[
              const Center(
                  child: Padding(
                padding: EdgeInsets.all(32.0),
                child: CircularProgressIndicator(),
              ))
            ]
          ],
        ),
      ),
    );
  }
}
