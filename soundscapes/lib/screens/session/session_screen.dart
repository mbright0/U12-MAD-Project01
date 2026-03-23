import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/session_provider.dart';
import '../../providers/audio_provider.dart';
import '../../core/constants/app_strings.dart';
import '../../core/database/database_helper.dart';
import '../../models/session.dart';
import '../../widgets/pomdoro_timer.dart';

class SessionScreen extends StatefulWidget {
  const SessionScreen({super.key});

  @override
  State<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
      final audioProvider = Provider.of<AudioProvider>(context, listen: false);
      
      sessionProvider.startSession();
      audioProvider.play();
    });
  }

  Future<void> _completeSession(BuildContext context) async {
    final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
    final audioProvider = Provider.of<AudioProvider>(context, listen: false);

    audioProvider.stop();

    final session = Session(
      mood: sessionProvider.mood,
      taskType: sessionProvider.taskType,
      energyLevel: sessionProvider.energyLevel,
      durationMinutes: sessionProvider.durationMinutes,
      completedPomodoros: sessionProvider.completedPomodoros,
      distractionCount: sessionProvider.distractionCount,
      focusScore: sessionProvider.focusScore,
      audioPresetName: sessionProvider.audioPresetName,
      blueprintName: sessionProvider.blueprintName,
      createdAt: sessionProvider.startTime ?? DateTime.now(),
    );

    final sessionId = await DatabaseHelper.instance.insertSession(session);

    if (context.mounted) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${AppStrings.sessionCompleted} (ID: $sessionId)')),
      );
    }
  }

  void _showStopDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Stop Session?'),
        content: const Text('Your progress will not be saved.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppStrings.cancel),
          ),
          FilledButton(
            onPressed: () {
              final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
              final audioProvider = Provider.of<AudioProvider>(context, listen: false);
              
              sessionProvider.stopSession();
              audioProvider.stop();
              
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text(AppStrings.stopSession),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sessionProvider = Provider.of<SessionProvider>(context);
    final audioProvider = Provider.of<AudioProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(sessionProvider.taskType),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => _showStopDialog(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Timer
                    PomodoroTimer(
                      remainingSeconds: sessionProvider.remainingSeconds,
                      totalSeconds: sessionProvider.durationMinutes * 60,
                      isPaused: sessionProvider.isPaused,
                    ),
                    const SizedBox(height: 32),

                    // Session info
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            _InfoRow(
                              icon: Icons.mood_outlined,
                              label: 'Mood',
                              value: sessionProvider.mood,
                            ),
                            const Divider(),
                            _InfoRow(
                              icon: Icons.task_outlined,
                              label: 'Task',
                              value: sessionProvider.taskType,
                            ),
                            const Divider(),
                            _InfoRow(
                              icon: Icons.battery_charging_full_outlined,
                              label: 'Energy',
                              value: '${sessionProvider.energyLevel}/5',
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Stats
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _StatCard(
                          icon: Icons.alarm_outlined,
                          label: 'Pomodoros',
                          value: '${sessionProvider.completedPomodoros}',
                          color: theme.colorScheme.primary,
                        ),
                        _StatCard(
                          icon: Icons.notifications_outlined,
                          label: 'Distractions',
                          value: '${sessionProvider.distractionCount}',
                          color: theme.colorScheme.error,
                        ),
                        _StatCard(
                          icon: Icons.score_outlined,
                          label: 'Focus',
                          value: '${sessionProvider.focusScore}',
                          color: theme.colorScheme.secondary,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Audio controls
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Audio Mix',
                                  style: theme.textTheme.titleMedium,
                                ),
                                Icon(
                                  audioProvider.isPlaying
                                      ? Icons.volume_up
                                      : Icons.volume_off,
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _VolumeSlider(
                              label: AppStrings.audioLabels['rain']!,
                              value: audioProvider.rainVolume,
                              onChanged: audioProvider.setRainVolume,
                            ),
                            _VolumeSlider(
                              label: AppStrings.audioLabels['lofi']!,
                              value: audioProvider.lofiVolume,
                              onChanged: audioProvider.setLofiVolume,
                            ),
                            _VolumeSlider(
                              label: AppStrings.audioLabels['whiteNoise']!,
                              value: audioProvider.whiteNoiseVolume,
                              onChanged: audioProvider.setWhiteNoiseVolume,
                            ),
                            _VolumeSlider(
                              label: AppStrings.audioLabels['cafe']!,
                              value: audioProvider.cafeVolume,
                              onChanged: audioProvider.setCafeVolume,
                            ),
                            _VolumeSlider(
                              label: AppStrings.audioLabels['nature']!,
                              value: audioProvider.natureVolume,
                              onChanged: audioProvider.setNatureVolume,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Controls
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Distraction log
                  IconButton.filled(
                    onPressed: () {
                      sessionProvider.incrementDistraction();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Distraction logged')),
                      );
                    },
                    icon: const Icon(Icons.notification_add_outlined),
                    tooltip: 'Log Distraction',
                  ),

                  // Pause/Resume
                  FilledButton.icon(
                    onPressed: () {
                      if (sessionProvider.isPaused) {
                        sessionProvider.resumeSession();
                        audioProvider.play();
                      } else {
                        sessionProvider.pauseSession();
                        audioProvider.pause();
                      }
                    },
                    icon: Icon(
                      sessionProvider.isPaused ? Icons.play_arrow : Icons.pause,
                    ),
                    label: Text(
                      sessionProvider.isPaused
                          ? AppStrings.resumeSession
                          : AppStrings.pauseSession,
                    ),
                  ),

                  // Complete
                  IconButton.filled(
                    onPressed: () => _completeSession(context),
                    icon: const Icon(Icons.check),
                    tooltip: AppStrings.completeSession,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 12),
          Text(label, style: theme.textTheme.bodyMedium),
          const Spacer(),
          Text(
            value,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _VolumeSlider extends StatelessWidget {
  final String label;
  final double value;
  final ValueChanged<double> onChanged;

  const _VolumeSlider({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Text('${(value * 100).round()}%'),
          ],
        ),
        Slider(
          value: value,
          onChanged: onChanged,
          min: 0.0,
          max: 1.0,
        ),
      ],
    );
  }
}
