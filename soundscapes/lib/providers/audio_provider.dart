import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioProvider with ChangeNotifier {
  // Volume state (0.0 to 1.0)
  double _rainVolume = 0.0;
  double _lofiVolume = 0.0;
  double _whiteNoiseVolume = 0.0;
  double _cafeVolume = 0.0;
  double _natureVolume = 0.0;
  double _masterVolume = 1.0;

  // Playback state
  bool _isPlaying = false;
  bool _isInitialized = false;

  // AudioPlayer instances
  late final AudioPlayer _rainPlayer;
  late final AudioPlayer _lofiPlayer;
  late final AudioPlayer _whiteNoisePlayer;
  late final AudioPlayer _cafePlayer;
  late final AudioPlayer _naturePlayer;

  // Getters
  double get rainVolume => _rainVolume;
  double get lofiVolume => _lofiVolume;
  double get whiteNoiseVolume => _whiteNoiseVolume;
  double get cafeVolume => _cafeVolume;
  double get natureVolume => _natureVolume;
  double get masterVolume => _masterVolume;
  bool get isPlaying => _isPlaying;
  bool get isInitialized => _isInitialized;

  Map<String, double> get allVolumes => {
        'rain': _rainVolume,
        'lofi': _lofiVolume,
        'whiteNoise': _whiteNoiseVolume,
        'cafe': _cafeVolume,
        'nature': _natureVolume,
      };

  AudioProvider() {
    _initializePlayers();
  }

  // Initialize all audio players
  Future<void> _initializePlayers() async {
    try {
      _rainPlayer = AudioPlayer();
      _lofiPlayer = AudioPlayer();
      _whiteNoisePlayer = AudioPlayer();
      _cafePlayer = AudioPlayer();
      _naturePlayer = AudioPlayer();

      // Set release mode to loop
      await _rainPlayer.setReleaseMode(ReleaseMode.loop);
      await _lofiPlayer.setReleaseMode(ReleaseMode.loop);
      await _whiteNoisePlayer.setReleaseMode(ReleaseMode.loop);
      await _cafePlayer.setReleaseMode(ReleaseMode.loop);
      await _naturePlayer.setReleaseMode(ReleaseMode.loop);

      // Set initial volumes to 0
      await _rainPlayer.setVolume(0.0);
      await _lofiPlayer.setVolume(0.0);
      await _whiteNoisePlayer.setVolume(0.0);
      await _cafePlayer.setVolume(0.0);
      await _naturePlayer.setVolume(0.0);

      // Preload audio sources
      await _rainPlayer.setSource(AssetSource('audio/rain.mp3'));
      await _lofiPlayer.setSource(AssetSource('audio/lofi.mp3'));
      await _whiteNoisePlayer.setSource(AssetSource('audio/whitenoise.mp3'));
      await _cafePlayer.setSource(AssetSource('audio/cafe.mp3'));
      await _naturePlayer.setSource(AssetSource('audio/nature.mp3'));

      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error initializing audio players: $e');
      _isInitialized = false;
    }
  }

  // Play all audio
  Future<void> play() async {
    if (!_isInitialized) return;
    
    try {
      await _rainPlayer.resume();
      await _lofiPlayer.resume();
      await _whiteNoisePlayer.resume();
      await _cafePlayer.resume();
      await _naturePlayer.resume();
      _isPlaying = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error playing audio: $e');
    }
  }

  // Pause all audio
  Future<void> pause() async {
    if (!_isInitialized) return;
    
    try {
      await _rainPlayer.pause();
      await _lofiPlayer.pause();
      await _whiteNoisePlayer.pause();
      await _cafePlayer.pause();
      await _naturePlayer.pause();
      _isPlaying = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error pausing audio: $e');
    }
  }

  // Stop all audio
  Future<void> stop() async {
    if (!_isInitialized) return;
    
    try {
      await _rainPlayer.stop();
      await _lofiPlayer.stop();
      await _whiteNoisePlayer.stop();
      await _cafePlayer.stop();
      await _naturePlayer.stop();
      _isPlaying = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error stopping audio: $e');
    }
  }

  // Volume setters with player sync
  Future<void> setRainVolume(double volume) async {
    _rainVolume = volume.clamp(0.0, 1.0);
    if (_isInitialized) {
      await _rainPlayer.setVolume(_rainVolume * _masterVolume);
    }
    notifyListeners();
  }

  Future<void> setLofiVolume(double volume) async {
    _lofiVolume = volume.clamp(0.0, 1.0);
    if (_isInitialized) {
      await _lofiPlayer.setVolume(_lofiVolume * _masterVolume);
    }
    notifyListeners();
  }

  Future<void> setWhiteNoiseVolume(double volume) async {
    _whiteNoiseVolume = volume.clamp(0.0, 1.0);
    if (_isInitialized) {
      await _whiteNoisePlayer.setVolume(_whiteNoiseVolume * _masterVolume);
    }
    notifyListeners();
  }

  Future<void> setCafeVolume(double volume) async {
    _cafeVolume = volume.clamp(0.0, 1.0);
    if (_isInitialized) {
      await _cafePlayer.setVolume(_cafeVolume * _masterVolume);
    }
    notifyListeners();
  }

  Future<void> setNatureVolume(double volume) async {
    _natureVolume = volume.clamp(0.0, 1.0);
    if (_isInitialized) {
      await _naturePlayer.setVolume(_natureVolume * _masterVolume);
    }
    notifyListeners();
  }

  Future<void> setMasterVolume(double volume) async {
    _masterVolume = volume.clamp(0.0, 1.0);
    if (_isInitialized) {
      // Update all player volumes
      await _rainPlayer.setVolume(_rainVolume * _masterVolume);
      await _lofiPlayer.setVolume(_lofiVolume * _masterVolume);
      await _whiteNoisePlayer.setVolume(_whiteNoiseVolume * _masterVolume);
      await _cafePlayer.setVolume(_cafeVolume * _masterVolume);
      await _naturePlayer.setVolume(_natureVolume * _masterVolume);
    }
    notifyListeners();
  }

  // Apply AI-recommended mix or custom volumes
  Future<void> setAllVolumes(Map<String, double> volumes) async {
    _rainVolume = (volumes['rain'] ?? 0.0).clamp(0.0, 1.0);
    _lofiVolume = (volumes['lofi'] ?? 0.0).clamp(0.0, 1.0);
    _whiteNoiseVolume = (volumes['whiteNoise'] ?? 0.0).clamp(0.0, 1.0);
    _cafeVolume = (volumes['cafe'] ?? 0.0).clamp(0.0, 1.0);
    _natureVolume = (volumes['nature'] ?? 0.0).clamp(0.0, 1.0);
    
    if (_isInitialized) {
      await _rainPlayer.setVolume(_rainVolume * _masterVolume);
      await _lofiPlayer.setVolume(_lofiVolume * _masterVolume);
      await _whiteNoisePlayer.setVolume(_whiteNoiseVolume * _masterVolume);
      await _cafePlayer.setVolume(_cafeVolume * _masterVolume);
      await _naturePlayer.setVolume(_natureVolume * _masterVolume);
    }
    notifyListeners();
  }

  // Reset all volumes to zero
  Future<void> resetAll() async {
    _rainVolume = 0.0;
    _lofiVolume = 0.0;
    _whiteNoiseVolume = 0.0;
    _cafeVolume = 0.0;
    _natureVolume = 0.0;
    _isPlaying = false;
    
    if (_isInitialized) {
      await _rainPlayer.setVolume(0.0);
      await _lofiPlayer.setVolume(0.0);
      await _whiteNoisePlayer.setVolume(0.0);
      await _cafePlayer.setVolume(0.0);
      await _naturePlayer.setVolume(0.0);
      await stop();
    }
    notifyListeners();
  }

  @override
  void dispose() {
    if (_isInitialized) {
      _rainPlayer.dispose();
      _lofiPlayer.dispose();
      _whiteNoisePlayer.dispose();
      _cafePlayer.dispose();
      _naturePlayer.dispose();
    }
    super.dispose();
  }
}
