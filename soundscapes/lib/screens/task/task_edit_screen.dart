import 'package:flutter/material.dart';

class TaskEditScreen extends StatefulWidget {
  const TaskEditScreen({super.key});

  @override
  State<TaskEditScreen> createState() => _TaskEditScreenState();
}

class _TaskEditScreenState extends State<TaskEditScreen> {

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  String _selectedType = 'coding';
  String _selectedMood = 'focused';
  int _energyLevel = 5;

  static const List<(String, String)> _taskTypes = [
    ('coding',   '💻 Coding'),
    ('reading',  '📖 Reading'),
    ('writing',  '✍️ Writing'),
    ('study',    '📐 Study'),
    ('creative', '🎨 Creative'),
    ('other',    '📌 Other'),
  ];

  static const List<(String, String)> _moods = [
    ('focused',   '😤 Focused'),
    ('calm',      '😌 Calm'),
    ('motivated', '😊 Motivated'),
    ('anxious',   '😰 Anxious'),
    ('neutral',   '😐 Neutral'),
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          tooltip: 'Discard',
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'New Task',
          style: tt.titleLarge?.copyWith(fontWeight: FontWeight.w800),
        ),
        actions: [
          FilledButton(
            onPressed: _onSave,
            child: const Text('Save'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [

              // Task name
              _SectionLabel(label: 'Task Name'),
              TextFormField(
                controller: _nameController,
                autofocus: true,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: 'e.g. Research Paper',
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Task name cannot be empty';
                  }
                  if (v.trim().length < 2) {
                    return 'Name must be at least 2 characters';
                  }
                  if (v.trim().length > 50) {
                    return 'Name must be 50 characters or fewer';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // Task type
              _SectionLabel(label: 'Task Type'),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final (value, label) in _taskTypes)
                    ChoiceChip(
                      label: Text(label),
                      selected: _selectedType == value,
                      onSelected: (_) =>
                          setState(() => _selectedType = value),
                    ),
                ],
              ),

              const SizedBox(height: 24),

              // Energy level
              _SectionLabel(label: 'Energy Level  $_energyLevel / 10'),
              Row(
                children: [
                  const Text('1', style: TextStyle(fontSize: 12)),
                  Expanded(
                    child: Slider(
                      value: _energyLevel.toDouble(),
                      min: 1,
                      max: 10,
                      divisions: 9,
                      label: _energyLevel.toString(),
                      onChanged: (v) =>
                          setState(() => _energyLevel = v.round()),
                    ),
                  ),
                  const Text('10', style: TextStyle(fontSize: 12)),
                ],
              ),

              const SizedBox(height: 24),

              // Mood
              _SectionLabel(label: 'Mood'),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final (value, label) in _moods)
                    ChoiceChip(
                      label: Text(label),
                      selected: _selectedMood == value,
                      onSelected: (_) =>
                          setState(() => _selectedMood = value),
                    ),
                ],
              ),

              const SizedBox(height: 32),

              // Discard button
              OutlinedButton.icon(
                onPressed: () => _onDiscard(context),
                icon: const Icon(Icons.delete_outline_rounded),
                label: const Text('Discard'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: cs.error,
                  side: BorderSide(color: cs.error),
                  minimumSize: const Size.fromHeight(48),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  void _onSave() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: insert into SQLite via TaskRepository — next commit
      Navigator.pop(context);
    }
  }

  void _onDiscard(BuildContext context) {
    if (_nameController.text.isNotEmpty) {
      showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Discard changes?'),
          content: const Text('Your task will not be saved.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Keep Editing'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(ctx).colorScheme.error),
              child: const Text('Discard'),
            ),
          ],
        ),
      ).then((confirmed) {
        if (confirmed == true && mounted) Navigator.pop(context);
      });
    } else {
      Navigator.pop(context);
    }
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        label.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
