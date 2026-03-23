import 'package:flutter/material.dart';

import 'session_view_screen.dart';

class SessionSetupScreen extends StatefulWidget {
  const SessionSetupScreen({super.key});

  @override
  State<SessionSetupScreen> createState() => _SessionSetupScreenState();
}

class _SessionSetupScreenState extends State<SessionSetupScreen> {

  final _nameController = TextEditingController();

  // Task selection
  String _selectedTask = 'Research Paper';

  // Timer
  int _workMin      = 25;
  int _breakMin     = 5;
  int _longBreakMin = 25;

  // Audio layers
  double _rainVol     = 0.70;
  double _noiseVol    = 0.45;
  double _lofiVol     = 0.30;
  double _cafeVol     = 0.00;
  double _natureVol   = 0.00;

  // Background colour
  Color _bgColor = const Color(0xFF1A1030);

  static const List<String> _availableTasks = [
    'Research Paper',
    'Flutter Assignment',
    'Essay Draft v2',
    'Math Practice',
  ];

  static const List<Color> _colorOptions = [
    Color(0xFF1A1030),
    Color(0xFF0D1B2A),
    Color(0xFF0F2027),
    Color(0xFF1B0A0A),
    Color(0xFF0A1A0A),
    Color(0xFF1A1A0A),
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  String get _formattedWork =>
      '${_workMin.toString().padLeft(2, '0')}:00';

  void _onTaskTap() {
    showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _TaskPickerSheet(
        tasks: _availableTasks,
        selected: _selectedTask,
      ),
    ).then((picked) {
      if (picked != null) setState(() => _selectedTask = picked);
    });
  }

