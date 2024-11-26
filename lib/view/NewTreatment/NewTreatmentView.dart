import 'package:flutter/material.dart';
import 'package:medtracker/view/NewTreatment/PeriodicityOptionsView.dart';
import '../../observer/observer.dart';
import '../../viewModel/TreatmentScheduleViewModel.dart' hide LoadingEvent;
import '../../viewModel/TreatmentViewModel.dart';

class NewTreatmentWidget extends StatefulWidget {
  const NewTreatmentWidget({super.key});

  @override
  State<NewTreatmentWidget> createState() => _NewTreatmentWidgetState();
}

class _NewTreatmentWidgetState extends State<NewTreatmentWidget>
    implements EventObserver {
  final TextEditingController _medicationNameController =
      TextEditingController();
  String _selectedType = 'Comprimido';
  final List<String> _types = ['Comprimido', 'Injeção', 'Inalação', 'Outro'];
  DateTime? _startDate;
  DateTime? _endDate;
  Map<String, dynamic>? _periodicity;

  final TreatmentViewModel _viewModel = TreatmentViewModel();
  final TreatmentScheduleViewModel _scheduleViewModel = TreatmentScheduleViewModel();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _viewModel.subscribe(this);
    _scheduleViewModel.subscribe(this);
  }

  @override
  void dispose() {
    _medicationNameController.dispose();
    _viewModel.unsubscribe(this);
    _scheduleViewModel.unsubscribe(this);
    super.dispose();
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Medicamento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _medicationNameController,
              decoration: const InputDecoration(
                labelText: 'Nome do Medicamento',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
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
              decoration: const InputDecoration(
                labelText: 'Tipo de Medicamento',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            PeriodicityOptionsWidget(
              onPeriodicityChanged: (value) {
                setState(() {
                  _periodicity = value;
                });
              },
            ),

            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDateSelector(
                  label: 'Data Início:',
                  selectedDate: _startDate,
                  onSelectDate: (date) => setState(() {
                    _startDate = date;
                  }),
                ),
                const SizedBox(height: 8),
                _buildDateSelector(
                  label: 'Data Fim:',
                  selectedDate: _endDate,
                  firstDate: _startDate ?? DateTime.now(),
                  onSelectDate: (date) => setState(() {
                    _endDate = date;
                  }),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _saveTreatment,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector({
    required String label,
    DateTime? selectedDate,
    DateTime? firstDate,
    required ValueChanged<DateTime> onSelectDate,
  }) {
    return Row(
      children: [
        Text(label),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: selectedDate ?? DateTime.now(),
                  firstDate: firstDate ?? DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (pickedDate != null) {
                  onSelectDate(pickedDate);
                }
              },
              child: Text(
                selectedDate == null
                    ? 'Selecione a Data'
                    : _formatDate(selectedDate),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _saveTreatment() async {
    final treatmentData = {
      'name': _medicationNameController.text,
      'form': _selectedType,
      'startDate': _startDate ?? DateTime.now(),
      'endDate': _endDate ?? DateTime.now().add(Duration(days: 7)),
      'reminderType': _periodicity?['type'] ?? 'Intervalo',
      'frequencyPerDay': _periodicity?['frequencyPerDay'] ?? 0,
      'specificDays': _periodicity?['specificDays'] ?? [0],
      'intervalType': _periodicity?['intervalType'] ?? '',
      'intervalValue': _periodicity?['intervalValue'] ?? 0,
      'startTime': _periodicity?['startTime'] ?? ''
    };

    final treatmentId = await _viewModel.saveTreatment(treatmentData);

    _scheduleViewModel.createSchedulesForTreatment(
      treatmentId: treatmentId,
      startDate: _startDate ?? DateTime.now(),
      endDate: _endDate ?? DateTime.now().add(Duration(days: 7)),
      periodicity: _periodicity,
    );
    }

  @override
  void notify(ViewEvent event) {
    if (event is LoadingEvent) {
      setState(() {
        _isLoading = event.isLoading;
      });
    } else if (event is TreatmentCreatedEvent) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tratamento salvo com sucesso!')),
      );
      Navigator.pop(context);
    }
  }
}
