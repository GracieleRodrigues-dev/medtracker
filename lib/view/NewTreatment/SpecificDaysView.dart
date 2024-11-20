import 'package:flutter/material.dart';

class SpecificDaysWidget extends StatefulWidget {
  const SpecificDaysWidget({super.key});
  @override
  State<SpecificDaysWidget> createState() => _SpecificDaysWidgetState();
}

class _SpecificDaysWidgetState extends State<SpecificDaysWidget> {
  final List<bool> _selectedDays = List.generate(7, (index) => false);
  TimeOfDay _selectedTime = TimeOfDay(hour: 8, minute: 0);  // Hora padrão 08:00
  int _dosage = 1;

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
              selected: _selectedDays[index],
              onSelected: (selected) {
                setState(() {
                  _selectedDays[index] = selected;
                });
              },
            );
          }),
        ),
        SizedBox(height: 16),

        if (_selectedDays.any((selected) => selected)) ...[
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
              SizedBox(height: 16),
            ],
          ),
        ],
      ],
    );
  }
}
