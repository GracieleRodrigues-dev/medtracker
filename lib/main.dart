import 'package:flutter/material.dart';
import 'package:medtracker/view/HomeView.dart';
import 'util.dart';
import 'theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;

    TextTheme textTheme = createTextTheme(context, "Roboto", "Roboto");

    MaterialTheme theme = MaterialTheme(textTheme);
    return MaterialApp(
      title: 'MedTracker',
      theme: brightness == Brightness.light ? theme.light() : theme.dark(),
      home: const HomeWidget(),
    );
  }
}