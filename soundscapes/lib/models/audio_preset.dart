class AudioPreset {
  final int? id;
  final String name;
  final double rainVolume;
  final double lofiVolume;
  final double whiteNoiseVolume;
  final double cafeVolume;
  final double natureVolume;
  final DateTime createdAt;

  AudioPreset({
    this.id,
    required this.name,
    required this.rainVolume,
    required this.lofiVolume,
    required this.whiteNoiseVolume,
    required this.cafeVolume,
    required this.natureVolume,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'rain_volume': rainVolume,
      'lofi_volume': lofiVolume,
      'white_noise_volume': whiteNoiseVolume,
      'cafe_volume': cafeVolume,
      'nature_volume': natureVolume,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory AudioPreset.fromMap(Map<String, dynamic> map) {
    return AudioPreset(
      id: map['id'],
      name: map['name'],
      rainVolume: map['rain_volume'],
      lofiVolume: map['lofi_volume'],
      whiteNoiseVolume: map['white_noise_volume'],
      cafeVolume: map['cafe_volume'],
      natureVolume: map['nature_volume'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}

