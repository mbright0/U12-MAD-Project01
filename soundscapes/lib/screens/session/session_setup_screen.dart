import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/session_provider.dart';
import 'session_screen.dart';

class SessionSetupScreen extends StatelessWidget {
  const SessionSetupScreen({super.key});

  static const List<String> _moods = [
    'Focused', 'Calm', 'Anxious', 'Tired', 'Energized', 'Creative'
  ];

  static const List<String> _taskTypes = [
    'Studying', 'Reading', 'Writing', 'Coding', 'Problem Solving', 'Review'
  ];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SessionProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Session Setup'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('How are you feeling?',
                  style: theme.textTheme.headlineMedium),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _moods.map((mood) {
                  final selected = provider.mood == mood;
                  return ChoiceChip(
                    label: Text(mood),
                    selected: selected,
                    onSelected: (_) => provider.setMood(mood),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              Text('What are you working on?',
                  style: theme.textTheme.headlineMedium),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _taskTypes.map((task) {
                  final selected = provider.taskType == task;
                  return ChoiceChip(
                    label: Text(task),
                    selected: selected,
                    onSelected: (_) => provider.setTaskType(task),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              Text('Energy Level: ${provider.energyLevel}/5',
                  style: theme.textTheme.headlineMedium),
              Slider(
                value: provider.energyLevel.toDouble(),
                min: 1,
                max: 5,
                divisions: 4,
                label: provider.energyLevel.toString(),
                onChanged: (val) => provider.setEnergyLevel(val.toInt()),
              ),
              const SizedBox(height: 24),
              Text('Session Duration: ${provider.durationMinutes} min',
                  style: theme.textTheme.headlineMedium),
              Slider(
                value: provider.durationMinutes.toDouble(),
                min: 15,
                max: 60,
                divisions: 9,
                label: '${provider.durationMinutes} min',
                onChanged: (val) =>
                    provider.setDurationMinutes(val.toInt()),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: () {
                    provider.resetSession();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SessionScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Start Session',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}