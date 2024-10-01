class Treatment {
  int id;
  String name;
  String dosage;
  String form; // comprimido, líquido, etc.
  String specialInstructions;
  DateTime startDate;
  DateTime endDate;
  List<String> times; // Horários para as doses

  Treatment({
    required this.id,
    required this.name,
    required this.dosage,
    required this.form,
    required this.specialInstructions,
    required this.startDate,
    required this.endDate,
    required this.times,
  });
}
