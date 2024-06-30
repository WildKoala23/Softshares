import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart';

class SQLHelper {
  // Singleton instance
  static final SQLHelper instance = SQLHelper._init();

  // Private constructor
  SQLHelper._init();

  // Database instance
  static sql.Database? _database;

  // Getter for database instance
  Future<sql.Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('softsharesDB.db');
    return _database!;
  }

  // Initialize the database
  Future<sql.Database> _initDB(String filePath) async {
    String path = join(await sql.getDatabasesPath(), filePath);
    return await sql.openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  // Create tables
  Future _createDB(sql.Database db, int version) async {
    const sqlText = """
      CREATE TABLE cities(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        city NVARCHAR(100) NOT NULL
      )
    """;
    await db.execute(sqlText);
    await _insertCities(db);
  }

  // Insert initial cities
  Future<void> _insertCities(sql.Database db) async {
    List<Map<String, dynamic>> cities = [
      {'city': 'Tomar'},
      {'city': 'Viseu'},
      {'city': 'Fundão'},
      {'city': 'Portoalegre'},
      {'city': 'Vilareal'},
    ];

    for (var city in cities) {
      await db.insert('cities', city,
          conflictAlgorithm: sql.ConflictAlgorithm.ignore);
    }
  }

  // Check table contents
  Future<void> checkTable() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> result = await db.query('cities');
    print('Cities table contents: $result');
  }

  // Get city by id
  Future<List<Map<String, dynamic>>> getCity(int id) async {
    final db = await instance.database;
    return await db.query('cities', where: 'id = ?', whereArgs: [id]);
  }

  // Update city by id
  Future<int> updateCity(int id, String city) async {
    final db = await instance.database;
    final data = {'city': city};
    return await db.update('cities', data, where: 'id = ?', whereArgs: [id]);
  }

  Future<String?> getCityName(int id) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> result = await db.query('cities',
        columns: ['city'], where: 'id = ?', whereArgs: [id]);
    if (result.isNotEmpty) {
      return result.first['city'] as String?;
    }
    return null;
  }
}
