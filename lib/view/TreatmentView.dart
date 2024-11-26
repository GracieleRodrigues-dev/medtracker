import 'package:flutter/material.dart';
import '../model/TreatmentModel.dart';
import '../observer/observer.dart';
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

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
          ? const Center(child: CircularProgressIndicator())
          : _treatments.isEmpty
              ? const Center(child: Text('Nenhum tratamento encontrado.'))
              : ListView.builder(
                  itemCount: _treatments.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      child: ListTile(
                        title: Text(_treatments[index].name,
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(
                          'Início: ${_formatDate(_treatments[index].startDate)}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.delete),
                              color: Theme.of(context).colorScheme.tertiary,
                              onPressed: () {
                                _deleteTreatment(_treatments[index]);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.info_outline),
                              color: Theme.of(context).colorScheme.tertiary,
                              onPressed: () {
                                _viewDetails(_treatments[index]);
                              },
                            ),
                          ],
                        ),
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
    } else if (event is TreatmentDeletedEvent) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tratamento excluído com sucesso!')),
      );
    }
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

  void _viewDetails(Treatment treatment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(treatment.name),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('ID: ${treatment.id}'),
            Text('Tipo: ${treatment.form}'),
            Text('Tipo de Lembrete: ${treatment.reminderType}'),
            Text('Início: ${_formatDate(treatment.startDate)}'),
            Text('Fim: ${_formatDate(treatment.endDate)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }
}
