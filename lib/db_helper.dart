import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';

class DBHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  static Future<Database> _initDB() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path, 'sudoku.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE game_state (
            id INTEGER PRIMARY KEY,
            puzzle TEXT,
            solution TEXT,
            userEntered TEXT
          )
        ''');
      },
    );
  }

  static Future<void> saveGame({
    required List<List<int>> puzzle,
    required List<List<int>> solution,
    required List<List<bool>> userEntered,
  }) async {
    final db = await database;
    await db.insert(
      'game_state',
      {
        'id': 1,
        'puzzle': jsonEncode(puzzle),
        'solution': jsonEncode(solution),
        'userEntered': jsonEncode(userEntered),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<Map<String, dynamic>?> loadGame() async {
    final db = await database;
    final result = await db.query('game_state', where: 'id = ?', whereArgs: [1]);
    return result.isNotEmpty ? result.first : null;
  }

  static Future<void> clearGame() async {
    final db = await database;
    await db.delete('game_state');
  }
}