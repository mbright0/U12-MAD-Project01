class AIEngine {
  // Returns a recommended soundscape mix based on mood, task, and energy
  static Map<String, double> recommendSoundscape({
    required String mood,
    required String taskType,
    required int energyLevel,
  }) {
    // Default volumes all off
    double rain = 0.0;
    double lofi = 0.0;
    double whiteNoise = 0.0;
    double cafe = 0.0;
    double nature = 0.0;

    // Mood-based rules
    switch (mood) {
      case 'Focused':
        whiteNoise = 0.4;
        lofi = 0.5;
        break;
      case 'Calm':
        rain = 0.6;
        nature = 0.4;
        break;
      case 'Anxious':
        rain = 0.7;
        nature = 0.3;
        break;
      case 'Tired':
        lofi = 0.6;
        cafe = 0.4;
        break;
      case 'Energized':
        lofi = 0.7;
        whiteNoise = 0.3;
        break;
      case 'Creative':
        cafe = 0.5;
        lofi = 0.4;
        nature = 0.2;
        break;
    }

    // Task-based adjustments
    switch (taskType) {
      case 'Studying':
        whiteNoise = (whiteNoise + 0.2).clamp(0.0, 1.0);
        break;
      case 'Reading':
        rain = (rain + 0.2).clamp(0.0, 1.0);
        cafe = (cafe - 0.1).clamp(0.0, 1.0);
        break;
      case 'Writing':
        cafe = (cafe + 0.2).clamp(0.0, 1.0);
        break;
      case 'Coding':
        lofi = (lofi + 0.2).clamp(0.0, 1.0);
        whiteNoise = (whiteNoise + 0.1).clamp(0.0, 1.0);
        break;
      case 'Problem Solving':
        whiteNoise = (whiteNoise + 0.3).clamp(0.0, 1.0);
        cafe = (cafe - 0.1).clamp(0.0, 1.0);
        break;
      case 'Review':
        nature = (nature + 0.2).clamp(0.0, 1.0);
        lofi = (lofi + 0.1).clamp(0.0, 1.0);
        break;
    }

    // Energy-based adjustments
    // Low energy (1-2): boost calm sounds
    // High energy (4-5): boost stimulating sounds
    if (energyLevel <= 2) {
      rain = (rain + 0.1).clamp(0.0, 1.0);
      lofi = (lofi + 0.1).clamp(0.0, 1.0);
      whiteNoise = (whiteNoise - 0.1).clamp(0.0, 1.0);
    } else if (energyLevel >= 4) {
      lofi = (lofi + 0.1).clamp(0.0, 1.0);
      cafe = (cafe + 0.1).clamp(0.0, 1.0);
      rain = (rain - 0.1).clamp(0.0, 1.0);
    }

    return {
      'rain': rain,
      'lofi': lofi,
      'whiteNoise': whiteNoise,
      'cafe': cafe,
      'nature': nature,
    };
  }

  // Returns a human-readable explanation of the suggestion
  static String explainSuggestion({
    required String mood,
    required String taskType,
    required int energyLevel,
  }) {
    final reasons = <String>[];

    if (mood == 'Anxious' || mood == 'Calm') {
      reasons.add('rain and nature sounds to reduce stress');
    } else if (mood == 'Tired') {
      reasons.add('lo-fi beats to keep you gently stimulated');
    } else if (mood == 'Energized' || mood == 'Focused') {
      reasons.add('lo-fi and white noise to channel your energy');
    } else if (mood == 'Creative') {
      reasons.add('cafe ambience to spark creative thinking');
    }

    if (taskType == 'Coding' || taskType == 'Problem Solving') {
      reasons.add('white noise to block distractions');
    } else if (taskType == 'Writing') {
      reasons.add('cafe sounds to keep ideas flowing');
    } else if (taskType == 'Reading') {
      reasons.add('rain to help you stay immersed');
    }

    if (energyLevel <= 2) {
      reasons.add('calmer mix since your energy is low');
    } else if (energyLevel >= 4) {
      reasons.add('slightly livelier mix to match your energy');
    }

    if (reasons.isEmpty) return 'Custom mix based on your session settings.';

    return 'Suggested based on: ${reasons.join(', ')}.';
  }

  // Returns a recommended session duration based on energy level
  static int recommendDuration(int energyLevel) {
    if (energyLevel <= 2) return 15;
    if (energyLevel == 3) return 25;
    return 35;
  }

  // Returns a recommended break duration based on completed pomodoros
  static int recommendBreakDuration(int completedPomodoros) {
    // Every 4 pomodoros suggest a long break
    if (completedPomodoros > 0 && completedPomodoros % 4 == 0) return 15;
    return 5;
  }
}