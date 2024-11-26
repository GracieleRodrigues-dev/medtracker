import 'package:sqflite/sqflite.dart';
import '../model/TreatmentModel.dart';
import 'DAO.dart';

class TreatmentRepository {
  final DAO _db = DAO();

  // Inserir novo tratamento
  Future<int> insertTreatment(Treatment treatment) async {
    final db = await _db.database;
    return await db.insert(
      'treatments',
      treatment.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Obter todos os tratamentos
  Future<List<Treatment>> getAllTreatments() async {
    final db = await _db.database;
    final List<Map<String, dynamic>> maps = await db.query('treatments');

    return List.generate(maps.length, (i) {
      return Treatment.fromMap(maps[i]);
    });
  }

  // Obter tratamento pelo ID
  Future<Treatment?> getTreatmentById(int id) async {
    final db = await _db.database;
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
    final db = await _db.database;
    return await db.update(
      'treatments',
      treatment.toMap(),
      where: 'id = ?',
      whereArgs: [treatment.id],
    );
  }

  // Excluir tratamento
  Future<int> deleteTreatment(int id) async {
    final db = await _db.database;
    return await db.delete(
      'treatments',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