  void _onLaunch() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => SessionViewScreen(
          taskName: _selectedTask,
          sessionName: _nameController.text.trim().isEmpty
              ? _selectedTask
              : _nameController.text.trim(),
          workMinutes: _workMin,
          breakMinutes: _breakMin,
          longBreakMinutes: _longBreakMin,
          bgColor: _bgColor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          tooltip: 'Cancel',
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Session Setup',
          style: tt.titleLarge?.copyWith(fontWeight: FontWeight.w800),
        ),
        actions: [
          FilledButton(
            onPressed: _onLaunch,
            child: const Text('Launch'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [

            // ── Task Focus ─────────────────────────────────────────
            _SectionLabel(label: 'Task Focus'),
            GestureDetector(
              onTap: _onTaskTap,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: cs.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: cs.outlineVariant),
                ),
                child: Row(
                  children: [
                    Icon(Icons.task_alt_rounded,
                        color: cs.primary, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _selectedTask,
                        style: tt.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                    Icon(Icons.expand_more_rounded,
                        color: cs.onSurfaceVariant),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ── Session Name ────────────────────────────────────────
            _SectionLabel(label: 'Session Name (optional)'),
            TextField(
              controller: _nameController,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: 'e.g. Deep Work Block',
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ── Background Colour ───────────────────────────────────
            _SectionLabel(label: 'Background Color'),
            Row(
              children: [
                for (final color in _colorOptions)
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: GestureDetector(
                      onTap: () => setState(() => _bgColor = color),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _bgColor == color
                                ? cs.primary
                                : cs.outlineVariant,
                            width: _bgColor == color ? 3 : 1,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 24),

            // ── Audio Mix ───────────────────────────────────────────
            _SectionLabel(label: 'Audio Mix'),
            Card(
              color: cs.surfaceContainerLow,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Column(
                  children: [
                    _AudioRow(icon: '🌧', label: 'Rain',        value: _rainVol,   onChanged: (v) => setState(() => _rainVol = v)),
                    _AudioRow(icon: '🌊', label: 'Brown Noise', value: _noiseVol,  onChanged: (v) => setState(() => _noiseVol = v)),
                    _AudioRow(icon: '🎵', label: 'Lo-fi',       value: _lofiVol,   onChanged: (v) => setState(() => _lofiVol = v)),
                    _AudioRow(icon: '☕', label: 'Cafe',         value: _cafeVol,   onChanged: (v) => setState(() => _cafeVol = v)),
                    _AudioRow(icon: '🌿', label: 'Nature',      value: _natureVol, onChanged: (v) => setState(() => _natureVol = v)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ── Timer ───────────────────────────────────────────────
            _SectionLabel(label: 'Timer'),
            Card(
              color: cs.surfaceContainerLow,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                child: Column(
                  children: [
                    _TimerRow(
                      label: 'Work',
                      value: _workMin,
                      onDecrement: () => setState(() {
                        if (_workMin > 5) _workMin -= 5;
                      }),
                      onIncrement: () => setState(() {
                        if (_workMin < 120) _workMin += 5;
                      }),
                    ),
                    Divider(height: 1, color: cs.outlineVariant),
                    _TimerRow(
                      label: 'Break',
                      value: _breakMin,
                      onDecrement: () => setState(() {
                        if (_breakMin > 5) _breakMin -= 5;
                      }),
                      onIncrement: () => setState(() {
                        if (_breakMin < 60) _breakMin += 5;
                      }),
                    ),
                    Divider(height: 1, color: cs.outlineVariant),
                    _TimerRow(
                      label: 'Long Break',
                      value: _longBreakMin,
                      onDecrement: () => setState(() {
                        if (_longBreakMin > 5) _longBreakMin -= 5;
                      }),
                      onIncrement: () => setState(() {
                        if (_longBreakMin < 120) _longBreakMin += 5;
                      }),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            FilledButton.icon(
              onPressed: _onLaunch,
              icon: const Icon(Icons.play_arrow_rounded, size: 24),
              label: const Text('Launch Session'),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
              ),
            ),

            const SizedBox(height: 12),

            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
              child: const Text('Cancel'),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// ── Task Picker Sheet ─────────────────────────────────────────────────────────

class _TaskPickerSheet extends StatelessWidget {
  const _TaskPickerSheet({
    required this.tasks,
    required this.selected,
  });

  final List<String> tasks;
  final String selected;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36, height: 4,
                decoration: BoxDecoration(
                  color: cs.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('Select Task', style: tt.titleLarge),
            const Divider(),
            for (final task in tasks)
              ListTile(
                leading: Icon(Icons.task_alt_rounded,
                    color: task == selected
                        ? cs.primary
                        : cs.onSurfaceVariant),
                title: Text(task),
                trailing: task == selected
                    ? Icon(Icons.check_rounded, color: cs.primary)
                    : null,
                onTap: () => Navigator.pop(context, task),
              ),
          ],
        ),
      ),
    );
  }
}

// ── Section Label ─────────────────────────────────────────────────────────────

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

// ── Audio Row ─────────────────────────────────────────────────────────────────

class _AudioRow extends StatelessWidget {
  const _AudioRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String icon;
  final String label;
  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 10),
          SizedBox(
            width: 88,
            child: Text(label, style: tt.bodySmall),
          ),
          Expanded(
            child: Slider(
              value: value,
              min: 0,
              max: 1,
              onChanged: onChanged,
            ),
          ),
          SizedBox(
            width: 36,
            child: Text(
              '${(value * 100).round()}%',
              style: tt.labelSmall
                  ?.copyWith(color: cs.onSurfaceVariant),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Timer Row ─────────────────────────────────────────────────────────────────

class _TimerRow extends StatelessWidget {
  const _TimerRow({
    required this.label,
    required this.value,
    required this.onDecrement,
    required this.onIncrement,
  });

  final String label;
  final int value;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(child: Text(label, style: tt.bodyMedium)),
          Container(
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: cs.outlineVariant),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_rounded, size: 16),
                  onPressed: onDecrement,
                  tooltip: 'Decrease',
                  visualDensity: VisualDensity.compact,
                ),
                SizedBox(
                  width: 60,
                  child: Text(
                    '$value min',
                    textAlign: TextAlign.center,
                    style: tt.labelLarge
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_rounded, size: 16),
                  onPressed: onIncrement,
                  tooltip: 'Increase',
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}