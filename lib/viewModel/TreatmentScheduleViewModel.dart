import '../model/TreatmentScheduleModel.dart';
import '../repository/TreatmentScheduleRepository.dart';
import '../observer/observer.dart';
import '../observer/viewmodel.dart';

class TreatmentScheduleViewModel extends EventViewModel {
  final TreatmentScheduleRepository _repository;

  TreatmentScheduleViewModel(this._repository);

  void loadSchedules({bool? isTaken, DateTime? scheduledTime}) {
    notify(LoadingEvent(isLoading: true)); // Notifica que está carregando

    _repository.getSchedules(isTaken: isTaken, scheduledTime: scheduledTime).then((schedules) {
      if (isTaken != null) {
        if (isTaken) {
          notify(TakenSchedulesLoadedEvent(schedules: schedules));
        } else {
          notify(PendingSchedulesLoadedEvent(schedules: schedules));
        }
      } else {
        notify(SchedulesLoadedEvent(schedules: schedules));
      }
      notify(LoadingEvent(isLoading: false));
    });
  }

  void saveSchedule(Map<String, dynamic> scheduleData) {
    final schedule = TreatmentSchedule(
      treatmentId: scheduleData['treatmentId'],
      scheduledTime: scheduleData['scheduledTime'],
      doseAmount: scheduleData['doseAmount'],
      isTaken: scheduleData['isTaken'] ?? false,
      takenTime: scheduleData['takenTime'],
    );

    _repository.insert(schedule).then((id) {
      notify(ScheduleCreatedEvent(schedule));
    });
  }

  void updateSchedule(Map<String, dynamic> updatedData) {
    final schedule = TreatmentSchedule(
      id: updatedData['id'],
      treatmentId: updatedData['treatmentId'],
      scheduledTime: updatedData['scheduledTime'],
      doseAmount: updatedData['doseAmount'],
      isTaken: updatedData['isTaken'] ?? false,
      takenTime: updatedData['takenTime'],
    );

    _repository.update(schedule).then((rowsAffected) {
      if (rowsAffected > 0) {
        notify(ScheduleUpdatedEvent(schedule));
      }
    });
  }

  void deleteSchedule(int id) {
    _repository.delete(id).then((rowsAffected) {
      if (rowsAffected > 0) {
        notify(ScheduleDeletedEvent(id));
      }
    });
  }
}

class LoadingEvent extends ViewEvent {
  final bool isLoading;
  LoadingEvent({required this.isLoading}) : super("LoadingEvent");
}

class SchedulesLoadedEvent extends ViewEvent {
  final List<Map<String, dynamic>> schedules;
  SchedulesLoadedEvent({required this.schedules}) : super("SchedulesLoadedEvent");
}

class ScheduleCreatedEvent extends ViewEvent {
  final TreatmentSchedule schedule;
  ScheduleCreatedEvent(this.schedule) : super("ScheduleCreatedEvent");
}

class ScheduleUpdatedEvent extends ViewEvent {
  final TreatmentSchedule schedule;
  ScheduleUpdatedEvent(this.schedule) : super("ScheduleUpdatedEvent");
}

class ScheduleDeletedEvent extends ViewEvent {
  final int id;
  ScheduleDeletedEvent(this.id) : super("ScheduleDeletedEvent");
}

class PendingSchedulesLoadedEvent extends ViewEvent {
  final List<Map<String, dynamic>> schedules;
  PendingSchedulesLoadedEvent({required this.schedules}) : super("PendingSchedulesLoadedEvent");
}

class TakenSchedulesLoadedEvent extends ViewEvent {
  final List<Map<String, dynamic>> schedules;
  TakenSchedulesLoadedEvent({required this.schedules}) : super("TakenSchedulesLoadedEvent");
}
