import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../models/session.dart';
import '../../models/blueprint.dart';
import '../../models/audio_preset.dart';
import '../../models/distraction_log.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('focus_studio.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE sessions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        mood TEXT NOT NULL,
        task_type TEXT NOT NULL,
        energy_level INTEGER NOT NULL,
        duration_minutes INTEGER NOT NULL,
        completed_pomodoros INTEGER NOT NULL,
        distraction_count INTEGER NOT NULL,
        focus_score INTEGER NOT NULL,
        audio_preset_name TEXT NOT NULL,
        blueprint_name TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE blueprints (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        mood TEXT NOT NULL,
        task_type TEXT NOT NULL,
        energy_level INTEGER NOT NULL,
        duration_minutes INTEGER NOT NULL,
        audio_preset_name TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE audio_presets (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        rain_volume REAL NOT NULL,
        lofi_volume REAL NOT NULL,
        white_noise_volume REAL NOT NULL,
        cafe_volume REAL NOT NULL,
        nature_volume REAL NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE distraction_logs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        session_id INTEGER NOT NULL,
        note TEXT NOT NULL,
        logged_at TEXT NOT NULL,
        FOREIGN KEY (session_id) REFERENCES sessions (id)
      )
    ''');
  }

  // Sessions
  // ── Sessions ──────────────────────────────────────────────

  Future<int> insertSession(Session session) async {
    final db = await database;
    return await db.insert('sessions', session.toMap());
  }

  Future<List<Session>> getAllSessions() async {
    final db = await database;
    final result = await db.query('sessions', orderBy: 'created_at DESC');
    return result.map((map) => Session.fromMap(map)).toList();
  }

  Future<List<Session>> searchSessions(String query) async {
    final db = await database;
    final result = await db.query(
      'sessions',
      where: 'mood LIKE ? OR task_type LIKE ? OR audio_preset_name LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
      orderBy: 'created_at DESC',
    );
    return result.map((map) => Session.fromMap(map)).toList();
  }

  Future<int> deleteSession(int id) async {
    final db = await database;
    return await db.delete('sessions', where: 'id = ?', whereArgs: [id]);
  }

  // Blueprints

  Future<int> insertBlueprint(Blueprint blueprint) async {
    final db = await database;
    return await db.insert('blueprints', blueprint.toMap());
  }

  Future<List<Blueprint>> getAllBlueprints() async {
    final db = await database;
    final result = await db.query('blueprints', orderBy: 'created_at DESC');
    return result.map((map) => Blueprint.fromMap(map)).toList();
  }

  Future<int> deleteBlueprint(int id) async {
    final db = await database;
    return await db.delete('blueprints', where: 'id = ?', whereArgs: [id]);
  }

  // Audio Presets
  Future<int> insertAudioPreset(AudioPreset preset) async {
    final db = await database;
    return await db.insert('audio_presets', preset.toMap());
  }

  Future<List<AudioPreset>> getAllAudioPresets() async {
    final db = await database;
    final result = await db.query('audio_presets', orderBy: 'created_at DESC');
    return result.map((map) => AudioPreset.fromMap(map)).toList();
  }

  Future<int> updateAudioPreset(AudioPreset preset) async {
    final db = await database;
    return await db.update(
      'audio_presets',
      preset.toMap(),
      where: 'id = ?',
      whereArgs: [preset.id],
    );
  }

  Future<int> deleteAudioPreset(int id) async {
    final db = await database;
    return await db.delete('audio_presets', where: 'id = ?', whereArgs: [id]);
  }

  // Distraction Logs

  Future<int> insertDistractionLog(DistractionLog log) async {
    final db = await database;
    return await db.insert('distraction_logs', log.toMap());
  }

  Future<List<DistractionLog>> getLogsForSession(int sessionId) async {
    final db = await database;
    final result = await db.query(
      'distraction_logs',
      where: 'session_id = ?',
      whereArgs: [sessionId],
      orderBy: 'logged_at ASC',
    );
    return result.map((map) => DistractionLog.fromMap(map)).toList();
  }

  // Close 

  Future close() async {
    final db = await database;
    db.close();
  }
}
}
