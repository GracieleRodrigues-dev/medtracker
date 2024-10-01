import '../model/TreatmentModel.dart';
import '../repository/TreatmentRepository.dart';
import '../observer/observer.dart';
import '../observer/viewmodel.dart';

class TreatmentViewModel extends EventViewModel {
  final TreatmentRepository _repository;
  TreatmentViewModel(this._repository);

  void loadTreatments() {
    notify(LoadingEvent(isLoading: true));
    _repository.loadTreatments().then((value) {
      notify(TreatmentLoadedEvent(treatments: value));
      notify(LoadingEvent(isLoading: false));
    });
  }
}

class LoadingEvent extends ViewEvent {
  bool isLoading;
  LoadingEvent({required this.isLoading}) : super("LoadingEvent");
}

class TreatmentLoadedEvent extends ViewEvent {
  final List<Treatment> treatments;
  TreatmentLoadedEvent({required this.treatments}) : super("TreatmentsLoadedEvent");
}

class TreatmentCreatedEvent extends ViewEvent {
  final Treatment treatment;
  TreatmentCreatedEvent(this.treatment) : super("TreatmentCreatedEvent");
}