import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../observer/observer.dart';
import '../viewModel/TreatmentScheduleViewModel.dart';
import '../viewModel/TreatmentViewModel.dart' as tvm;

class ProgressWidget extends StatefulWidget {
  const ProgressWidget({super.key, required this.title});

  final String title;

  @override
  State<StatefulWidget> createState() {
    return _ProgressWidgetState();
  }
}

class _ProgressWidgetState extends State<ProgressWidget> implements EventObserver {
  final TreatmentScheduleViewModel _viewModel = TreatmentScheduleViewModel();
  final tvm.TreatmentViewModel _viewModelTreatment = tvm.TreatmentViewModel();
  List<dynamic> _takenSchedules = [];
  bool _isLoading = false;
  DateTime today = DateTime.now();
  Map<String, List<dynamic>> _groupedSchedules = {};

  @override
  void initState() {
    super.initState();
    _viewModel.subscribe(this);
    _viewModelTreatment.subscribe(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.loadSchedules(isTaken: true);
    });
  }

  @override
  void dispose() {
    _viewModel.unsubscribe(this);
    _viewModelTreatment.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _takenSchedules.isEmpty
          ? const Center(child: Text('Nenhum medicamento tomado.'))
          : ListView.builder(
        itemCount: _groupedSchedules.length,
        itemBuilder: (context, index) {
          String dateKey = _groupedSchedules.keys.elementAt(index);
          List<dynamic> schedulesForDate = _groupedSchedules[dateKey]!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(
                color: Theme.of(context).colorScheme.tertiary,
                thickness: 1,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  dateKey,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              ...schedulesForDate.map((schedule) {
                return Card(
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: ListTile(
                    title: Text(
                      schedule['treatmentName'] ?? 'Nome desconhecido',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Horário: ${DateTime.parse(schedule['takenTime']).toLocal().toString().substring(11, 16)} - '
                          'Dose: ${schedule['doseAmount']}',
                    ),
                  ),
                );
              }).toList()
            ],
          );
        },
      ),
    );
  }

  @override
  void notify(ViewEvent event) {
    if (event is LoadingEvent) {
      setState(() {
        _isLoading = event.isLoading;
      });
    } else if (event is TakenSchedulesLoadedEvent) {
      setState(() {
        _takenSchedules = event.schedules;
        _groupedSchedules = _groupByDate(_takenSchedules);
      });
    } else if (event is ScheduleUpdatedEvent) {
      setState(() {
        _viewModel.loadSchedules(isTaken: true);
      });
    } else if (event is tvm.TreatmentDeletedEvent) {
      setState(() {
        _viewModel.loadSchedules(isTaken: true);
      });
    } else if (event is ErrorEvent) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(event.message)));
    }
  }

  Map<String, List<dynamic>> _groupByDate(List<dynamic> schedules) {
    Map<String, List<dynamic>> groupedSchedules = {};
    for (var schedule in schedules) {
      DateTime takenDate = DateTime.parse(schedule['takenTime']).toLocal();
      String formattedDate = _formatDate(takenDate);
      if (!groupedSchedules.containsKey(formattedDate)) {
        groupedSchedules[formattedDate] = [];
      }
      groupedSchedules[formattedDate]?.add(schedule);
    }
    return groupedSchedules;
  }

  String _formatDate(DateTime date) {
    final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    final DateFormat weekDayFormat = DateFormat('EEEE');
    String dateStr = dateFormat.format(date);
    String weekDayStr = weekDayFormat.format(date);
    return '$dateStr - $weekDayStr';
  }
}
