import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  int _workMin      = 25;
  int _breakMin     = 5;
  int _longBreakMin = 25;

  double _rainVol     = 0.70;
  double _noiseVol    = 0.45;
  double _lofiVol     = 0.30;
  double _binauralVol = 0.55;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          snap: true,
          title: Text(
            'Settings',
            style: tt.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.dark_mode_outlined),
              tooltip: 'Toggle dark mode',
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.more_vert),
              tooltip: 'More options',
              onPressed: () {},
            ),
          ],
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: Column(
              children: [

                _SettingsSection(
                  title: 'Session Editor',
                  subtitle: 'Name, color & icon for session presets',
                  icon: Icons.tune_rounded,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Session Name',
                          hintText: 'e.g. Deep Work',
                          prefixIcon: const Icon(Icons.label_outline),
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Text(
                            'Session color',
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(width: 12),
                          for (final (color, isSelected) in [
                            (Colors.deepPurple, true),
                            (Colors.teal,       false),
                            (Colors.amber,      false),
                            (Colors.blue,       false),
                            (Colors.pink,       false),
                          ])
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: GestureDetector(
                                onTap: () {},
                                child: Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: color,
                                    shape: BoxShape.circle,
                                    border: isSelected
                                        ? Border.all(
                                            color: Colors.white, width: 2)
                                        : null,
                                    boxShadow: isSelected
                                        ? [BoxShadow(
                                            color: color.withOpacity(0.5),
                                            blurRadius: 6)]
                                        : null,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                _SettingsSection(
                  title: 'Timer Editor',
                  subtitle: 'Work, break & long break intervals',
                  icon: Icons.timer_outlined,
                  child: Column(
                    children: [
                      _TimerRow(
                        label: 'Work',
                        value: _workMin,
                        unit: 'min',
                        onDecrement: () =>
                            setState(() { if (_workMin > 5) _workMin -= 5; }),
                        onIncrement: () =>
                            setState(() { if (_workMin < 120) _workMin += 5; }),
                      ),
                      const Divider(height: 1),
                      _TimerRow(
                        label: 'Break',
                        value: _breakMin,
                        unit: 'min',
                        onDecrement: () =>
                            setState(() { if (_breakMin > 5) _breakMin -= 5; }),
                        onIncrement: () =>
                            setState(() { if (_breakMin < 60) _breakMin += 5; }),
                      ),
                      const Divider(height: 1),
                      _TimerRow(
                        label: 'Long Break',
                        value: _longBreakMin,
                        unit: 'min',
                        onDecrement: () =>
                            setState(() { if (_longBreakMin > 5) _longBreakMin -= 5; }),
                        onIncrement: () =>
                            setState(() { if (_longBreakMin < 120) _longBreakMin += 5; }),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                _SettingsSection(
                  title: 'Audio Mix Editor',
                  subtitle: 'Layer volumes · save as preset',
                  icon: Icons.music_note_outlined,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 130,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _AudioSlider(label: 'Rain',     value: _rainVol,
                                onChanged: (v) => setState(() => _rainVol = v)),
                            _AudioSlider(label: 'Noise',    value: _noiseVol,
                                onChanged: (v) => setState(() => _noiseVol = v)),
                            _AudioSlider(label: 'Lo-fi',    value: _lofiVol,
                                onChanged: (v) => setState(() => _lofiVol = v)),
                            _AudioSlider(label: 'Binaural', value: _binauralVol,
                                onChanged: (v) => setState(() => _binauralVol = v)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.play_arrow_rounded),
                              label: const Text('Preview'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.stop_rounded),
                              label: const Text('Stop'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: FilledButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Save preset — next commit')),
                                );
                              },
                              icon: const Icon(Icons.save_rounded),
                              label: const Text('Save'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SettingsSection extends StatefulWidget {
  const _SettingsSection({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.child,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Widget child;

  @override
  State<_SettingsSection> createState() => _SettingsSectionState();
}

class _SettingsSectionState extends State<_SettingsSection> {

  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Card(
      color: cs.surfaceContainerLow,
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: cs.primaryContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(widget.icon,
                        size: 18, color: cs.onPrimaryContainer),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.title,
                            style: tt.titleSmall
                                ?.copyWith(fontWeight: FontWeight.w700)),
                        Text(widget.subtitle,
                            style: tt.bodySmall
                                ?.copyWith(color: cs.onSurfaceVariant)),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(Icons.keyboard_arrow_down_rounded,
                        color: cs.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: widget.child,
            ),
            secondChild: const SizedBox.shrink(),
            crossFadeState: _expanded
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }
}

class _TimerRow extends StatelessWidget {
  const _TimerRow({
    required this.label,
    required this.value,
    required this.unit,
    required this.onDecrement,
    required this.onIncrement,
  });

  final String label;
  final int value;
  final String unit;
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
                    '$value $unit',
                    textAlign: TextAlign.center,
                    style: tt.labelLarge?.copyWith(fontWeight: FontWeight.w700),
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

class _AudioSlider extends StatelessWidget {
  const _AudioSlider({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          '${(value * 100).round()}%',
          style: tt.labelSmall?.copyWith(
            color: cs.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: 36,
          height: 80,
          child: RotatedBox(
            quarterTurns: 3,
            child: Slider(
              value: value,
              onChanged: onChanged,
              min: 0,
              max: 1,
              semanticFormatterCallback: (v) =>
                  '${(v * 100).round()} percent',
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: tt.labelSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
