import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class DAO {
  static final DAO _instance = DAO._internal();

  factory DAO() => _instance;

  static Database? _database;

  DAO._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;

    String path = join(await getDatabasesPath(), 'treatment_app.db');
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
            CREATE TABLE treatments(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT,
              dosage INTEGER,
              form TEXT,
              startDate DATETIME,
              endDate DATETIME,
              reminderType TEXT,
              frequencyPerDay INTEGER,
              specificDays TEXT,
              intervalType TEXT,
              intervalValue INTEGER,  
              startTime TEXT     
        );''');
        await db.execute('''
          CREATE TABLE schedules(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            treatmentId INTEGER,
            scheduledTime DATETIME,
            doseAmount INTEGER,
            isTaken INTEGER,
            takenTime DATETIME,
            FOREIGN KEY (treatmentId) REFERENCES treatments(id)
          );
        ''');
      },
    );
    return _database!;
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
