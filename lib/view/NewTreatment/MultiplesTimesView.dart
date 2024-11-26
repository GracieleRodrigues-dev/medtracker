import 'package:flutter/material.dart';

class MultipleTimesWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onMultipleTimesChanged;
  const MultipleTimesWidget({required this.onMultipleTimesChanged, super.key});
  @override
  State<MultipleTimesWidget> createState() => _MultipleTimesWidgetState();
}

class _MultipleTimesWidgetState extends State<MultipleTimesWidget> {
  int numTimes = 1;
  List<Map<String, dynamic>> timesList = [];

  final List<int> options = List.generate(10, (index) => index + 1);

  @override
  void initState() {
    super.initState();
    timesList = List.generate(numTimes, (index) => {'hora': TimeOfDay(hour: 8, minute: 0), 'dosagem': 1});
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notifyParent();
    });
  }

  void _notifyParent() {
    widget.onMultipleTimesChanged({
      'frequencyPerDay': numTimes,
      'timesList': timesList,
    });
  }

  void updateTimes(int newNumTimes) {
    setState(() {
      numTimes = newNumTimes;
      if (timesList.length < numTimes) {
        timesList.addAll(List.generate(numTimes - timesList.length, (index) => {'hora': TimeOfDay(hour: 8, minute: 0), 'dosagem': 1}));
      } else {
        timesList.removeRange(numTimes, timesList.length);
      }
    });
  }


  Future<void> pickTime(int index) async {
    TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: timesList[index]['hora'],
    );
    if (newTime != null) {
      setState(() {
        timesList[index]['hora'] = newTime;
      });
    }
  }

  Future<void> _openDoseDialog(int index) async {
    int updatedDose = timesList[index]['dosagem'];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alterar Dose'),
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
                Navigator.of(context).pop(updatedDose);
              },
              child: Text('Confirmar'),
            ),
          ],
        );
      },
    ).then((value) {
      if (value != null) {
        setState(() {
          timesList[index]['dosagem'] = value; // Atualiza a dose na lista
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quantas vezes ao dia?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        DropdownButtonFormField<int>(
          value: numTimes,
          items: options.map((int value) {
            return DropdownMenuItem<int>(
              value: value,
              child: Text('$value vez${value > 1 ? 'es' : ''}'),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              updateTimes(value);
              _notifyParent();
            }
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),

        SizedBox(height: 16),

        // Gerar campos dinâmicos para cada vez (hora e dosagem)
        ...List.generate(numTimes, (index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Horário ${index + 1}', style: TextStyle(fontSize: 16)),
                        IconButton(
                          icon: Icon(Icons.remove_circle_outline),
                          onPressed: () {
                            setState(() {
                              timesList.removeAt(index);
                              updateTimes(numTimes - 1);
                            });
                          },
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => pickTime(index),
                      child: Row(
                        children: [
                          Icon(Icons.access_time),
                          SizedBox(width: 8),
                          Text(timesList[index]['hora'].format(context), style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () => _openDoseDialog(index),
                      child: Row(
                        children: [
                          Icon(Icons.medication),
                          SizedBox(width: 8),
                          Text('Dose: ${timesList[index]['dosagem']}', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
