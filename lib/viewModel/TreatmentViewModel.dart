import '../model/TreatmentModel.dart';
import '../repository/TreatmentRepository.dart';
import '../observer/observer.dart';
import '../observer/viewmodel.dart';

class TreatmentViewModel extends EventViewModel {
  static final TreatmentViewModel _instance =
  TreatmentViewModel._internal(TreatmentRepository());

  factory TreatmentViewModel() {
    return _instance;
  }

  TreatmentViewModel._internal(this._repository);
  final TreatmentRepository _repository;

  loadTreatments() {
    notify(LoadingEvent(isLoading: true));
    _repository.getAllTreatments().then((value) {
      notify(TreatmentLoadedEvent(treatments: value));
      notify(LoadingEvent(isLoading: false));
    });
  }

  Future<int> saveTreatment(Map<String, dynamic> treatmentData) async {
    final treatment = Treatment(
      name: treatmentData['name'],
      form: treatmentData['form'],
      startDate: treatmentData['startDate'],
      endDate: treatmentData['endDate'],
      reminderType: treatmentData['reminderType'],
      frequencyPerDay: treatmentData['frequencyPerDay'],
      specificDays: treatmentData['specificDays'],
      intervalType: treatmentData['intervalType'],
      intervalValue: treatmentData['intervalValue'],
      startTime: treatmentData['startTime']
    );

    final int id = await _repository.insertTreatment(treatment);
    print('Tratamento salvo: ${treatment.toMap()}');
    notify(TreatmentCreatedEvent(treatment));
    loadTreatments();
    return id;
  }

  void deleteTreatment(int? id) {
    if (id == null) return;
    _repository.deleteTreatment(id).then((_) {
      _repository.getAllTreatments().then((treatments) {
        print('Tratamento deletado: ID = $id');
        notify(TreatmentDeletedEvent(id));
        notify(TreatmentLoadedEvent(treatments: treatments));
      });
    });
  }
}

class LoadingEvent extends ViewEvent {
  bool isLoading;
  LoadingEvent({required this.isLoading}) : super("LoadingEvent");
}

class TreatmentLoadedEvent extends ViewEvent {
  final List<Treatment> treatments;
  TreatmentLoadedEvent({required this.treatments})
      : super("TreatmentsLoadedEvent");
}

class TreatmentCreatedEvent extends ViewEvent {
  final Treatment treatment;
  TreatmentCreatedEvent(this.treatment) : super("TreatmentCreatedEvent");
}
class TreatmentDeletedEvent extends ViewEvent {
  final int id;
  TreatmentDeletedEvent(this.id) : super("TreatmentDeletedEvent");
}