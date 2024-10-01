import 'package:flutter/material.dart';
import '../model/TreatmentModel.dart';
import '../observer/observer.dart';
import '../repository/TreatmentRepository.dart';
import '../viewModel/TreatmentViewModel.dart';


class TreatmentWidget extends StatefulWidget {
  const TreatmentWidget({super.key,required this.title});
  final String title;
  @override
  State<StatefulWidget> createState() {
    return _TreatmentWidgetState();
  }
}

class _TreatmentWidgetState extends State<TreatmentWidget> implements EventObserver {
  final TreatmentViewModel _viewModel = TreatmentViewModel(TreatmentRepository());
  bool _isLoading = false;
  List<Treatment> _treatments = [];

  @override
  void initState() {
    super.initState();
    _viewModel.subscribe(this);
    _viewModel.loadTreatments();
  }

  @override
  void dispose() {
    super.dispose();
    _viewModel.unsubscribe(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: _isLoading
            ? const Center(
          child: CircularProgressIndicator(),
        )
            : ListView.builder(
          itemCount: _treatments.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(_treatments[index].name),
              subtitle: Text(_treatments[index].specialInstructions),
            );
          },
        )
    );
  }

  @override
  void notify(ViewEvent event) {
    if (event is LoadingEvent) {
      setState(() {
        _isLoading = event.isLoading;
      });
    } else if (event is TreatmentLoadedEvent) {
      setState(() {
        _treatments = event.treatments;
      });
    }
  }
}