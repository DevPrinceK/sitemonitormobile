import 'package:json_annotation/json_annotation.dart';

part 'site_stats.g.dart';

@JsonSerializable()
class SiteStatsPoint {
  final DateTime timestamp;
  final double uptimePercent;
  final double downtimePercent;

  SiteStatsPoint(
      {required this.timestamp,
      required this.uptimePercent,
      required this.downtimePercent});

  factory SiteStatsPoint.fromJson(Map<String, dynamic> json) =>
      _$SiteStatsPointFromJson(json);
  Map<String, dynamic> toJson() => _$SiteStatsPointToJson(this);
}

@JsonSerializable()
class SiteStatsResponse {
  final int siteId;
  final double totalUptimePercent;
  final double totalDowntimePercent;
  final List<SiteStatsPoint> points;

  SiteStatsResponse({
    required this.siteId,
    required this.totalUptimePercent,
    required this.totalDowntimePercent,
    required this.points,
  });

  factory SiteStatsResponse.fromJson(Map<String, dynamic> json) =>
      _$SiteStatsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SiteStatsResponseToJson(this);
}
