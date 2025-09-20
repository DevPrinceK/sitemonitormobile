part of 'notification_preferences.dart';

NotificationPreferences _$NotificationPreferencesFromJson(
        Map<String, dynamic> json) =>
    NotificationPreferences(
      scope: _scopeFrom(json['scope']),
      clientNames:
          (json['client_names'] as List?)?.map((e) => e.toString()).toList(),
    );

Map<String, dynamic> _$NotificationPreferencesToJson(
        NotificationPreferences instance) =>
    <String, dynamic>{
      'scope': instance.scope.name,
      'client_names': instance.clientNames,
    };

NotificationScope _scopeFrom(Object? v) {
  if (v == null) return NotificationScope.all;
  final s = v.toString().toLowerCase();
  if (s.contains('client')) return NotificationScope.client;
  if (s.contains('none')) return NotificationScope.none;
  return NotificationScope.all;
}
