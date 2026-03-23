class Session {
  final int? id;
  final String mood;
  final String taskType;
  final int energyLevel;
  final int durationMinutes;
  final int completedPomodoros;
  final int distractionCount;
  final int focusScore;
  final String audioPresetName;
  final String blueprintName;
  final DateTime createdAt;

  Session({
    this.id,
    required this.mood,
    required this.taskType,
    required this.energyLevel,
    required this.durationMinutes,
    required this.completedPomodoros,
    required this.distractionCount,
    required this.focusScore,
    required this.audioPresetName,
    required this.blueprintName,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'mood': mood,
      'task_type': taskType,
      'energy_level': energyLevel,
      'duration_minutes': durationMinutes,
      'completed_pomodoros': completedPomodoros,
      'distraction_count': distractionCount,
      'focus_score': focusScore,
      'audio_preset_name': audioPresetName,
      'blueprint_name': blueprintName,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Session.fromMap(Map<String, dynamic> map) {
    return Session(
      id: map['id'],
      mood: map['mood'],
      taskType: map['task_type'],
      energyLevel: map['energy_level'],
      durationMinutes: map['duration_minutes'],
      completedPomodoros: map['completed_pomodoros'],
      distractionCount: map['distraction_count'],
      focusScore: map['focus_score'],
      audioPresetName: map['audio_preset_name'],
      blueprintName: map['blueprint_name'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}