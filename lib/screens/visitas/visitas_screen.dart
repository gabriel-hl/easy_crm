import 'package:brasil_fields/brasil_fields.dart';
import 'package:easy_crm/models/visita_model.dart';
import 'package:easy_crm/providers/visitas_provider.dart';
import 'package:easy_crm/screens/visitas/edit_visita_screen.dart';
import 'package:easy_crm/screens/visitas/new_visita_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VisitasScreen extends ConsumerStatefulWidget {
  const VisitasScreen({super.key, required this.clienteID});
  final int clienteID;

  @override
  ConsumerState<VisitasScreen> createState() => _VisitasScreenState();
}

class _VisitasScreenState extends ConsumerState<VisitasScreen> {
  Widget visitaList(List<Visita> visitasList) {
    return ListView.separated(
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        String data = UtilData.obterDataDDMMAAAA(DateTime.fromMillisecondsSinceEpoch(visitasList[index].data));
        return Material(
          elevation: 1,
          child: ListTile(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => PopScope(
                  onPopInvoked: (_) {
                    // ignore: unused_result
                    ref.refresh(visitasNotifierProvider(widget.clienteID));
                  },
                  child: EditVisitaScreen(
                    visita: visitasList[index],
                  ),
                ),
              ));
            },
            title: Text(data),
            subtitle: Text(visitasList[index].descricao),
          ),
        );
      },
      itemCount: visitasList.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    AsyncValue<List<Visita>> visitas = ref.watch(visitasNotifierProvider(widget.clienteID));

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Visitas'),
      ),
      floatingActionButton: visitas.isLoading || visitas.hasError
          ? null
          : FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PopScope(
                      child: NewVisitaScreen(clienteID: widget.clienteID),
                      onPopInvoked: (_) {
                        visitas = ref.refresh(visitasNotifierProvider(widget.clienteID));
                      },
                    ),
                  ),
                );
              },
              child: const Icon(Icons.add),
            ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: visitas.when(
          data: (visitasList) {
            return visitasList.isEmpty
                ? const Center(
                    child: Text(
                      'Ainda não há visitas registradas ao cliente\nComece adicionando uma nova',
                      textAlign: TextAlign.center,
                    ),
                  )
                : visitaList(visitasList);
          },
          error: (error, stackTrace) {
            return Center(
              child: Column(
                children: [
                  TextButton.icon(
                      onPressed: () {
                        visitas = ref.refresh(visitasNotifierProvider(widget.clienteID));
                      },
                      icon: const Icon(Icons.restart_alt),
                      label: const Text('Recarregar')),
                  const SizedBox(height: 18),
                  Text(
                    'Erro ao carregar clientes',
                    style: TextStyle(fontSize: 18, color: Theme.of(context).colorScheme.error, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 18),
                  Text(error.toString()),
                  SingleChildScrollView(child: Text(stackTrace.toString()))
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
