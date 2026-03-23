import 'package:flutter/material.dart';
import '../core/utils/ai_engine.dart';

class AISuggestionBanner extends StatelessWidget {
  final String mood;
  final String taskType;
  final int energyLevel;
  final VoidCallback? onApply;

  const AISuggestionBanner({
    super.key,
    required this.mood,
    required this.taskType,
    required this.energyLevel,
    this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final suggestion = AIEngine.recommendSoundscape(
      mood: mood,
      taskType: taskType,
      energyLevel: energyLevel,
    );
    final explanation = AIEngine.explainSuggestion(
      mood: mood,
      taskType: taskType,
      energyLevel: energyLevel,
    );
    final recommendedDuration = AIEngine.recommendDuration(energyLevel);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.auto_awesome_rounded,
                color: theme.colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'AI Focus DJ',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            explanation,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: suggestion.entries
                .where((e) => e.value > 0)
                .map((e) => Chip(
                      label: Text(
                        '${_labelFor(e.key)} ${(e.value * 100).toInt()}%',
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                    ))
                .toList(),
          ),
          const SizedBox(height: 8),
          Text(
            'Recommended session length: $recommendedDuration min',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontStyle: FontStyle.italic,
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 12),
          if (onApply != null)
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: onApply,
	        child: const Text('Apply Mix'),
	      ),
            ),
        ],
      ),
    );
  }

  String _labelFor(String key) {
    switch (key) {
      case 'rain':
        return '🌧 Rain';
      case 'lofi':
        return '🎵 Lo-Fi';
      case 'whiteNoise':
        return '〰 White Noise';
      case 'cafe':
        return '☕ Cafe';
      case 'nature':
        return '🌿 Nature';
      default:
        return key;
    }
  }
}
