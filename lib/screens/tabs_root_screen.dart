import 'package:flutter/material.dart';
import 'dashboard/dashboard_screen.dart';
import 'sites/sites_list_screen.dart';
import 'settings/settings_screen.dart';

class TabsRootScreen extends StatefulWidget {
  const TabsRootScreen({super.key});

  @override
  State<TabsRootScreen> createState() => _TabsRootScreenState();
}

class _TabsRootScreenState extends State<TabsRootScreen> {
  int _index = 0;

  final _pages = const [
    DashboardScreen(),
    SitesListScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.dashboard_outlined),
              selectedIcon: Icon(Icons.dashboard),
              label: 'Dashboard'),
          NavigationDestination(
              icon: Icon(Icons.language_outlined),
              selectedIcon: Icon(Icons.language),
              label: 'Sites'),
          NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings),
              label: 'Settings'),
        ],
      ),
    );
  }
}
