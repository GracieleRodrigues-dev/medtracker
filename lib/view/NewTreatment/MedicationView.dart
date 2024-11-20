import 'package:flutter/material.dart';
import 'package:medtracker/view/NewTreatment/PeriodicityOptionsView.dart';

class MedicationWidget extends StatefulWidget {
  const MedicationWidget({super.key});
  @override
  State<MedicationWidget> createState() => _MedicationWidgetState();
}

class _MedicationWidgetState extends State<MedicationWidget> {
  final TextEditingController _medicationNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Novo Tratamento')),
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
            PeriodicityOptionsWidget(),
          ],
        ),
      ),
    );
  }
}
