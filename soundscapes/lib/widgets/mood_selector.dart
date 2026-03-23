import 'package:flutter/material.dart';
import '../core/constants/app_strings.dart';

class MoodSelector extends StatelessWidget {
  final String selectedMood;
  final ValueChanged<String> onMoodSelected;

  const MoodSelector({
    super.key,
    required this.selectedMood,
    required this.onMoodSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.mood,
          style: theme.textTheme.headlineMedium,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: AppStrings.moods.map((mood) {
            final isSelected = selectedMood == mood;
            return ChoiceChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_getEmojiForMood(mood)),
                  const SizedBox(width: 8),
                  Text(mood),
                ],
              ),
              selected: isSelected,
              onSelected: (_) => onMoodSelected(mood),
              selectedColor: theme.colorScheme.primaryContainer,
            );
          }).toList(),
        ),
      ],
    );
  }

  String _getEmojiForMood(String mood) {
    switch (mood) {
      case 'Focused':
        return '🎯';
      case 'Calm':
        return '😌';
      case 'Anxious':
        return '😰';
      case 'Tired':
        return '😴';
      case 'Energized':
        return '⚡';
      case 'Creative':
        return '🎨';
      default:
        return '😊';
    }
  }
}
