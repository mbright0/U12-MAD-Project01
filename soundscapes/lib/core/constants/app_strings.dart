class AppStrings {
  // App
  static const String appName = 'SoundScapes';
  static const String tagline = 'Focus. Flow. Finish.';
  
  // Moods
  static const List<String> moods = [
    'Focused',
    'Calm',
    'Anxious',
    'Tired',
    'Energized',
    'Creative'
  ];
  
  // Tasks
  static const List<String> taskTypes = [
    'Studying',
    'Reading',
    'Writing',
    'Coding',
    'Problem Solving',
    'Review'
  ];
  
  // Audio
  static const Map<String, String> audioLabels = {
    'rain': '🌧 Rain',
    'lofi': '🎵 Lo-Fi',
    'whiteNoise': '〰 White Noise',
    'cafe': '☕ Cafe',
    'nature': '🌿 Nature',
  };
  
  // Navigation
  static const String navHome = 'Home';
  static const String navHistory = 'History';
  static const String navSettings = 'Settings';
  
  // Buttons
  static const String startSession = 'Start Session';
  static const String pauseSession = 'Pause';
  static const String resumeSession = 'Resume';
  static const String stopSession = 'Stop';
  static const String completeSession = 'Complete';
  static const String save = 'Save';
  static const String cancel = 'Cancel';
  static const String delete = 'Delete';
  static const String edit = 'Edit';
  
  // Labels
  static const String mood = 'How are you feeling?';
  static const String taskType = 'What are you working on?';
  static const String energyLevel = 'Energy Level';
  static const String duration = 'Session Duration';
  static const String blueprints = 'Blueprints';
  static const String loadBlueprint = 'Load a Blueprint';
  static const String saveBlueprint = 'Save as Blueprint';
  
  // Messages
  static const String noBlueprints = 'No Blueprints Yet';
  static const String noBlueprintsDesc = 'Save your favorite session setups as blueprints to reuse them anytime.';
  static const String noSessions = 'No Sessions Yet';
  static const String noSessionsDesc = 'Your completed sessions will appear here.';
  static const String blueprintSaved = 'Blueprint saved successfully';
  static const String sessionCompleted = 'Session completed!';
  static const String sessionSaved = 'Session saved';
}
