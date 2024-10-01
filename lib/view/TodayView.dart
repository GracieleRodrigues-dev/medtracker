import 'package:flutter/material.dart';

import '../observer/observer.dart';

class TodayWidget extends StatefulWidget {
  const TodayWidget({super.key,required this.title});
  final String title;
  @override
  State<StatefulWidget> createState() {
    return _TodayWidgetState();
  }
}


class _TodayWidgetState extends State<TodayWidget> implements EventObserver {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .inversePrimary,
        title: Text(widget.title),
      ),
    );
  }

  @override
  void notify(ViewEvent event) {
    // TODO: implement notify
  }
}