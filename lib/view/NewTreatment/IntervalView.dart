import 'package:flutter/material.dart';

class IntervalWidget extends StatefulWidget {
  const IntervalWidget({super.key});
  @override
  State<IntervalWidget> createState() => _IntervalWidgetState();
}

class _IntervalWidgetState extends State<IntervalWidget> {
  final TextEditingController _intervalController = TextEditingController();
  final TextEditingController _startController = TextEditingController();

  String _selectedType = 'Horas'; // 'Horas' ou 'Dias'
  int _selectedInterval = 1; // Intervalo de hora ou dia
  int _dosage = 1;

  // Função para abrir o picker de número (para horas ou dias)
  Future<void> _openNumberPicker(BuildContext context, String type) async {
    List<int> options = [];

    if (type == 'Horas') {
      options = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]; // Opções de horas
    } else if (type == 'Dias') {
      options =
          List.generate(90, (index) => index + 1); // Opções de dias de 1 a 90
    }

    final int? selectedValue = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Escolha o intervalo em $type'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                for (var option in options)
                  ListTile(
                    title: Text(option.toString()),
                    onTap: () {
                      Navigator.of(context).pop(option);
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );

    if (selectedValue != null) {
      setState(() {
        _selectedInterval = selectedValue;
        _intervalController.text =
        '$_selectedInterval ${_selectedType.toLowerCase()}';
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
  void initState() {
    super.initState();
    _intervalController.text =
    '$_selectedInterval ${_selectedType.toLowerCase()}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Seleção entre Horas ou Dias
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('Escolha o tipo de intervalo:'),
            DropdownButton<String>(
              value: _selectedType,
              items: ['Horas', 'Dias'].map((String value) {
                return DropdownMenuItem<String>(value: value, child: Text(value));
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedType = newValue!;
                  _intervalController.text =
                  '$_selectedInterval ${_selectedType.toLowerCase()}';
                });
              },
            ),
          ],
        ),
        SizedBox(height: 16),

        GestureDetector(
          onTap: () => _openNumberPicker(context, _selectedType),
          child: AbsorbPointer(
            child: TextField(
              controller: _intervalController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Relembre a cada',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ),
        SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _startController,
                decoration: InputDecoration(
                  labelText: 'Hora de Início',
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
                onTap: () => _selectTime(context, true),
              ),
            ),
          ],
        ),

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
          ],
        )
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
    }
  }
}
