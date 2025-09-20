part of 'site.dart';

Site _$SiteFromJson(Map<String, dynamic> json) => Site(
      id: json['id'] as int,
      name: json['name'] as String,
      url: json['url'] as String,
      clientName: json['client_name'] as String?,
      type: _siteTypeFromJson(json['type']),
      isUp: json['is_up'] as bool? ?? json['isUp'] as bool? ?? false,
      lastChecked: json['last_checked'] != null
          ? DateTime.tryParse(json['last_checked'] as String)
          : null,
    );

Map<String, dynamic> _$SiteToJson(Site instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'url': instance.url,
      'client_name': instance.clientName,
      'type': instance.type.name,
      'is_up': instance.isUp,
      'last_checked': instance.lastChecked?.toIso8601String(),
    };

SiteType _siteTypeFromJson(Object? v) {
  if (v == null) return SiteType.website;
  final s = v.toString().toLowerCase();
  if (s.contains('api')) return SiteType.api;
  return SiteType.website;
}
