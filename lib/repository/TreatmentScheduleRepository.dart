import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

import '../model/TreatmentScheduleModel.dart';

class TreatmentScheduleRepository {
  static final TreatmentScheduleRepository _instance =
  TreatmentScheduleRepository._internal();

  factory TreatmentScheduleRepository() => _instance;

  static Database? _database;

  TreatmentScheduleRepository._internal();

  Future<Database> get _db async {
    if (_database != null) {
      return _database!;
    } else {
      String path = join(await getDatabasesPath(), 'treatment_schedule.db');
      _database = await openDatabase(
        path,
        onCreate: (db, version) {
          // Criação das tabelas
          return db.execute('''
            CREATE TABLE schedules(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              treatmentId INTEGER,
              scheduledTime DATETIME,
              doseAmount INTEGER,
              isTaken INTEGER,
              takenTime TEXT,
              FOREIGN KEY (treatmentId) REFERENCES treatments(id)
            );
          ''');
        },
        version: 1,
      );
      return _database!;
    }
  }

  Future<List<Map<String, dynamic>>> getSchedules({bool? isTaken, DateTime? scheduledTime}) async {
    final db = await _db;

    String whereClause = '';
    List<dynamic> whereArgs = [];

    if (isTaken != null) {
      whereClause = 'schedules.isTaken = ?';
      whereArgs.add(isTaken ? 1 : 0);
    }

    if (scheduledTime != null) {
      if (whereClause.isNotEmpty) whereClause += ' AND ';
      whereClause += 'date(schedules.scheduledTime) = ?';
      whereArgs.add(scheduledTime.toIso8601String().split('T').first);
    }

    final List<Map<String, dynamic>> result = await db.rawQuery('''
    SELECT 
      schedules.*, 
      treatments.name AS treatmentName
    FROM schedules 
    INNER JOIN treatments 
    ON schedules.treatmentId = treatments.id
    ${whereClause.isNotEmpty ? 'WHERE $whereClause' : ''}
    ORDER BY datetime(schedules.scheduledTime) ASC
  ''', whereArgs);

    return result;  // Retorna a lista de mapas com o campo treatmentName
  }


  Future<int> insert(TreatmentSchedule schedule) async {
    final db = await _db;
    return await db.insert(
      'schedules',
      schedule.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<TreatmentSchedule>> getAll() async {
    final db = await _db;
    final List<Map<String, dynamic>> maps = await db.query('schedules');

    return List.generate(maps.length, (i) {
      return TreatmentSchedule.fromMap(maps[i]);
    });
  }

  Future<TreatmentSchedule?> getById(int id) async {
    final db = await _db;
    final List<Map<String, dynamic>> maps = await db.query(
      'schedules',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return TreatmentSchedule.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> update(TreatmentSchedule schedule) async {
    final db = await _db;
    return await db.update(
      'schedules',
      schedule.toMap(),
      where: 'id = ?',
      whereArgs: [schedule.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await _db;
    return await db.delete(
      'schedules',
      where: 'id = ?',
      whereArgs: [id],
    );
  }




  Future<void> close() async {
    final db = await _db;
    await db.close();
  }
}
