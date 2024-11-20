import 'package:flutter/material.dart';
import '../model/TreatmentModel.dart';
import '../observer/observer.dart';
import '../repository/TreatmentRepository.dart';
import '../viewModel/TreatmentViewModel.dart';

class TreatmentWidget extends StatefulWidget {
  const TreatmentWidget({super.key, required this.title});

  final String title;

  @override
  State<StatefulWidget> createState() {
    return _TreatmentWidgetState();
  }
}

class _TreatmentWidgetState extends State<TreatmentWidget>
    implements EventObserver {
  final TreatmentViewModel _viewModel = TreatmentViewModel();
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
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    _editTreatment(_treatments[index]);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    _deleteTreatment(_treatments[index]);
                  },
                ),
              ],
            ),
          );
        },
      ),
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

  void _editTreatment(Treatment treatment) {
    print('Editando tratamento: ${treatment.name}');
    // Implementar...
  }

  void _deleteTreatment(Treatment treatment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: const Text('Tem certeza que deseja excluir este tratamento?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _treatments.remove(treatment);
              });
              _viewModel.deleteTreatment(treatment.id);
            },
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }
}
