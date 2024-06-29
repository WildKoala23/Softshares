import 'package:sqflite/sqflite.dart' as sql;
import 'package:flutter/foundation.dart';

class SQLHelper {
  static Future<void> createTable(sql.Database database) async {
    await database.execute("""CREATE TABLE cities(
    OFFICE_ID           INT                 NOT NULL,
    CITY                NVARCHAR(100)        NOT NULL
    )""");
    //ALTER WITH USER CITY
    await database.execute("""INSERT INTO cities(OFFICE_ID, CITY) 
              VALUES (1, 'TOMAR'), (2, 'VISEU'), (3, 'FUNDAO'), (4, 'PORTALEGRE'), (5, 'VILA REAL')""");
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase('cities.db', version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTable(database);
    });
  }

  static Future<List<Map<String, dynamic>>> getCity(int id) async {
    final db = await SQLHelper.db();
    return db.query('cities',where: 'OFFICE_ID = ?', whereArgs: [id]);
  }

  static Future<int> updateCity(int id, String city) async {
    final db = await SQLHelper.db();

    final data = {
      "CITY": city,
    };

    final result =
        await db.update('items', data, where: 'OFFICE_ID = ?', whereArgs: [id]);
    return result;
  }
}
