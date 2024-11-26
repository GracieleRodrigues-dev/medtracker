import 'package:flutter/material.dart';
import '../observer/observer.dart';
import '../viewModel/TreatmentScheduleViewModel.dart';
import '../viewModel/TreatmentViewModel.dart' as tvm;

class TodayWidget extends StatefulWidget {
  const TodayWidget({super.key, required this.title});

  final String title;

  @override
  State<StatefulWidget> createState() {
    return _TodayWidgetState();
  }
}

class _TodayWidgetState extends State<TodayWidget> implements EventObserver {
  final TreatmentScheduleViewModel _viewModel = TreatmentScheduleViewModel();
  final tvm.TreatmentViewModel _viewModelTreatment = tvm.TreatmentViewModel();
  List<dynamic> _pendingSchedules = [];
  bool _isLoading = false;
  DateTime today = DateTime.now();

  @override
  void initState() {
    super.initState();
    _viewModel.subscribe(this);
    _viewModelTreatment.subscribe(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.loadSchedules(isTaken: false, scheduledTime: today);
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
          : _pendingSchedules.isEmpty
          ? const Center(child: Text('Nenhum medicamento pendente hoje.'))
          : ListView.builder(
        itemCount: _pendingSchedules.length,
        itemBuilder: (context, index) {
          final schedule = _pendingSchedules[index];
          return Dismissible(
            key: Key(schedule['id'].toString()),
            direction: DismissDirection.endToStart, // Direção para deslizar
            onDismissed: (direction) {
              _markAsTaken(schedule);
            },
            background: Container(
              color: Colors.green, // Cor de fundo quando arrastado
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(
                Icons.check,
                color: Colors.white,
              ),
            ),
            child: Card(
              margin: const EdgeInsets.symmetric(
                  vertical: 8.0, horizontal: 16.0),
              child: ListTile(
                title: Text(
                  schedule['treatmentName'] ?? 'Nome desconhecido',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'Horário: ${DateTime.parse(schedule['scheduledTime']).toLocal().toString().substring(11, 16)} - '
                      'Dose: ${schedule['doseAmount']}',
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _markAsTaken(dynamic schedule) {
    setState(() {
      _isLoading = true;
    });
    _viewModel.markScheduleAsCompleted(schedule['id']).then((_) {
      setState(() {
        _pendingSchedules =
            _pendingSchedules.where((s) => s['id'] != schedule['id']).toList();
        _isLoading = false;
      });
    }).catchError((error) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
    });
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
    } else if (event is ScheduleUpdatedEvent) {
      setState(() {
        _viewModel.loadSchedules(isTaken: false, scheduledTime: DateTime.now());
      });
    }else if (event is tvm.TreatmentDeletedEvent) {
      setState(() {
        _viewModel.loadSchedules(isTaken: false, scheduledTime: DateTime.now());
      });
    } else if (event is ErrorEvent) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(event.message)));
    }
  }
}
