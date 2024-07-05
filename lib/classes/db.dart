import 'dart:async';

import 'package:softshares/Pages/area.dart';
import 'package:softshares/classes/ClasseAPI.dart';
import 'package:softshares/classes/areaClass.dart';
import 'package:softshares/classes/utils.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart';

class SQLHelper {
  // Singleton instance
  static final SQLHelper instance = SQLHelper._init();
  static final API api = API();

  // Private constructor
  SQLHelper._init();

  // Database instance
  static sql.Database? _database;

  // Getter for database instance
  Future<sql.Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('pdm.db');
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
    const createCities = """
      CREATE TABLE cities(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        city NVARCHAR(100) NOT NULL
      )
    """;

    const createAreas = """
      CREATE TABLE areas(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        area NVARCHAR(100) NOT NULL 
      )""";

    const createSubAreas = """
      CREATE TABLE subAreas(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        subArea NVARCHAR(100) NOT NULL,
        areaID INTEGER NOT NULL,
        FOREIGN KEY (areaID) REFERENCES areas(id)
      )""";

    const createPreferences = """
      CREATE TABLE preferences(
        id INTEGER PRIMARY KEY,
        subArea NVARCHAR(100) NOT NULL 
      )""";

    await db.execute(createCities);
    await db.execute(createAreas);
    await db.execute(createSubAreas);
    await db.execute(createPreferences);
    await _insertCities(db);
    await _insertAreas(db);
  }

  // Insert cities
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

  // Insert Areas
  Future<void> _insertAreas(sql.Database db) async {
    List<AreaClass> areas = await api.getAreas();

    for (var area in areas) {
      await db.rawInsert(
        'INSERT INTO areas (id, area) VALUES (?, ?)',
        [area.id, area.areaName],
      );
      for (var subArea in area.subareas!) {
        await db.rawInsert(
          'INSERT INTO subAreas (id, subarea, areaID) VALUES (?, ?, ?)',
          [subArea.id, subArea.areaName, area.id],
        );
      }
    }
  }

  Future<List<AreaClass>> getAreas() async {
    final db = await instance.database;

    List<AreaClass> list = [];
    final List<Map<String, dynamic>> areaMaps = await db.query('areas');
    final List<Map<String, dynamic>> subAreaMaps = await db.query('subAreas');

    for (var area in areaMaps) {
      AreaClass aux = AreaClass(
          id: area['id'], areaName: area['area'], icon: iconMap[area['area']]);
      aux.subareas = [];
      for (var subArea in subAreaMaps) {
        AreaClass subAux =
            AreaClass(id: subArea['id'], areaName: subArea['subArea']);
        if (subArea['areaID'] == area['id']) {
          aux.subareas!.add(subAux);
        }
      }
      list.add(aux);
    }

    return list;
  }

  // Check table contents
  Future<void> checkTable() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> result = await db.query('cities');
    print('Cities table contents: $result');
  }

  // Get all cities
  Future<List<Map<String, dynamic>>> getCities() async {
    final db = await instance.database;
    return await db.query('cities', orderBy: 'city');
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

  Future deletePrefs() async {
    final db = await instance.database;
    await db.execute("""
        DELETE FROM preferences
    """);
  }

  Future insertPreference(List<AreaClass> prefs) async {
    final db = await instance.database;

    await deletePrefs();
    for (var pref in prefs) {
      await db.rawInsert(
        'INSERT INTO preferences (id, subarea) VALUES (?, ?)',
        [pref.id, pref.areaName],
      );
    }
  }

  Future<List<AreaClass>> getPrefs() async {
    final db = await instance.database;
    List<AreaClass> prefs = [];
    final List<Map<String, dynamic>> prefsMap = await db.query('preferences');

    for (var pref in prefsMap) {
      AreaClass aux = AreaClass(id: pref['id'], areaName: pref['subArea']);

      prefs.add(aux);
    }

    return prefs;
  }
}
