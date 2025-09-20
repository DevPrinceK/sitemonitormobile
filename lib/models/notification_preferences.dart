import 'package:json_annotation/json_annotation.dart';

part 'notification_preferences.g.dart';

enum NotificationScope { all, client, none }

@JsonSerializable()
class NotificationPreferences {
  final NotificationScope scope;
  final List<String>? clientNames; // when scope == client

  NotificationPreferences({required this.scope, this.clientNames});

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) =>
      _$NotificationPreferencesFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationPreferencesToJson(this);
}
