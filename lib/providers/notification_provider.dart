import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../services/notification_service.dart';

class NotificationProvider extends ChangeNotifier {
  NotificationService? _service;
  bool _enabled = true;
  RemoteMessage? _lastMessage;

  bool get enabled => _enabled;
  RemoteMessage? get lastMessage => _lastMessage;

  void attachService(NotificationService service) {
    _service = service;
  }

  Future<void> init() async {
    if (_service == null) return;
    await _service!.init();
    _service!.listen((msg) {
      _lastMessage = msg;
      notifyListeners();
    });
  }

  Future<void> setEnabled(bool value) async {
    _enabled = value;
    notifyListeners();
  }
}
