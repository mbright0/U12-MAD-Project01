import 'package:flutter/material.dart';

class SessionEditScreen extends StatefulWidget {
  const SessionEditScreen({super.key});

  @override
  State<SessionEditScreen> createState() => _SessionEditScreenState();
}

class _SessionEditScreenState extends State<SessionEditScreen> {

  int _workMin      = 25;
  int _breakMin     = 5;
  int _longBreakMin = 25;

  String _selectedMood    = 'focused';
  String _selectedPreset  = 'rain';
  int    _energyLevel     = 5;

  static const List<(String, String)> _moods = [
    ('focused',   '😤 Focused'),
    ('calm',      '😌 Calm'),
    ('motivated', '😊 Motivated'),
    ('anxious',   '😰 Anxious'),
    ('neutral',   '😐 Neutral'),
  ];

  static const List<(String, String)> _presets = [
    ('rain',     '🌧 Rain'),
    ('noise',    '🌊 Brown Noise'),
    ('lofi',     '🎵 Lo-fi'),
    ('binaural', '🎧 Binaural'),
    ('none',     '🔇 None'),
  ];

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
          'Session Settings',
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
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [

            // Mood
            _SectionLabel(label: 'Current Mood'),
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

            // Audio preset
            _SectionLabel(label: 'Audio Preset'),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final (value, label) in _presets)
                  ChoiceChip(
                    label: Text(label),
                    selected: _selectedPreset == value,
                    onSelected: (_) =>
                        setState(() => _selectedPreset = value),
                  ),
              ],
            ),

            const SizedBox(height: 24),

            // Timer settings
            _SectionLabel(label: 'Timer Settings'),
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

            // Launch session button
            FilledButton.icon(
              onPressed: _onLaunch,
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('Launch Session'),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
              ),
            ),

            const SizedBox(height: 12),

            // Discard
            OutlinedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close_rounded),
              label: const Text('Cancel'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
            ),

          ],
        ),
      ),
    );
  }

  void _onSave() {
    // TODO: save session config to SharedPreferences — next commit
    Navigator.pop(context);
  }

  void _onLaunch() {
    // TODO: push to SessionScreen with config — next commit
    Navigator.pop(context);
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
