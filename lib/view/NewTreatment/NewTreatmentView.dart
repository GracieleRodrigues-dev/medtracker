import 'package:flutter/material.dart';
import 'package:medtracker/view/NewTreatment/PeriodicityOptionsView.dart';
import '../../observer/observer.dart';
import '../../repository/TreatmentRepository.dart';
import '../../repository/TreatmentScheduleRepository.dart';
import '../../viewModel/TreatmentScheduleViewModel.dart' hide LoadingEvent;
import '../../viewModel/TreatmentViewModel.dart';

class NewTreatmentWidget extends StatefulWidget {
  const NewTreatmentWidget({super.key});

  @override
  State<NewTreatmentWidget> createState() => _NewTreatmentWidgetState();
}

class _NewTreatmentWidgetState extends State<NewTreatmentWidget> implements EventObserver {
  final TextEditingController _medicationNameController = TextEditingController();
  String _selectedType = 'Comprimido';
  final List<String> _types = ['Comprimido', 'Injeção', 'Inalação', 'Outro'];
  DateTime? _startDate;
  DateTime? _endDate;

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  final TreatmentViewModel _viewModel = TreatmentViewModel();
  final TreatmentScheduleViewModel _scheduleViewModel = TreatmentScheduleViewModel(TreatmentScheduleRepository());
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _viewModel.subscribe(this);
  }

  @override
  void dispose() {
    super.dispose();
    _viewModel.unsubscribe(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Medicamento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _medicationNameController,
              decoration: InputDecoration(
                labelText: 'Nome do Medicamento',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: _selectedType,
              items: _types.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedType = value!;
                });
              },
              decoration: InputDecoration(
                labelText: 'Tipo de Medicamento',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            // Opções de periodicidade
            PeriodicityOptionsWidget(),

            SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Data Início:'),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: _startDate ?? DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(Duration(days: 365)),
                            );
                            if (pickedDate != null) {
                              setState(() {
                                _startDate = pickedDate;
                              });
                            }
                          },
                          child: Text(_startDate == null
                              ? 'Selecione a Data'
                              : _formatDate(_startDate!)),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),

                Row(
                  children: [
                    Text('Data Fim:'),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: _endDate ?? DateTime.now(),
                              firstDate: _startDate ?? DateTime.now(),
                              lastDate: DateTime.now().add(Duration(days: 365)),
                            );
                            if (pickedDate != null) {
                              setState(() {
                                _endDate = pickedDate;
                              });
                            }
                          },
                          child: Text(_endDate == null
                              ? 'Selecione a Data'
                              : _formatDate(_endDate!)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final treatmentData = {
                  'name': _medicationNameController.text,
                  'form': _selectedType,
                  'startDate': _startDate ?? DateTime.now(),
                  'endDate': _endDate ?? DateTime.now().add(Duration(days: 7)),
                  'reminderType': 'Daily',
                  'frequencyPerDay': 2,
                  'specificDays': [0, 1],
                };

                final treatmentId =
                    await _viewModel.saveTreatment(treatmentData);

                if (treatmentId != null) {
                  //criar schedule
                  final scheduleData = {
                    'treatmentId': treatmentId,
                    'scheduledTime': DateTime.now().add(Duration(hours: 8)),
                    'doseAmount': 1,
                    'isTaken': false,
                  };

                  _scheduleViewModel.saveSchedule(scheduleData);
                }
              },
              child: Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void notify(ViewEvent event) {
    if (event is LoadingEvent) {
      setState(() {
        _isLoading = event.isLoading;
      });
    } else if (event is TreatmentCreatedEvent) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Tratamento salvo com sucesso!'),
      ));
      Navigator.pop(context);
    } else if (event is ScheduleCreatedEvent) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Agendamento salvo com sucesso!'),
      ));
    }
  }
}
