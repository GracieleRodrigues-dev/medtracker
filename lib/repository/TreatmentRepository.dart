import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

import '../model/TreatmentModel.dart';

class TreatmentRepository {
  static final TreatmentRepository _instance = TreatmentRepository._internal();
  factory TreatmentRepository() => _instance;

  // Conexão com o banco de dados
  static Database? _database;

  // Constructor privado
  TreatmentRepository._internal();

  // Inicialização do banco de dados
  Future<Database> get _db async {
    if (_database != null) {
      return _database!;
    } else {
      // Define o caminho do banco de dados
      String path = join(await getDatabasesPath(), 'treatment_database.db');
      _database = await openDatabase(
        path,
        onCreate: (db, version) {
          return db.execute('''
            CREATE TABLE treatments(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT,
              dosage INTEGER,
              form TEXT,
              startDate TEXT,
              endDate TEXT,
              reminderType TEXT,
              frequencyPerDay INTEGER,
              specificDays TEXT
            );
          ''');
        },
        version: 1,
      );
      return _database!;
    }
  }

  // Inserir novo tratamento
  Future<int> insertTreatment(Treatment treatment) async {
    final db = await _db;
    return await db.insert(
      'treatments',
      treatment.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Obter todos os tratamentos
  Future<List<Treatment>> getAllTreatments() async {
    final db = await _db;
    final List<Map<String, dynamic>> maps = await db.query('treatments');

    return List.generate(maps.length, (i) {
      return Treatment.fromMap(maps[i]);
    });
  }

  // Obter tratamento pelo ID
  Future<Treatment?> getTreatmentById(int id) async {
    final db = await _db;
    final List<Map<String, dynamic>> maps = await db.query(
      'treatments',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Treatment.fromMap(maps.first);
    } else {
      return null;
    }
  }

  // Atualizar tratamento
  Future<int> updateTreatment(Treatment treatment) async {
    final db = await _db;
    return await db.update(
      'treatments',
      treatment.toMap(),
      where: 'id = ?',
      whereArgs: [treatment.id],
    );
  }

  // Excluir tratamento
  Future<int> deleteTreatment(int id) async {
    final db = await _db;
    return await db.delete(
      'treatments',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Fechar o banco de dados
  Future<void> close() async {
    final db = await _db;
    await db.close();
  }
}
