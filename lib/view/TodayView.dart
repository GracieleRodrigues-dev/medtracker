import 'package:flutter/material.dart';
import '../observer/observer.dart';
import '../repository/TreatmentScheduleRepository.dart';
import '../viewModel/TreatmentScheduleViewModel.dart';

class TodayWidget extends StatefulWidget {
  const TodayWidget({super.key, required this.title});

  final String title;

  @override
  State<StatefulWidget> createState() {
    return _TodayWidgetState();
  }
}

class _TodayWidgetState extends State<TodayWidget> implements EventObserver {
  final TreatmentScheduleViewModel _viewModel = TreatmentScheduleViewModel(TreatmentScheduleRepository());
  List<dynamic> _pendingSchedules = [];  // Usando dynamic para não depender do model diretamente
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _viewModel.subscribe(this);

    DateTime today = DateTime.now();
    _viewModel.loadSchedules(isTaken: false, scheduledTime: today);
  }

  @override
  void dispose() {
    _viewModel.unsubscribe(this);
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
          : _pendingSchedules.isEmpty
          ? const Center(child: Text('Nenhum medicamento pendente hoje.'))
          : ListView.builder(
        itemCount: _pendingSchedules.length,
          itemBuilder: (context, index) {
            final schedule = _pendingSchedules[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: ListTile(
                title: Text(schedule['treatmentName'] ?? 'Nome desconhecido'),
                subtitle: Text(
                  'Horário: ${DateTime.parse(schedule['scheduledTime']).toLocal().toString().substring(11, 16)} - '
                      'Dose: ${schedule['doseAmount']} unidades',
                ),
                trailing: Icon(
                  Icons.pending_actions,
                  color: Colors.orange,
                ),
              ),
            );
          }

      ),
    );
  }


  @override
  void notify(ViewEvent event) {
    if (event is LoadingEvent) {
      setState(() {
        _isLoading = event.isLoading;
      });
    } else if (event is PendingSchedulesLoadedEvent) {
      setState(() {
        _pendingSchedules = event.schedules;
      });
    }
  }
}
