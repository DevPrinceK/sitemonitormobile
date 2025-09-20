import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/site_stats.dart';

class UptimeLineChart extends StatelessWidget {
  final List<SiteStatsPoint> points;
  const UptimeLineChart({super.key, required this.points});

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) {
      return const Center(child: Text('No data'));
    }
    final spots = points
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value.uptimePercent))
        .toList();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: 100,
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: true),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: Theme.of(context).colorScheme.primary,
              barWidth: 3,
              dotData: const FlDotData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}
