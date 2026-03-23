import 'package:flutter/material.dart';
import '../../core/database/database_helper.dart';
import '../../models/blueprint.dart';

class BlueprintsScreen extends StatefulWidget {
  const BlueprintsScreen({super.key});

  @override
  State<BlueprintsScreen> createState() => _BlueprintsScreenState();
}

class _BlueprintsScreenState extends State<BlueprintsScreen> {
  List<Blueprint> _blueprints = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBlueprints();
  }

  Future<void> _loadBlueprints() async {
    setState(() => _isLoading = true);
    final blueprints = await DatabaseHelper.instance.getAllBlueprints();
    setState(() {
      _blueprints = blueprints;
      _isLoading = false;
    });
  }

  Future<void> _deleteBlueprint(int id) async {
    await DatabaseHelper.instance.deleteBlueprint(id);
    await _loadBlueprints();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Blueprint deleted')),
      );
    }
  }

  void _showDeleteDialog(Blueprint blueprint) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Blueprint'),
        content: Text('Are you sure you want to delete "${blueprint.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteBlueprint(blueprint.id!);
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showCreateDialog() {
    final nameController = TextEditingController();
    String selectedMood = 'Focused';
    String selectedTask = 'Studying';
    int energyLevel = 3;
    int duration = 25;
    String audioPreset = 'None';

    final moods = ['Focused', 'Calm', 'Anxious', 'Tired', 'Energized', 'Creative'];
    final tasks = ['Studying', 'Reading', 'Writing', 'Coding', 'Problem Solving', 'Review'];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('New Blueprint'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Blueprint Name',
                        hintText: 'e.g. Late Night Coding',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text('Mood',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: selectedMood,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      items: moods
                          .map((m) => DropdownMenuItem(
                                value: m,
                                child: Text(m),
                              ))
                          .toList(),
                      onChanged: (val) =>
                          setDialogState(() => selectedMood = val!),
                    ),
                    const SizedBox(height: 16),
                    const Text('Task Type',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: selectedTask,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      items: tasks
                          .map((t) => DropdownMenuItem(
                                value: t,
                                child: Text(t),
                              ))
                          .toList(),
                      onChanged: (val) =>
                          setDialogState(() => selectedTask = val!),
                    ),
                    const SizedBox(height: 16),
                    Text('Energy Level: $energyLevel/5',
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    Slider(
                      value: energyLevel.toDouble(),
                      min: 1,
                      max: 5,
                      divisions: 4,
                      label: energyLevel.toString(),
                      onChanged: (val) =>
                          setDialogState(() => energyLevel = val.toInt()),
                    ),
                    Text('Duration: $duration min',
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    Slider(
                      value: duration.toDouble(),
                      min: 15,
                      max: 60,
                      divisions: 9,
                      label: '$duration min',
                      onChanged: (val) =>
                          setDialogState(() => duration = val.toInt()),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () async {
                    if (nameController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Please enter a blueprint name')),
                      );
                      return;
                    }
                    final blueprint = Blueprint(
                      name: nameController.text.trim(),
                      mood: selectedMood,
                      taskType: selectedTask,
                      energyLevel: energyLevel,
                      durationMinutes: duration,
                      audioPresetName: audioPreset,
                      createdAt: DateTime.now(),
                    );
                    await DatabaseHelper.instance.insertBlueprint(blueprint);
                    if (context.mounted) Navigator.pop(context);
                    await _loadBlueprints();
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Blueprints'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _blueprints.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.bookmark_border_rounded,
                          size: 72,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No Blueprints Yet',
                          style: theme.textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Save your favorite session setups as blueprints to reuse them anytime.',
                          style: theme.textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _blueprints.length,
                  itemBuilder: (context, index) {
                    final blueprint = _blueprints[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        leading: CircleAvatar(
                          backgroundColor:
                              theme.colorScheme.primaryContainer,
                          child: Icon(
                            Icons.bookmark_rounded,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        title: Text(
                          blueprint.name,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          '${blueprint.mood} • ${blueprint.taskType} • ${blueprint.durationMinutes} min • Energy ${blueprint.energyLevel}/5',
                          style: theme.textTheme.bodyMedium,
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.delete_outline_rounded,
                            color: theme.colorScheme.error,
                          ),
                          onPressed: () => _showDeleteDialog(blueprint),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateDialog,
        tooltip: 'New blueprint',
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}