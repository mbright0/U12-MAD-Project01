import 'package:flutter/material.dart';
import '../models/session.dart';
import '../models/distraction_log.dart';
import '../core/database/database_helper.dart';

class SessionProvider extends ChangeNotifier {
  // Setup values
  String _mood = 'Focused';
  String _taskType = 'Studying';
  int _energyLevel = 3;
  int _durationMinutes = 25;
  String _audioPresetName = 'None';
  String _blueprintName = 'Custom';

  // Timer state
  bool _isRunning = false;
  bool _isBreak = false;
  int _secondsRemaining = 25 * 60;
  int _completedPomodoros = 0;
  int _distractionCount = 0;
  int _focusScore = 100;

  // Getters
  String get mood => _mood;
  String get taskType => _taskType;
  int get energyLevel => _energyLevel;
  int get durationMinutes => _durationMinutes;
  String get audioPresetName => _audioPresetName;
  String get blueprintName => _blueprintName;
  bool get isRunning => _isRunning;
  bool get isBreak => _isBreak;
  int get secondsRemaining => _secondsRemaining;
  int get completedPomodoros => _completedPomodoros;
  int get distractionCount => _distractionCount;
  int get focusScore => _focusScore;

  // Setup setters
  void setMood(String mood) {
    _mood = mood;
    notifyListeners();
  }

  void setTaskType(String taskType) {
    _taskType = taskType;
    notifyListeners();
  }

  void setEnergyLevel(int level) {
    _energyLevel = level;
    notifyListeners();
  }

  void setDurationMinutes(int minutes) {
    _durationMinutes = minutes;
    _secondsRemaining = minutes * 60;
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

  // Timer controls
  void startTimer() {
    _isRunning = true;
    notifyListeners();
  }

  void pauseTimer() {
    _isRunning = false;
    notifyListeners();
  }

  void tickTimer() {
    if (_secondsRemaining > 0) {
      _secondsRemaining--;
      notifyListeners();
    }
  }

  void logDistraction() {
    _distractionCount++;
    _focusScore = (_focusScore - 5).clamp(0, 100);
    notifyListeners();
  }

  void completePomodoroBlock() {
    _completedPomodoros++;
    _isBreak = true;
    _secondsRemaining = 5 * 60;
    _isRunning = false;
    notifyListeners();
  }

  void endBreak() {
    _isBreak = false;
    _secondsRemaining = _durationMinutes * 60;
    _isRunning = false;
    notifyListeners();
  }

  // Save session to SQLite
  Future<void> saveSession() async {
    final session = Session(
      mood: _mood,
      taskType: _taskType,
      energyLevel: _energyLevel,
      durationMinutes: _durationMinutes,
      completedPomodoros: _completedPomodoros,
      distractionCount: _distractionCount,
      focusScore: _focusScore,
      audioPresetName: _audioPresetName,
      blueprintName: _blueprintName,
      createdAt: DateTime.now(),
    );
    await DatabaseHelper.instance.insertSession(session);
  }

  // Log distraction to SQLite
  Future<void> saveDistractionLog(int sessionId, String note) async {
    final log = DistractionLog(
      sessionId: sessionId,
      note: note,
      loggedAt: DateTime.now(),
    );
    await DatabaseHelper.instance.insertDistractionLog(log);
  }

  void resetSession() {
    _isRunning = false;
    _isBreak = false;
    _secondsRemaining = _durationMinutes * 60;
    _completedPomodoros = 0;
    _distractionCount = 0;
    _focusScore = 100;
    notifyListeners();
  }
}