class Treatment {
  int? id;
  String name;
  String form;
  DateTime startDate;
  DateTime endDate;
  String reminderType; // 'Interval', 'MultiplesTimes', 'SpecificDays'
  int frequencyPerDay; // Frequência em caso de lembrete "Interval" ou "MultiplesTimes"
  List<int>? specificDays; // Lista de índices dos dias selecionados (0 para domingo, 6 para sábado)

  Treatment({
    this.id,
    required this.name,
    required this.form,
    required this.startDate,
    required this.endDate,
    required this.reminderType,
    required this.frequencyPerDay,
    this.specificDays,
  });

  // Converter para um Map para utilizarmos no banco
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'form': form,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'reminderType': reminderType,
      'frequencyPerDay': frequencyPerDay,
      'specificDays': specificDays != null ? specificDays!.join(',') : null,
    };
  }

  // Treatment a partir de um Map (vindo do banco)
  factory Treatment.fromMap(Map<String, dynamic> map) {
    return Treatment(
      id: map['id'],
      name: map['name'],
      form: map['form'],
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
      reminderType: map['reminderType'],
      frequencyPerDay: map['frequencyPerDay'],
      specificDays: map['specificDays'] != null
          ? (map['specificDays'] as String).split(',').map((e) => int.parse(e)).toList()
          : null,
    );
  }
}
