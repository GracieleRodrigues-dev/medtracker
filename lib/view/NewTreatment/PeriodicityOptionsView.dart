import 'package:flutter/material.dart';
import 'package:medtracker/view/NewTreatment/IntervalView.dart';
import 'package:medtracker/view/NewTreatment/MultiplesTimesView.dart';
import 'package:medtracker/view/NewTreatment/SpecificDaysView.dart';

class PeriodicityOptionsWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onPeriodicityChanged;
  const PeriodicityOptionsWidget({required this.onPeriodicityChanged, super.key});

  @override
  State<PeriodicityOptionsWidget> createState() => _PeriodicityOptionsWidgetState();
}

class _PeriodicityOptionsWidgetState extends State<PeriodicityOptionsWidget> {
  String _selectedOption = 'Intervalo';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Periodicidade', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedOption,
          items: ['Intervalo', 'Várias vezes ao dia', 'Dias específicos da semana']
              .map((option) => DropdownMenuItem(value: option, child: Text(option)))
              .toList(),
          onChanged: (value) {
            setState(() {
              _selectedOption = value!;
            });
            _notifyParent();
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

  // 'Interval', 'MultiplesTimes', 'SpecificDays'
  Widget _buildPeriodicForm() {
    switch (_selectedOption) {
      case 'Intervalo':
        return IntervalWidget(
          onIntervalChanged: (data) {
            widget.onPeriodicityChanged({'type': 'Interval', ...data});
          },
        );
      case 'Várias vezes ao dia':
        return MultipleTimesWidget(
          onMultipleTimesChanged: (data) {
            widget.onPeriodicityChanged({'type': 'MultiplesTimes', ...data});
          },
        );
      case 'Dias específicos da semana':
        return SpecificDaysWidget(
          onSpecificDaysChanged: (data) {
            widget.onPeriodicityChanged({'type': 'SpecificDays', ...data});
          },
        );
      default:
        return Container();
    }
  }

  void _notifyParent() {
    widget.onPeriodicityChanged({'type': _selectedOption});
  }
}
