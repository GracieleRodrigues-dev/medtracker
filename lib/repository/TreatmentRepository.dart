import '../model/TreatmentModel.dart';

class TreatmentRepository {
  final List<Treatment> _treatments = [
    Treatment(
        id: 0,
        name: "First treatment",
        dosage: "1",
        form: "pills",
        specialInstructions: "teste",
        startDate: DateTime.now(),
        endDate: DateTime.now(),
        times:["1"])
  ];

  // Adiciona novo tratamento
  void addTreatment(Treatment treatment) {
    treatment.id = _treatments.length;
    _treatments.add(treatment);
  }

  // Remove tratamento
  void removeTreatment(Treatment treatment) {
    _treatments.remove(treatment);
  }

  Future<List<Treatment>> loadTreatments() async {
    // Simulate a http request
    await Future.delayed(const Duration(seconds: 2));
    return Future.value(_treatments);
  }

  // Atualiza tratamento
  void updateTreatment(Treatment treatment, int index) {
    _treatments[index] = treatment;
  }
}
