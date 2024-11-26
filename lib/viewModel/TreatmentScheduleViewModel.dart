import 'package:flutter/material.dart';

import '../model/TreatmentScheduleModel.dart';
import '../repository/TreatmentScheduleRepository.dart';
import '../observer/observer.dart';
import '../observer/viewmodel.dart';

class TreatmentScheduleViewModel extends EventViewModel {

  static final TreatmentScheduleViewModel _instance =
  TreatmentScheduleViewModel._internal(TreatmentScheduleRepository());

  factory TreatmentScheduleViewModel() {
    return _instance;
  }

  TreatmentScheduleViewModel._internal(this._repository);
  final TreatmentScheduleRepository _repository;

  void loadSchedules({bool? isTaken, DateTime? scheduledTime}) {
    notify(LoadingEvent(isLoading: true));

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


  void createSchedulesForTreatment({
    required int treatmentId,
    required DateTime startDate,
    required DateTime endDate,
    required Map<String, dynamic>? periodicity,
  }) {
    final type = periodicity?['type'];

    if (type == 'Interval') {
      _generateIntervalSchedules(periodicity!, treatmentId,startDate,endDate);
    } else if (type == 'MultiplesTimes') {
      _generateMultipleTimesSchedules(periodicity!, treatmentId,startDate,endDate);
    } else if (type == 'SpecificDays') {
      _generateSpecificDaysSchedules(periodicity!, treatmentId,startDate,endDate);
    } else {
      throw Exception('Tipo de periodicidade não reconhecido');
    }
  }

  void _generateIntervalSchedules(Map<String, dynamic> periodicity, int treatmentId, DateTime startDate, DateTime endDate) {
    final intervalValue = periodicity['intervalValue'];
    final intervalType = periodicity['intervalType'];
    final startTime = periodicity['startTime'];
    final doseAmount = periodicity['dosage'];

    DateTime scheduledDate = DateTime(
      startDate.year,
      startDate.month,
      startDate.day,
      int.parse(startTime.split(":")[0]),
      int.parse(startTime.split(":")[1]),
    );

    while (_removeTime(scheduledDate).isBefore(endDate) || _removeTime(scheduledDate).isAtSameMomentAs(endDate)) {
      final scheduleData = {
        'treatmentId': treatmentId,
        'scheduledTime': scheduledDate,
        'doseAmount': doseAmount,
        'isTaken': false,
      };

      _saveSchedule(scheduleData);

      if (intervalType == 'Dias') {
        scheduledDate = scheduledDate.add(Duration(days: intervalValue));
      } else if (intervalType == 'Horas') {
        scheduledDate = scheduledDate.add(Duration(hours: intervalValue));
      } else {
        throw Exception('Unidade de intervalo não reconhecida. Use "Dias" ou "Horas".');
      }
    }
  }

  void _generateMultipleTimesSchedules(Map<String, dynamic> periodicity, int treatmentId, DateTime startDate, DateTime endDate) {
    final timesList = periodicity['timesList'];

    for (var timeData in timesList) {
      TimeOfDay timeOfDay = timeData['hora'];
      int doseAmount = timeData['dosagem'];

      DateTime scheduledDate = DateTime(
        startDate.year,
        startDate.month,
        startDate.day,
        timeOfDay.hour,
        timeOfDay.minute,
      );


      while (_removeTime(scheduledDate).isBefore(endDate) || _removeTime(scheduledDate).isAtSameMomentAs(endDate)) {
        final scheduleData = {
          'treatmentId': treatmentId,
          'scheduledTime': scheduledDate,
          'doseAmount': doseAmount,
          'isTaken': false,
        };

        _saveSchedule(scheduleData);

        scheduledDate = scheduledDate.add(Duration(days: 1));

        scheduledDate = DateTime(
          scheduledDate.year,
          scheduledDate.month,
          scheduledDate.day,
          timeOfDay.hour,
          timeOfDay.minute,
        );
      }
    }
  }

  void _generateSpecificDaysSchedules(Map<String, dynamic> periodicity, int treatmentId, DateTime startDate, DateTime endDate) {
    final specificDays = periodicity['specificDays'];
    final startTime = periodicity['startTime'];
    final doseAmount = periodicity['dosage'];

    for (int i = 0; i < specificDays.length; i++) {
      int dayOfWeek = specificDays[i];
      DateTime scheduledDate = _getNextWeekDay(startDate, dayOfWeek);

      while  (_removeTime(scheduledDate).isBefore(endDate) || _removeTime(scheduledDate).isAtSameMomentAs(endDate)) {
        final scheduledTime = DateTime(
          scheduledDate.year,
          scheduledDate.month,
          scheduledDate.day,
          int.parse(startTime.split(":")[0]),
          int.parse(startTime.split(":")[1]),
        );

        final scheduleData = {
          'treatmentId': treatmentId,
          'scheduledTime': scheduledTime,
          'doseAmount': doseAmount,
          'isTaken': false,
        };

        _saveSchedule(scheduleData);
        scheduledDate = scheduledDate.add(Duration(days: 7));
      }
    }
  }
  DateTime _getNextWeekDay(DateTime date, int dayOfWeek) {
    int difference = (dayOfWeek - date.weekday + 7) % 7;
    return date.add(Duration(days: difference));
  }

  DateTime _removeTime(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  void _saveSchedule(Map<String, dynamic> scheduleData) {
    final schedule = TreatmentSchedule(
      treatmentId: scheduleData['treatmentId'],
      scheduledTime: scheduleData['scheduledTime'],
      doseAmount: scheduleData['doseAmount'],
      isTaken: scheduleData['isTaken'],
      takenTime: scheduleData['takenTime'],
    );

    _repository.insert(schedule).then((id) {
      print('Agendamento salvo: $scheduleData');
      notify(ScheduleCreatedEvent(schedule));
      loadSchedules(isTaken: false,scheduledTime: DateTime.now());
    });
  }

  Future<void> markScheduleAsCompleted(int scheduleId) async {
    notify(LoadingEvent(isLoading: true));  // Notifica que está carregando

    _repository.getById(scheduleId).then((schedule) {
      if (schedule != null) {
        schedule.isTaken = true;
        schedule.takenTime = DateTime.now();  // Define a data e hora atual

        _repository.update(schedule).then((result) {
          if (result > 0) {
            print('Agendamento marcado como concluído: ID = $scheduleId');
            notify(ScheduleUpdatedEvent(schedule));
            loadSchedules(isTaken: false, scheduledTime: DateTime.now());
          } else {
            notify(ErrorEvent('Erro ao atualizar o agendamento.'));
          }
        });
      } else {
        notify(ErrorEvent('Agendamento não encontrado.'));
      }
      notify(LoadingEvent(isLoading: false));
    }).catchError((error) {
      notify(LoadingEvent(isLoading: false));
      notify(ErrorEvent('Erro ao marcar agendamento como concluído.'));
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

class ErrorEvent extends ViewEvent {
  final String message;
  ErrorEvent(this.message) : super("ErrorEvent");
}