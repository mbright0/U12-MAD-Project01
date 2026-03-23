import 'package:flutter/material.dart';

class SessionViewScreen extends StatefulWidget {
  const SessionViewScreen({
    super.key,
    required this.taskName,
    required this.sessionName,
    required this.workMinutes,
    required this.breakMinutes,
    required this.longBreakMinutes,
    required this.bgColor,
  });

  final String taskName;
  final String sessionName;
  final int workMinutes;
  final int breakMinutes;
  final int longBreakMinutes;
  final Color bgColor;

  @override
  State<SessionViewScreen> createState() => _SessionViewScreenState();
}

class _SessionViewScreenState extends State<SessionViewScreen> {

  bool _isPaused = false;
  String _timerStatus = 'Work';
  late int _remainingSeconds;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.workMinutes * 60;
  }

  String get _formattedTime {
    final m = _remainingSeconds ~/ 60;
    final s = _remainingSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  Color _statusColor(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return switch (_timerStatus) {
      'Break'      => Colors.green.shade600,
      'Long Break' => Colors.teal.shade600,
      _            => cs.primary,
    };
  }

  void _onPauseResume() {
    setState(() => _isPaused = !_isPaused);
    // TODO: pause/resume real countdown timer — next commit
  }

  void _onStop() {
    // TODO: save session as in-progress, push to ReviewScreen — next commit
    Navigator.pop(context);
  }

  void _onComplete() {
    // TODO: mark session complete, push to ReviewScreen — next commit
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: widget.bgColor,
      body: SafeArea(
        child: Column(
          children: [

            // ── Active task label ──────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: cs.primaryContainer.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      color: cs.primary.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.task_alt_rounded,
                        color: cs.primary, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.sessionName,
                            style: tt.labelSmall?.copyWith(
                              color: cs.primary.withOpacity(0.8),
                              letterSpacing: 0.5,
                            ),
                          ),
                          Text(
                            widget.taskName,
                            style: tt.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: cs.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Active',
                        style: tt.labelSmall?.copyWith(
                          color: cs.onPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Timer + status ─────────────────────────────────────
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    // Status label above ring
                    Text(
                      _timerStatus.toUpperCase(),
                      style: tt.labelLarge?.copyWith(
                        color: _statusColor(context),
                        letterSpacing: 3,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Timer ring
                    _TimerRing(
                      timeString: _formattedTime,
                      statusColor: _statusColor(context),
                      isPaused: _isPaused,
                    ),
                    const SizedBox(height: 16),

                    // Work / Break / Long Break indicator row
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (final label in ['Work', 'Break', 'Long Break'])
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8),
                            child: Column(
                              children: [
                                Text(
                                  label,
                                  style: tt.labelSmall?.copyWith(
                                    color: _timerStatus == label
                                        ? _statusColor(context)
                                        : Colors.white.withOpacity(0.4),
                                    fontWeight: _timerStatus == label
                                        ? FontWeight.w700
                                        : FontWeight.w400,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                AnimatedContainer(
                                  duration:
                                      const Duration(milliseconds: 200),
                                  height: 2,
                                  width: 24,
                                  decoration: BoxDecoration(
                                    color: _timerStatus == label
                                        ? _statusColor(context)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(1),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Control panel
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: Row(
                children: [
                  Expanded(
                    child: _ControlButton(
                      icon: _isPaused
                          ? Icons.play_arrow_rounded
                          : Icons.pause_rounded,
                      label: _isPaused ? 'Resume' : 'Pause',
                      color: Theme.of(context).colorScheme.primary,
                      onTap: _onPauseResume,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ControlButton(
                      icon: Icons.stop_rounded,
                      label: 'Stop',
                      color: Theme.of(context).colorScheme.error,
                      onTap: _onStop,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ControlButton(
                      icon: Icons.check_circle_rounded,
                      label: 'Complete',
                      color: Colors.green.shade600,
                      onTap: _onComplete,
                    ),
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

// ── Timer Ring ────────────────────────────────────────────────────────────────

class _TimerRing extends StatelessWidget {
  const _TimerRing({
    required this.timeString,
    required this.statusColor,
    required this.isPaused,
  });

  final String timeString;
  final Color statusColor;
  final bool isPaused;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Container(
      width: 220,
      height: 220,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: statusColor, width: 6),
        color: Colors.black.withOpacity(0.25),
        boxShadow: [
          BoxShadow(
            color: statusColor.withOpacity(0.2),
            blurRadius: 32,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              timeString,
              style: tt.displaySmall?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: -1,
                color: Colors.white,
              ),
            ),
            if (isPaused)
              Text(
                'Paused',
                style: tt.labelMedium?.copyWith(
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Control Button 

class _ControlButton extends StatelessWidget {
  const _ControlButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.5)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 4),
            Text(
              label,
              style: tt.labelSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
