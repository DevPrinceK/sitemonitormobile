part of 'site_stats.dart';

SiteStatsPoint _$SiteStatsPointFromJson(Map<String, dynamic> json) =>
    SiteStatsPoint(
      timestamp: DateTime.parse(json['timestamp'] as String),
      uptimePercent: (json['uptime_percent'] as num?)?.toDouble() ??
          (json['uptimePercent'] as num).toDouble(),
      downtimePercent: (json['downtime_percent'] as num?)?.toDouble() ??
          (json['downtimePercent'] as num).toDouble(),
    );

Map<String, dynamic> _$SiteStatsPointToJson(SiteStatsPoint instance) =>
    <String, dynamic>{
      'timestamp': instance.timestamp.toIso8601String(),
      'uptime_percent': instance.uptimePercent,
      'downtime_percent': instance.downtimePercent,
    };

SiteStatsResponse _$SiteStatsResponseFromJson(Map<String, dynamic> json) =>
    SiteStatsResponse(
      siteId: json['site_id'] as int? ?? json['siteId'] as int,
      totalUptimePercent: (json['total_uptime_percent'] as num?)?.toDouble() ??
          (json['totalUptimePercent'] as num).toDouble(),
      totalDowntimePercent:
          (json['total_downtime_percent'] as num?)?.toDouble() ??
              (json['totalDowntimePercent'] as num).toDouble(),
      points: (json['points'] as List)
          .map((e) => SiteStatsPoint.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SiteStatsResponseToJson(SiteStatsResponse instance) =>
    <String, dynamic>{
      'site_id': instance.siteId,
      'total_uptime_percent': instance.totalUptimePercent,
      'total_downtime_percent': instance.totalDowntimePercent,
      'points': instance.points.map((e) => e.toJson()).toList(),
    };
