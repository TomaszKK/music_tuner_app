import 'dart:convert';  // Add this for JSON encoding/decoding
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'app_data.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Create tables
        await db.execute('''
          CREATE TABLE settings(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            selected_instrument TEXT,
            is_note_changed INTEGER,
            is_reset_visible TEXT  -- Store the map as a JSON string
          )
        ''');
      },
    );
  }

  // Insert or Update Settings
  Future<void> insertOrUpdateSettings(String instrument, bool isNoteChanged, Map<String, bool> isResetVisible) async {
    final db = await database;

    // Convert the isResetVisible map to JSON string
    String isResetVisibleJson = jsonEncode(isResetVisible);

    await db.insert(
      'settings',
      {
        'selected_instrument': instrument,
        'is_note_changed': isNoteChanged ? 1 : 0,
        'is_reset_visible': isResetVisibleJson
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get Settings
  Future<Map<String, dynamic>?> getSettings() async {
    final db = await database;
    final result = await db.query('settings', limit: 1);

    if (result.isNotEmpty) {
      Map<String, dynamic> settings = result.first;
      settings['is_reset_visible'] = jsonDecode(settings['is_reset_visible']);add
      return settings;
    }
    return null;
  }

  // Clear Settings (for resetting)
  Future<void> clearSettings() async {
    final db = await database;
    await db.delete('settings');
  }
}
