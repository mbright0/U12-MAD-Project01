class Blueprint {
  final int? id;
  final String name;
  final String mood;
  final String taskType;
  final int energyLevel;
  final int durationMinutes;
  final String audioPresetName;
  final DateTime createdAt;

  Blueprint({
    this.id,
    required this.name,
    required this.mood,
    required this.taskType,
    required this.energyLevel,
    required this.durationMinutes,
    required this.audioPresetName,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'mood': mood,
      'task_type': taskType,
      'energy_level': energyLevel,
      'duration_minutes': durationMinutes,
      'audio_preset_name': audioPresetName,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Blueprint.fromMap(Map<String, dynamic> map) {
    return Blueprint(
      id: map['id'],
      name: map['name'],
      mood: map['mood'],
      taskType: map['task_type'],
      energyLevel: map['energy_level'],
      durationMinutes: map['duration_minutes'],
      audioPresetName: map['audio_preset_name'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}
