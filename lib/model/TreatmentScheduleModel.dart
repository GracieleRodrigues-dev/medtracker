class TreatmentSchedule {
  int? id;
  int treatmentId; // Chave estrangeira para o tratamento
  DateTime scheduledTime; // Horário programado
  bool isTaken; // Status da dose
  DateTime? takenTime; //horario quando o usuário tomou medicamento
  int doseAmount; // Quantidade da dose

  TreatmentSchedule({
    this.id,
    required this.treatmentId,
    required this.scheduledTime,
    this.isTaken = false,
    this.takenTime,
    required this.doseAmount,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'treatmentId': treatmentId,
      'scheduledTime': scheduledTime.toIso8601String(),
      'isTaken': isTaken ? 1 : 0,
      'takenTime': takenTime?.toIso8601String(),
      'doseAmount': doseAmount,
    };
  }

  factory TreatmentSchedule.fromMap(Map<String, dynamic> map) {
    return TreatmentSchedule(
      id: map['id'],
      treatmentId: map['treatmentId'],
      scheduledTime: DateTime.parse(map['scheduledTime']),
      isTaken: map['isTaken'] == 1,
      takenTime: map['takenTime'] != null ? DateTime.parse(map['takenTime']) : null,
      doseAmount: map['doseAmount'],
    );
  }
}
