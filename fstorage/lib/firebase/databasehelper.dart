import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  static late Database _database;
  static String? _databasePath;

  DatabaseHelper._internal() {
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'tbase.db');
    _databasePath = path; // Guardar la ruta de la base de datos

    if (await _databaseExists(path)) {
      _database = await openDatabase(path);
    } else {
      _database = await openDatabase(
        path,
        version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
            CREATE TABLE your_table_name (
              id INTEGER PRIMARY KEY,
            )
          ''');
        },
      );
    }
  }

  static Future<String> getDatabasePath() async {
    String databasesPath = await getDatabasesPath();
    return join(databasesPath, 'tbase.db');
  }

  Future<bool> _databaseExists(String path) async {
    return File(path).exists();
  }

  Future<Database> get database async {
    await _initDatabase();
    return _database;
  }

  static String get databasePath => _databasePath ?? '';
}
