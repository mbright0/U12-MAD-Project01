import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/session_provider.dart';
import '../../providers/audio_provider.dart';
import '../../core/database/database_helper.dart';
import '../../models/blueprint.dart';
import '../../widgets/ai_suggestion_banner.dart';
import '../../core/utils/ai_engine.dart';
import '../../core/constants/app_strings.dart';
import '../blueprints/blueprints_screen.dart';
import 'session_screen.dart';

class SessionSetupScreen extends StatefulWidget {
  const SessionSetupScreen({super.key});

  @override
  State<SessionSetupScreen> createState() => _SessionSetupScreenState();
}

class _SessionSetupScreenState extends State<SessionSetupScreen> {
  List<Blueprint> _blueprints = [];

  @override
  void initState() {
    super.initState();
    _loadBlueprints();
  }

  Future<void> _loadBlueprints() async {
    final blueprints = await DatabaseHelper.instance.getAllBlueprints();
    setState(() => _blueprints = blueprints);
  }

  void _applyBlueprint(Blueprint blueprint) {
    final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
    final audioProvider = Provider.of<AudioProvider>(context, listen: false);
    
    sessionProvider.setMood(blueprint.mood);
    sessionProvider.setTaskType(blueprint.taskType);
    sessionProvider.setEnergyLevel(blueprint.energyLevel);
    sessionProvider.setDurationMinutes(blueprint.durationMinutes);
    sessionProvider.setAudioPresetName(blueprint.audioPresetName);
    sessionProvider.setBlueprintName(blueprint.name);
    
    // Apply audio preset if exists
    final recommended = AIEngine.recommendSoundscape(
      mood: blueprint.mood,
      taskType: blueprint.taskType,
      energyLevel: blueprint.energyLevel,
    );
    audioProvider.setAllVolumes(recommended);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Loaded blueprint: ${blueprint.name}')),
    );
  }

  void _showBlueprintPicker() {
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
              _applyBlueprint(blueprint);
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sessionProvider = Provider.of<SessionProvider>(context);
    final audioProvider = Provider.of<AudioProvider>(context);
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
            label: const Text(AppStrings.blueprints),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Load blueprint
              OutlinedButton.icon(
                onPressed: _showBlueprintPicker,
                icon: const Icon(Icons.bookmark_rounded),
                label: const Text(AppStrings.loadBlueprint),
              ),
              const SizedBox(height: 24),

              // Mood
              Text(AppStrings.mood, style: theme.textTheme.headlineMedium),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: AppStrings.moods.map((mood) {
                  final selected = sessionProvider.mood == mood;
                  return ChoiceChip(
                    label: Text(mood),
                    selected: selected,
                    onSelected: (_) => sessionProvider.setMood(mood),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Task type
              Text(AppStrings.taskType, style: theme.textTheme.headlineMedium),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: AppStrings.taskTypes.map((task) {
                  final selected = sessionProvider.taskType == task;
                  return ChoiceChip(
                    label: Text(task),
                    selected: selected,
                    onSelected: (_) => sessionProvider.setTaskType(task),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Energy level
              Text(
                '${AppStrings.energyLevel}: ${sessionProvider.energyLevel}/5',
                style: theme.textTheme.headlineMedium,
              ),
              Slider(
                value: sessionProvider.energyLevel.toDouble(),
                min: 1,
                max: 5,
                divisions: 4,
                label: sessionProvider.energyLevel.toString(),
                onChanged: (val) => sessionProvider.setEnergyLevel(val.toInt()),
              ),
              const SizedBox(height: 24),

              // Duration
              Text(
                '${AppStrings.duration}: ${sessionProvider.durationMinutes} min',
                style: theme.textTheme.headlineMedium,
              ),
              Slider(
                value: sessionProvider.durationMinutes.toDouble(),
                min: 15,
                max: 60,
                divisions: 9,
                label: '${sessionProvider.durationMinutes} min',
                onChanged: (val) =>
                    sessionProvider.setDurationMinutes(val.toInt()),
              ),
              const SizedBox(height: 24),

              // AI suggestion
              AISuggestionBanner(
                mood: sessionProvider.mood,
                taskType: sessionProvider.taskType,
                energyLevel: sessionProvider.energyLevel,
                onApply: () {
                  final recommended = AIEngine.recommendSoundscape(
                    mood: sessionProvider.mood,
                    taskType: sessionProvider.taskType,
                    energyLevel: sessionProvider.energyLevel,
                  );
                  audioProvider.setAllVolumes(recommended);
                  
                  final recommendedDuration =
                      AIEngine.recommendDuration(sessionProvider.energyLevel);
                  sessionProvider.setDurationMinutes(recommendedDuration);
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('AI mix applied to your session')),
                  );
                },
              ),
              const SizedBox(height: 16),

              // Start button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: () {
                    sessionProvider.resetSession();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SessionScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    AppStrings.startSession,
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
