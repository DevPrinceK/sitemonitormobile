import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class UptimePieChart extends StatelessWidget {
  final double uptime;
  final double downtime;
  const UptimePieChart(
      {super.key, required this.uptime, required this.downtime});

  @override
  Widget build(BuildContext context) {
    final total = (uptime + downtime).clamp(0, 100);
    final double u = total == 0 ? 0 : uptime;
    final double d = total == 0 ? 0 : downtime;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: PieChart(
        PieChartData(sectionsSpace: 2, sections: [
          PieChartSectionData(
            value: u,
            color: Colors.green,
            title: '${u.toStringAsFixed(1)}% Up',
            titleStyle: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Colors.white),
          ),
          PieChartSectionData(
            value: d,
            color: Colors.red,
            title: '${d.toStringAsFixed(1)}% Down',
            titleStyle: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Colors.white),
          ),
        ]),
      ),
    );
  }
}
