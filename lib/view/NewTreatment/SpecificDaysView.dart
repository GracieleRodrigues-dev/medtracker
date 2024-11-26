import 'package:flutter/material.dart';

class SpecificDaysWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onSpecificDaysChanged;
  const SpecificDaysWidget({required this.onSpecificDaysChanged, super.key});
  @override
  State<SpecificDaysWidget> createState() => _SpecificDaysWidgetState();
}

class _SpecificDaysWidgetState extends State<SpecificDaysWidget> {
  final List<int> _selectedDays = [];
  TimeOfDay _selectedTime = TimeOfDay(hour: 8, minute: 0);
  final TextEditingController _startController = TextEditingController();
  int _dosage = 1;

  void _notifyParent() {
    widget.onSpecificDaysChanged({
      'specificDays': _selectedDays,
      'dosage': _dosage,
      'startTime': _startController.text,
    });
  }

  Future<void> pickTime() async {
    TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (newTime != null) {
      setState(() {
        _selectedTime = newTime;
      });
    }
  }

  Future<void> _openDoseDialog() async {
    int updatedDose = _dosage;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Selecione a Dose'),
          content: StatefulBuilder(
            builder: (BuildContext context, setStateDialog) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () {
                      setStateDialog(() {
                        if (updatedDose > 0) updatedDose--;
                      });
                    },
                  ),
                  Text('$updatedDose', style: TextStyle(fontSize: 24)),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      setStateDialog(() {
                        updatedDose++;
                      });
                    },
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _dosage = updatedDose;
                  _notifyParent();
                });
                Navigator.of(context).pop();
              },
              child: Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Seleção dos dias da semana
        Wrap(
          spacing: 8,
          children: List.generate(7, (index) {
            return ChoiceChip(
              label: Text(['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb'][index]),
              selected: _selectedDays.contains(index),
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedDays.add(index);
                  } else {
                    _selectedDays.remove(index);
                  }
                  _notifyParent();
                });
              },
            );
          }),
        ),
        SizedBox(height: 16),

        if (_selectedDays.isNotEmpty) ...[
          SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text("Dosagem"),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: _openDoseDialog,
                        child: Text('$_dosage'),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _startController,
                      decoration: InputDecoration(
                        labelText: 'Horário',
                        border: OutlineInputBorder(),
                      ),
                      readOnly: true,
                      onTap: () => _selectTime(context, true),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
            ],
          ),
        ],
      ],
    );
  }

  void _selectTime(BuildContext context, bool isStart) async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (selectedTime != null) {
      final timeString = selectedTime.format(context);
      if (isStart) {
        _startController.text = timeString;
      }
      _notifyParent();
    }
  }
}
