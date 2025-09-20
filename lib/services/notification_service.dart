import 'package:firebase_messaging/firebase_messaging.dart';
import 'api_service.dart';

class NotificationService {
  final ApiService api;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  NotificationService(this.api);

  Future<void> init() async {
    await _messaging.requestPermission();
    final token = await _messaging.getToken();
    if (token != null) {
      await api.post('/api/notifications/subscribe/', data: {'token': token});
    }
  }

  void listen(void Function(RemoteMessage) onMessage) {
    FirebaseMessaging.onMessage.listen(onMessage);
  }
}
