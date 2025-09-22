import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';

import 'providers/auth_provider.dart';
import 'providers/site_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/notification_provider.dart';
import 'screens/splash_screen.dart';
import 'services/api_service.dart';
import 'services/site_service.dart';
import 'services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (_) {
    // Firebase not configured yet; continue without notifications
  }
  await Hive.initFlutter();
  await Hive.openBox('sites');
  await Hive.openBox('site_stats');
  runApp(const SiteMonitorApp());
}

class SiteMonitorApp extends StatefulWidget {
  const SiteMonitorApp({super.key});

  @override
  State<SiteMonitorApp> createState() => _SiteMonitorAppState();
}

class _SiteMonitorAppState extends State<SiteMonitorApp> {
  late final AuthProvider _authProvider;
  late final SiteProvider _siteProvider;
  late final ThemeProvider _themeProvider;
  late final NotificationProvider _notificationProvider;

  @override
  void initState() {
    super.initState();
    _authProvider = AuthProvider();
    final api = ApiService(_authProvider);
    _authProvider.attachApi(api);

    _siteProvider = SiteProvider();
    _siteProvider.attachService(SiteService(api));
    _siteProvider.attachCache(
      sitesBox: Hive.box('sites'),
      statsBox: Hive.box('site_stats'),
    );

    _themeProvider = ThemeProvider();
    _notificationProvider = NotificationProvider();
    // Attach notification service even if Firebase may be absent; service guards itself
    _notificationProvider.attachService(NotificationService(api));

    _bootstrap();
  }

  Future<void> _bootstrap() async {
    await _siteProvider.loadFromCache();
    await Future.wait([
      _authProvider.init(),
      _themeProvider.init(),
      _notificationProvider.init(),
    ]);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _authProvider),
        ChangeNotifierProvider.value(value: _siteProvider),
        ChangeNotifierProvider.value(value: _themeProvider),
        ChangeNotifierProvider.value(value: _notificationProvider),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, theme, _) {
          return MaterialApp(
            title: 'Site Monitor',
            themeMode: theme.themeMode,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
              useMaterial3: true,
              brightness: Brightness.light,
            ),
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                  seedColor: Colors.blue, brightness: Brightness.dark),
              useMaterial3: true,
              brightness: Brightness.dark,
            ),
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
