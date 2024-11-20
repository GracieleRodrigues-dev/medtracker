import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:medtracker/view/NewTreatment/NewTreatmentView.dart';
import 'package:medtracker/view/TodayView.dart';
import 'TreatmentView.dart';
import 'ProgressView.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});
  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  int _page = 0;

  final List<Widget> _pages = [
    const TodayWidget(title: "Hoje"),//0
    const ProgressWidget(title:"Progresso"),//1
    const TreatmentWidget(title: "Tratamentos"),//2
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _page,
        children: _pages,
      ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewTreatmentWidget(),
              ),
            );
          },
          child: Icon(Icons.add), // Ícone do botão
        ),
      bottomNavigationBar: CurvedNavigationBar(
        color: Theme.of(context).colorScheme.inversePrimary,
        backgroundColor: Theme.of(context).colorScheme.surface,
        buttonBackgroundColor: Theme.of(context).colorScheme.inversePrimary,
        items: const <Widget>[
          Icon(Icons.calendar_today_outlined),
          Icon(Icons.bar_chart),
          Icon(Icons.medical_services_outlined),
        ],
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
      ),
    );
  }
}
