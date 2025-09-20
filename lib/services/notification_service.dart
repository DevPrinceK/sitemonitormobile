import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'api_service.dart';

class NotificationService {
  final ApiService api;
  FirebaseMessaging?
      _messaging; // Lazily initialized only if Firebase is available
  NotificationService(this.api);

  bool get isReady => Firebase.apps.isNotEmpty;

  Future<void> init() async {
    if (!isReady) return; // Firebase not initialized; silently skip
    _messaging ??= FirebaseMessaging.instance;
    try {
      await _messaging!.requestPermission();
      final token = await _messaging!.getToken();
      if (token != null) {
        await api.post('/api/notifications/subscribe/', data: {'token': token});
      }
    } catch (_) {
      // Ignore notification init errors in early bootstrap; can retry later
    }
  }

  void listen(void Function(RemoteMessage) onMessage) {
    if (!isReady) return;
    FirebaseMessaging.onMessage.listen(onMessage);
  }
}
