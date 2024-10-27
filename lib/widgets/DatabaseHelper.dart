import 'dart:convert';  // Add this for JSON encoding/decoding
import 'package:path_provider/path_provider.dart';
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

  Future<void> clearDatabase() async {
    var directory = await getApplicationDocumentsDirectory();
    var path = '${directory.path}/settings.db';
    final db = await openDatabase(path);
    await db.close(); // Close the database first
    await deleteDatabase(path); // Then delete the database
  }

  Future<Database> _initDatabase() async {
    var directory = await getApplicationDocumentsDirectory();
    var path = '${directory.path}/settings.db';

    return await openDatabase(
      path,
      version: 3,  // Increment the version to trigger migration
      onCreate: (db, version) async {
        // Create tables
        await db.execute(''' 
      CREATE TABLE settings(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        selected_instrument TEXT,
        is_note_changed INTEGER,
        is_reset_visible TEXT,
        transposition_notifier TEXT,
        instrument_notes TEXT,
        manual_notes TEXT,
        device_id TEXT
      )
      ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // Add the missing columns
          await db.execute(''' 
        ALTER TABLE settings ADD COLUMN instrument_notes TEXT;
        ''');
          await db.execute(''' 
        ALTER TABLE settings ADD COLUMN manual_notes TEXT; 
        ''');
        }
        if (oldVersion < 3) {
          await db.execute(''' 
          ALTER TABLE settings ADD COLUMN device_id TEXT; 
        ''');
        }
      },
    );
  }

  // Insert or Update Settings
  Future<void> insertOrUpdateSettings(String instrument, bool isNoteChanged, Map<String, bool> isResetVisible) async {
    final db = await database;

    // Convert the isResetVisible map to JSON string
    String isResetVisibleJson = jsonEncode(isResetVisible);

    // Check if a row already exists
    var existingRows = await db.query('settings');
    if (existingRows.isNotEmpty) {
      // If settings exist, update the row
      await db.update(
        'settings',
        {
          'selected_instrument': instrument,
          'is_note_changed': isNoteChanged ? 1 : 0,
          'is_reset_visible': isResetVisibleJson
        },
      );
    } else {
      // Insert new row if no settings exist
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

    print('Settings saved');
  }

  Future<void> insertOrUpdateInstrumentsSettings(Map<String, int> transpositionNotify, Map<String, List<String>> instrumentNotesMap, Map<String, List<String>> manualNotesMap) async {
    final db = await database;

    // Convert the transpositionNotify map to JSON string
    String transpositionNotifyJson = jsonEncode(transpositionNotify);
    String instrumentNotesJson = jsonEncode(instrumentNotesMap);
    String manualNotesJson = jsonEncode(manualNotesMap);

    // Check if a row already exists
    var existingRows = await db.query('settings');
    if (existingRows.isNotEmpty) {
      // If settings exist, update only the transposition_notifier field
      await db.update(
        'settings',
        {
          'transposition_notifier': transpositionNotifyJson,
          'instrument_notes': instrumentNotesJson,
          'manual_notes': manualNotesJson
        },
        where: 'id = ?',  // Specify where clause to update the correct row
        whereArgs: [existingRows.first['id']],  // Use the id from the first row
      );
    } else {
      // Insert new row if no settings exist
      await db.insert(
        'settings',
        {
          'transposition_notifier': transpositionNotifyJson,
          'instrument_notes': instrumentNotesJson,
          'manual_notes': manualNotesJson
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    print('Transposition settings saved');
  }

  Future<void> insertOrUpdateBLE(String deviceId) async {
    final db = await database;

    // Check if a row already exists
    var existingRows = await db.query('settings');
    if (existingRows.isNotEmpty) {
      // If settings exist, update the row
      await db.update(
        'settings',
        {
          'device_id': deviceId,
        },
      );
    } else {
      // Insert new row if no settings exist
      await db.insert(
        'settings',
        {
          'device_id': deviceId,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    print('Settings saved');
  }

  Future<void> insertOrUpdateAll(Map<String, int> transpositionNotify, Map<String, List<String>> instrumentNotesMap, Map<String, List<String>> manualNotesMap, bool isNoteChanged, Map<String, bool> isResetVisible, String deviceId) async {
    final db = await database;

    String transpositionNotifyJson = jsonEncode(transpositionNotify);
    String instrumentNotesJson = jsonEncode(instrumentNotesMap);
    String manualNotesJson = jsonEncode(manualNotesMap);
    String isResetVisibleJson = jsonEncode(isResetVisible);

    // Check if a row already exists
    var existingRows = await db.query('settings');
    if (existingRows.isNotEmpty) {
      // If settings exist, update the row
      await db.update(
        'settings',
        {
          'is_note_changed': isNoteChanged ? 1 : 0,
          'is_reset_visible': isResetVisibleJson,
          'transposition_notifier': transpositionNotifyJson,
          'instrument_notes': instrumentNotesJson,
          'manual_notes': manualNotesJson,
          'device_id': deviceId
        },
      );
    } else {
      // Insert new row if no settings exist
      await db.insert(
        'settings',
        {
          'is_note_changed': isNoteChanged ? 1 : 0,
          'is_reset_visible': isResetVisibleJson,
          'transposition_notifier': transpositionNotifyJson,
          'instrument_notes': instrumentNotesJson,
          'manual_notes': manualNotesJson,
          'device_id': deviceId
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    print('Reset all settings');
  }

  // Get Settings
  Future<Map<dynamic, dynamic>?> getSettings() async {
    final db = await database;
    final result = await db.query('settings');

    if (result.isNotEmpty) {
      Map<dynamic, dynamic> settings = result.first;
      return settings;
    }
    return null;
  }
}
