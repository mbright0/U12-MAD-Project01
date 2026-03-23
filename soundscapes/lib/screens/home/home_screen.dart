import 'package:flutter/material.dart';

import '../task/task_view_screen.dart';
import '../session/session_history_screen.dart';
import '../performance/performance_screen.dart';
import '../task/task_edit_screen.dart';
import '../session/session_setup_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int _currentIndex = 0;

  final List<Widget> _screens = [
    const TaskViewScreen(),
    const SessionHistoryScreen(),
    const PerformanceScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      floatingActionButton: _buildFAB(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) =>
            setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.checklist_rounded),
            label: 'Tasks',
          ),
          NavigationDestination(
            icon: Icon(Icons.folder_outlined),
            selectedIcon: Icon(Icons.folder_rounded),
            label: 'Sessions',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_rounded),
            label: 'Stats',
          ),
        ],
      ),
    );
  }

  Widget? _buildFAB() {
    return switch (_currentIndex) {
      0 => FloatingActionButton(
          heroTag: 'task_fab',
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => TaskEditScreen()),
          ),
          tooltip: 'Create new task',
          child: const Icon(Icons.add_rounded, size: 28),
        ),
      1 => FloatingActionButton(
          heroTag: 'session_fab',
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => SessionSetupScreen()),
          ),
          tooltip: 'New session',
          child: const Icon(Icons.play_arrow_rounded, size: 28),
        ),
      _ => null,
    };
  }
}
