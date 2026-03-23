import 'package:flutter/material.dart';

import 'home/home_screen.dart';
import 'session/session_view_screen.dart';
import 'performance/performance_screen.dart';
import 'settings/settings_screen.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {

  int _currentIndex = 0;

  static const List<Widget> _screens = [
    HomeScreen(),           
    SessionViewScreen(),   
    PerformanceScreen(),  
    SettingsScreen(),    
  ];

  static const List<NavigationDestination> _destinations = [
    NavigationDestination(
      icon: Icon(Icons.checklist_rounded),
      label: 'Tasks',
      tooltip: 'Task View',
    ),
    NavigationDestination(
      icon: Icon(Icons.folder_outlined),
      selectedIcon: Icon(Icons.folder_rounded),
      label: 'Sessions',
      tooltip: 'Session View',
    ),
    NavigationDestination(
      icon: Icon(Icons.bar_chart_rounded),
      label: 'Stats',
      tooltip: 'Performance',
    ),
    NavigationDestination(
      icon: Icon(Icons.settings_outlined),
      selectedIcon: Icon(Icons.settings_rounded),
      label: 'Settings',
      tooltip: 'App Settings',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) =>
            setState(() => _currentIndex = index),
        destinations: _destinations,
      ),
    );
  }
}
