import 'dart:async';
import 'package:flutter/material.dart';

class SessionProvider with ChangeNotifier {
  // Setup
  String _mood = 'Focused';
  String _taskType = 'Studying';
  int _energyLevel = 3;
  int _durationMinutes = 25;
  String _audioPresetName = 'None';
  String _blueprintName = 'None';

  // Active session
  bool _isActive = false;
  bool _isPaused = false;
  int _remainingSeconds = 0;
  int _completedPomodoros = 0;
  int _distractionCount = 0;
  Timer? _timer;
  DateTime? _startTime;

  // Getters - Setup
  String get mood => _mood;
  String get taskType => _taskType;
  int get energyLevel => _energyLevel;
  int get durationMinutes => _durationMinutes;
  String get audioPresetName => _audioPresetName;
  String get blueprintName => _blueprintName;

  // Getters - Active
  bool get isActive => _isActive;
  bool get isPaused => _isPaused;
  int get remainingSeconds => _remainingSeconds;
  int get completedPomodoros => _completedPomodoros;
  int get distractionCount => _distractionCount;
  DateTime? get startTime => _startTime;

  int get elapsedSeconds => (_durationMinutes * 60) - _remainingSeconds;
  double get progress => _durationMinutes > 0 ? elapsedSeconds / (_durationMinutes * 60) : 0.0;
  int get focusScore => _calculateFocusScore();

  // Setters - Setup
  void setMood(String mood) {
    _mood = mood;
    notifyListeners();
  }

  void setTaskType(String type) {
    _taskType = type;
    notifyListeners();
  }

  void setEnergyLevel(int level) {
    _energyLevel = level;
    notifyListeners();
  }

  void setDurationMinutes(int minutes) {
    _durationMinutes = minutes;
    notifyListeners();
  }

  void setAudioPresetName(String name) {
    _audioPresetName = name;
    notifyListeners();
  }

  void setBlueprintName(String name) {
    _blueprintName = name;
    notifyListeners();
  }

  // Session control
  void startSession() {
    _isActive = true;
    _isPaused = false;
    _remainingSeconds = _durationMinutes * 60;
    _startTime = DateTime.now();
    _startTimer();
    notifyListeners();
  }

  void pauseSession() {
    _isPaused = true;
    _distractionCount++;
    _timer?.cancel();
    notifyListeners();
  }

  void resumeSession() {
    _isPaused = false;
    _startTimer();
    notifyListeners();
  }

  void stopSession() {
    _isActive = false;
    _isPaused = false;
    _timer?.cancel();
    notifyListeners();
  }

  void completeSession() {
    _completedPomodoros++;
    stopSession();
    notifyListeners();
  }

  void incrementDistraction() {
    _distractionCount++;
    notifyListeners();
  }

  void resetSession() {
    _isActive = false;
    _isPaused = false;
    _remainingSeconds = 0;
    _completedPomodoros = 0;
    _distractionCount = 0;
    _startTime = null;
    _timer?.cancel();
    notifyListeners();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        notifyListeners();
      } else {
        completeSession();
      }
    });
  }

  int _calculateFocusScore() {
    if (!_isActive && _remainingSeconds == 0 && _completedPomodoros == 0) {
      return 0;
    }
    
    final totalTime = _durationMinutes * 60;
    final completionRate = elapsedSeconds / totalTime;
    final distractionPenalty = _distractionCount * 5;
    final baseScore = (completionRate * 100).round();
    
    return (baseScore - distractionPenalty).clamp(0, 100);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
