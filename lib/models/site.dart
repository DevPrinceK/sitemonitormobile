import 'package:json_annotation/json_annotation.dart';

part 'site.g.dart';

enum SiteType { website, api }

@JsonSerializable()
class Site {
  final int id;
  final String name;
  final String url;
  final String? clientName;
  final SiteType type;
  final bool isUp;
  final DateTime? lastChecked;

  Site({
    required this.id,
    required this.name,
    required this.url,
    this.clientName,
    required this.type,
    required this.isUp,
    this.lastChecked,
  });

  factory Site.fromJson(Map<String, dynamic> json) => _$SiteFromJson(json);
  Map<String, dynamic> toJson() => _$SiteToJson(this);
}
