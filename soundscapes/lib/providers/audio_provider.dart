import 'package:flutter/material.dart';

class AudioProvider with ChangeNotifier {
  // Volumes
  double _rainVolume = 0.0;
  double _lofiVolume = 0.0;
  double _whiteNoiseVolume = 0.0;
  double _cafeVolume = 0.0;
  double _natureVolume = 0.0;

  // Playback
  bool _isPlaying = false;
  double _masterVolume = 1.0;

  // Getters
  double get rainVolume => _rainVolume;
  double get lofiVolume => _lofiVolume;
  double get whiteNoiseVolume => _whiteNoiseVolume;
  double get cafeVolume => _cafeVolume;
  double get natureVolume => _natureVolume;
  bool get isPlaying => _isPlaying;
  double get masterVolume => _masterVolume;

  Map<String, double> get allVolumes => {
        'rain': _rainVolume,
        'lofi': _lofiVolume,
        'whiteNoise': _whiteNoiseVolume,
        'cafe': _cafeVolume,
        'nature': _natureVolume,
      };

  void setRainVolume(double volume) {
    _rainVolume = volume.clamp(0.0, 1.0);
    notifyListeners();
  }

  void setLofiVolume(double volume) {
    _lofiVolume = volume.clamp(0.0, 1.0);
    notifyListeners();
  }

  void setWhiteNoiseVolume(double volume) {
    _whiteNoiseVolume = volume.clamp(0.0, 1.0);
    notifyListeners();
  }

  void setCafeVolume(double volume) {
    _cafeVolume = volume.clamp(0.0, 1.0);
    notifyListeners();
  }

  void setNatureVolume(double volume) {
    _natureVolume = volume.clamp(0.0, 1.0);
    notifyListeners();
  }

  void setMasterVolume(double volume) {
    _masterVolume = volume.clamp(0.0, 1.0);
    notifyListeners();
  }

  void setAllVolumes(Map<String, double> volumes) {
    _rainVolume = (volumes['rain'] ?? 0.0).clamp(0.0, 1.0);
    _lofiVolume = (volumes['lofi'] ?? 0.0).clamp(0.0, 1.0);
    _whiteNoiseVolume = (volumes['whiteNoise'] ?? 0.0).clamp(0.0, 1.0);
    _cafeVolume = (volumes['cafe'] ?? 0.0).clamp(0.0, 1.0);
    _natureVolume = (volumes['nature'] ?? 0.0).clamp(0.0, 1.0);
    notifyListeners();
  }

  void play() {
    _isPlaying = true;
    notifyListeners();
  }

  void pause() {
    _isPlaying = false;
    notifyListeners();
  }

  void stop() {
    _isPlaying = false;
    notifyListeners();
  }

  void resetAll() {
    _rainVolume = 0.0;
    _lofiVolume = 0.0;
    _whiteNoiseVolume = 0.0;
    _cafeVolume = 0.0;
    _natureVolume = 0.0;
    _isPlaying = false;
    notifyListeners();
  }
}
