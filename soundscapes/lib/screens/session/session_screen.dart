import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/session_provider.dart';

class SessionScreen extends StatefulWidget {
  const SessionScreen({super.key});

  @override
  State<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer(SessionProvider provider) {
    provider.startTimer();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (provider.secondsRemaining > 0) {
        provider.tickTimer();
      } else {
        _timer?.cancel();
        if (!provider.isBreak) {
          provider.completePomodoroBlock();
          _showBreakDialog();
        } else {
          provider.endBreak();
          _showResumeDialog();
        }
      }
    });
  }

  void _pauseTimer(SessionProvider provider) {
    _timer?.cancel();
    provider.pauseTimer();
  }

  void _showBreakDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Pomodoro Complete!'),
        content: const Text('Time for a 5 minute break.'),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              final provider =
                  Provider.of<SessionProvider>(context, listen: false);
              _startTimer(provider);
            },
            child: const Text('Start Break'),
          ),
        ],
      ),
    );
  }

  void _showResumeDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Break Over!'),
        content: const Text('Ready for another focused session?'),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              final provider =
                  Provider.of<SessionProvider>(context, listen: false);
              _startTimer(provider);
            },
            child: const Text('Keep Going'),
          ),
        ],
      ),
    );
  }

  void _showDistractionDialog(SessionProvider provider) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Log Distraction'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'What distracted you?',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              provider.logDistraction();
              Navigator.pop(context);
            },
            child: const Text('Log'),
          ),
        ],
      ),
    );
  }

  Future<void> _endSession(SessionProvider provider) async {
    _timer?.cancel();
    provider.pauseTimer();
    await provider.saveSession();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Session saved!')),
      );
      Navigator.pop(context);
    }
  }

  String _formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SessionProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(provider.isBreak ? 'Break Time' : 'Focus Session'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Session info
              Column(
                children: [
                  Text(provider.mood,
                      style: theme.textTheme.headlineMedium),
                  const SizedBox(height: 4),
                  Text(provider.taskType,
                      style: theme.textTheme.bodyMedium),
                ],
              ),

              // Timer display
              Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.primaryContainer,
                ),
                child: Center(
                  child: Text(
                    _formatTime(provider.secondsRemaining),
                    style: theme.textTheme.headlineLarge?.copyWith(
                      fontSize: 52,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // Stats row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _StatChip(
                    label: 'Pomodoros',
                    value: provider.completedPomodoros.toString(),
                  ),
                  _StatChip(
                    label: 'Distractions',
                    value: provider.distractionCount.toString(),
                  ),
                  _StatChip(
                    label: 'Focus Score',
                    value: '${provider.focusScore}%',
                  ),
                ],
              ),

              // Controls
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FloatingActionButton(
                        heroTag: 'distraction',
                        onPressed: () => _showDistractionDialog(provider),
                        tooltip: 'Log distraction',
                        child: const Icon(Icons.warning_amber_rounded),
                      ),
                      const SizedBox(width: 24),
                      FloatingActionButton.large(
                        heroTag: 'playpause',
                        onPressed: () {
                          if (provider.isRunning) {
                            _pauseTimer(provider);
                          } else {
                            _startTimer(provider);
                          }
                        },
                        child: Icon(
                          provider.isRunning
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                        ),
                      ),
                      const SizedBox(width: 24),
                      FloatingActionButton(
                        heroTag: 'end',
                        onPressed: () => _endSession(provider),
                        tooltip: 'End session',
                        backgroundColor: theme.colorScheme.error,
                        child: const Icon(Icons.stop_rounded),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;

  const _StatChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(value,
            style: theme.textTheme.headlineMedium),
        Text(label,
            style: theme.textTheme.bodyMedium),
      ],
    );
  }
}