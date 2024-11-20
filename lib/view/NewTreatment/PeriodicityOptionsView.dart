import 'package:flutter/material.dart';
import 'package:medtracker/view/NewTreatment/IntervalView.dart';
import 'package:medtracker/view/NewTreatment/MultiplesTimesView.dart';
import 'SpecificDaysView.dart';

class PeriodicityOptionsWidget extends StatefulWidget {
  const PeriodicityOptionsWidget({super.key});
  @override
  State<PeriodicityOptionsWidget> createState() => _PeriodicityOptionsWidgetState();
}

class _PeriodicityOptionsWidgetState extends State<PeriodicityOptionsWidget> {
  String _selectedOption = 'Intervalo';
  final List<String> _options = ['Intervalo', 'Várias vezes ao dia', 'Dias específicos da semana'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Periodicidade', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedOption,
          items: _options.map((option) {
            return DropdownMenuItem(
              value: option,
              child: Text(option),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedOption = value!;
            });
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 16),
        _buildPeriodicForm(),
      ],
    );
  }

  Widget _buildPeriodicForm() {
    switch (_selectedOption) {
      case 'Intervalo':
        return IntervalWidget();
      case 'Várias vezes ao dia':
        return MultipleTimesWidget();
      case 'Dias específicos da semana':
        return SpecificDaysWidget();
      default:
        return Container();
    }
  }
}
