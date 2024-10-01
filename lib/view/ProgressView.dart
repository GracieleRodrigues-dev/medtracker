import 'package:flutter/material.dart';

import '../observer/observer.dart';

class ProgressWidget extends StatefulWidget {
  const ProgressWidget({super.key,required this.title});
  final String title;
  @override
  State<StatefulWidget> createState() {
    return _ProgressWidgetState();
  }
}


class _ProgressWidgetState extends State<ProgressWidget> implements EventObserver {
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