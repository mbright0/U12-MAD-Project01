
README.md

Adaptive Focus Studio
A Flutter mobile application that helps students build better focus habits through personalized Pomodoro sessions, mood-aware soundscapes, and session tracking. Everything runs offline with no cloud dependencies.

Team Members
Zach Archer — Data layer, session logic, blueprints, AI engine, state management
Malcolm Bright — Home screen, soundscape screen, performance screen, settings screen, dark mode

Features
Session Setup: Choose your mood, task type, energy level, and session duration before every focus session. Load a saved blueprint to skip setup entirely.
AI Focus DJ: Rule-based suggestion engine that recommends a soundscape mix based on your mood, task type, and energy level. Explains why each mix was suggested and applies it in one tap.
Pomodoro Timer: 25 minute work sessions followed by 5 minute breaks. Pause and resume at any point. Automatically prompts for break or session end when the timer completes.
Distraction Logging: Log distractions during a session with a note. Each distraction reduces your focus score by 5 points and is recorded to the database.
Blueprints: Save frequently used session configurations as named blueprints. Load any blueprint from the session setup screen to populate all fields instantly.
Soundscape Mixer: Five independent audio channels including rain, lo-fi beats, white noise, cafe ambience, and nature sounds. Save any mix as a named audio preset.
Session History: View all past sessions with mood, task type, focus score, completed pomodoros, and date recorded.
Performance Screen: Review productivity trends across past sessions.
Dark Mode: Toggle between light and dark theme from the settings screen. Preference persists across app restarts.

Technologies Used
Flutter 3.11
Dart 3.10+
sqflite 2.3.0 — SQLite database
path_provider 2.1.2 — Database file path resolution
shared_preferences 2.2.2 — Theme preference persistence
provider 6.1.2 — State management
audioplayers 6.0.0 — Soundscape audio playback
uuid 4.3.3 — Unique identifier generation
intl 0.19.0 — Date formatting

Installation Instructions
Step 1 — Clone the repository
git clone https://github.com/mbright0/U12-MAD-Project01.git
cd U12-MAD-Project01/soundscapes
Step 2 — Install dependencies
flutter pub get
Step 3 — Connect an Android device or start an Android emulator
Step 4 — Run the app
flutter run
Step 5 — To build a release APK
flutter build apk --release
The APK will be located at build/app/outputs/flutter-apk/app-release.apk

Usage Guide
Starting a Session — Tap the Sessions tab in the bottom navigation bar. Tap New Session to open the setup screen. Select your mood and task type using the choice chips. Adjust your energy level and session duration using the sliders. Optionally tap Load a Blueprint to populate all fields from a saved configuration. Review the AI Focus DJ suggestion and tap Apply This Mix if you want to use the recommended soundscape. Tap Start Session to launch the Pomodoro timer.
During a Session — The timer counts down from your selected duration. Tap the pause button to pause and the play button to resume. Tap the warning button to log a distraction and note what pulled your attention away. Tap the stop button to end the session early. When the timer reaches zero a dialog will prompt you to start your break or end the session. All session data is saved to SQLite when you end the session.
Blueprints — From the session setup screen tap Blueprints in the top right to open the blueprints screen. Tap the plus button to create a new blueprint by entering a name and selecting your preferred configuration. Tap Load a Blueprint on the setup screen to open a list of saved blueprints and tap any one to load it.
Soundscape — Navigate to the Sessions tab and access the soundscape controls to adjust individual channel volumes. Tap Save Preset to store your current mix under a name for future use.
Dark Mode — Open the Settings tab and toggle dark mode on or off. The preference is saved automatically.

Database Schema
Sessions Table
ColumnTypeDescriptionidINTEGERPrimary key, auto incrementmoodTEXTUser's selected moodtask_typeTEXTType of work being doneenergy_levelINTEGEREnergy rating from 1 to 5duration_minutesINTEGERPlanned session lengthcompleted_pomodorosINTEGERNumber of Pomodoros finisheddistraction_countINTEGERTotal distractions loggedfocus_scoreINTEGERFinal focus score out of 100audio_preset_nameTEXTName of soundscape preset usedblueprint_nameTEXTName of blueprint used if anycreated_atTEXTISO 8601 timestamp
Blueprints Table
ColumnTypeDescriptionidINTEGERPrimary key, auto incrementnameTEXTUser-defined blueprint namemoodTEXTSaved mood selectiontask_typeTEXTSaved task typeenergy_levelINTEGERSaved energy levelduration_minutesINTEGERSaved session durationaudio_preset_nameTEXTAssociated audio presetcreated_atTEXTISO 8601 timestamp
Audio Presets Table
ColumnTypeDescriptionidINTEGERPrimary key, auto incrementnameTEXTUser-defined preset namerain_volumeREALRain channel volume 0.0 to 1.0lofi_volumeREALLo-fi channel volume 0.0 to 1.0white_noise_volumeREALWhite noise volume 0.0 to 1.0cafe_volumeREALCafe ambience volume 0.0 to 1.0nature_volumeREALNature sounds volume 0.0 to 1.0created_atTEXTISO 8601 timestamp
Distraction Logs Table
ColumnTypeDescriptionidINTEGERPrimary key, auto incrementsession_idINTEGERForeign key referencing sessionsnoteTEXTDescription of the distractionlogged_atTEXTISO 8601 timestamp

Known Issues
Audio playback requires bundled audio files in the assets/audio directory. The current build includes the asset folder structure but no audio files, so volume sliders function correctly in terms of state but do not produce sound output.
Distraction logs are tied to a session ID that is generated at session end. Individual log entries are counted and scored during the session but full per-session log retrieval requires the session to be saved first.

Future Enhancements
Bundle royalty-free ambient audio files for all five soundscape channels
Implement the history screen with advanced search and filtering by mood, task type, and date range
Add data visualization charts to the performance screen showing focus score trends over time
Add local push notifications for timer completion when the app is in the background
Explore biometric authentication for app entry

License
MIT License. See LICENSE file for details.
