import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/session_provider.dart';
import '../../core/database/database_helper.dart';
import '../../models/blueprint.dart';
import '../../widgets/ai_suggestion_banner.dart';
import '../../core/utils/ai_engine.dart';
import '../blueprints/blueprints_screen.dart';
import 'session_screen.dart';

class SessionSetupScreen extends StatefulWidget {
  const SessionSetupScreen({super.key});

  @override
  State<SessionSetupScreen> createState() => _SessionSetupScreenState();
}

class _SessionSetupScreenState extends State<SessionSetupScreen> {
  List<Blueprint> _blueprints = [];

  static const List<String> _moods = [
    'Focused', 'Calm', 'Anxious', 'Tired', 'Energized', 'Creative'
  ];

  static const List<String> _taskTypes = [
    'Studying', 'Reading', 'Writing', 'Coding', 'Problem Solving', 'Review'
  ];

  @override
  void initState() {
    super.initState();
    _loadBlueprints();
  }

  Future<void> _loadBlueprints() async {
    final blueprints = await DatabaseHelper.instance.getAllBlueprints();
    setState(() => _blueprints = blueprints);
  }

  void _applyBlueprint(Blueprint blueprint, SessionProvider provider) {
    provider.setMood(blueprint.mood);
    provider.setTaskType(blueprint.taskType);
    provider.setEnergyLevel(blueprint.energyLevel);
    provider.setDurationMinutes(blueprint.durationMinutes);
    provider.setAudioPresetName(blueprint.audioPresetName);
    provider.setBlueprintName(blueprint.name);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Loaded blueprint: ${blueprint.name}')),
    );
  }

  void _showBlueprintPicker(SessionProvider provider) {
    if (_blueprints.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No blueprints saved yet')),
      );
      return;
    }
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _blueprints.length,
        itemBuilder: (context, index) {
          final blueprint = _blueprints[index];
          return ListTile(
            leading: const Icon(Icons.bookmark_rounded),
            title: Text(blueprint.name),
            subtitle: Text(
              '${blueprint.mood} • ${blueprint.taskType} • ${blueprint.durationMinutes} min',
            ),
            onTap: () {
              Navigator.pop(context);
              _applyBlueprint(blueprint, provider);
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SessionProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Session Setup'),
        actions: [
          TextButton.icon(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const BlueprintsScreen(),
                ),
              );
              _loadBlueprints();
            },
            icon: const Icon(Icons.bookmark_outline_rounded),
            label: const Text('Blueprints'),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Load blueprint button
              OutlinedButton.icon(
                onPressed: () => _showBlueprintPicker(provider),
                icon: const Icon(Icons.bookmark_rounded),
                label: const Text('Load a Blueprint'),
              ),
              const SizedBox(height: 24),

              // Mood selector
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

              // Task type selector
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

              // Energy level slider
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

              // Duration slider
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
              const SizedBox(height: 24),

              // AI suggestion banner
              AISuggestionBanner(
                mood: provider.mood,
                taskType: provider.taskType,
                energyLevel: provider.energyLevel,
                onApply: () {
                  final recommended =
                      AIEngine.recommendDuration(provider.energyLevel);
                  provider.setDurationMinutes(recommended);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('AI mix applied to your session')),
                  );
                },
              ),
              const SizedBox(height: 16),

              // Start session button
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
