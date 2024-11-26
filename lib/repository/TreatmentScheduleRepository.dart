import 'package:sqflite/sqflite.dart';
import '../model/TreatmentScheduleModel.dart';
import 'DAO.dart';

class TreatmentScheduleRepository {
  final DAO _db = DAO();

  // Inserir novo agendamento
  Future<int> insert(TreatmentSchedule schedule) async {
    final db = await _db.database;
    return await db.insert(
      'schedules',
      schedule.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Obter todos os agendamentos
  Future<List<TreatmentSchedule>> getAll() async {
    final db = await _db.database;
    final List<Map<String, dynamic>> maps = await db.query('schedules');

    return List.generate(maps.length, (i) {
      return TreatmentSchedule.fromMap(maps[i]);
    });
  }

  // Obter agendamento pelo ID
  Future<TreatmentSchedule?> getById(int id) async {
    final db = await _db.database;
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

  // Obter agendamentos com filtros opcionais
  Future<List<Map<String, dynamic>>> getSchedules({
    bool? isTaken,
    DateTime? scheduledTime,
  }) async {
    final db = await _db.database;

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
    return result; // Retorna a lista de mapas com o campo treatmentName
  }

  // Atualizar agendamento
  Future<int> update(TreatmentSchedule schedule) async {
    final db = await _db.database;
    return await db.update(
      'schedules',
      schedule.toMap(),
      where: 'id = ?',
      whereArgs: [schedule.id],
    );
  }

  // Excluir agendamento
  Future<int> delete(int id) async {
    final db = await _db.database;
    return await db.delete(
      'schedules',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
