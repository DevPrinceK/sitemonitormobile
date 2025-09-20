# Site Monitor (Flutter)

A Flutter mobile application to monitor websites and APIs uptime, integrating with a Django REST backend.

## Features (Planned / Implemented)
- [x] Project scaffold with Provider + Material 3
- [ ] JWT Authentication (login/register/logout)
- [ ] Dashboard with stats & charts
- [ ] Sites CRUD + detail stats
- [ ] Push notifications (Firebase Cloud Messaging)
- [ ] Local caching (Hive) & offline support
- [ ] Dark mode toggle (basic implemented)
- [ ] Notification preferences

## Folder Structure
```
lib/
  main.dart
  models/
  services/
  providers/
  screens/
    auth/
    dashboard/
    sites/
    settings/
  widgets/
```

## Backend Endpoints (expected)
```
/api/auth/login/
/api/auth/register/
/api/auth/logout/
/api/auth/refresh/
/api/sites/
/api/sites/<id>/
/api/sites/<id>/stats/
/api/notifications/subscribe/
```

## Environment Setup
1. Install Flutter (stable channel) and run `flutter doctor`.
2. Create Firebase project & enable Cloud Messaging.
3. Add `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) later.
4. Run pub get.

## Configuration
Create a file `lib/services/api_config.dart` with:
```dart
class ApiConfig {
  static const baseUrl = 'https://your-backend-domain.com';
}
```

## Next Steps
- Implement Dio API service with JWT + refresh.
- Add models and JSON serialization.
- Integrate charts with `fl_chart`.
- Implement caching with Hive.
- Add Firebase Messaging setup code.

## License
MIT
