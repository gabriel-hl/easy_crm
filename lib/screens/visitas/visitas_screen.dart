import 'package:brasil_fields/brasil_fields.dart';
import 'package:easy_crm/models/visita_model.dart';
import 'package:easy_crm/providers/visitas_provider.dart';
import 'package:easy_crm/screens/visitas/edit_visita_screen.dart';
import 'package:easy_crm/screens/visitas/new_visita_screen.dart';
import 'package:easy_crm/widgets/confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

class VisitasScreen extends ConsumerStatefulWidget {
  const VisitasScreen({super.key, required this.clienteID});
  final int clienteID;

  @override
  ConsumerState<VisitasScreen> createState() => _VisitasScreenState();
}

class _VisitasScreenState extends ConsumerState<VisitasScreen> {
  Map<int, bool> selectedFlag = {};
  bool isSelectionMode = false;
  late List<Visita> loadedVisitas;

  void shareVisitas() {
    String result = '';
    selectedFlag.forEach((index, isSelected) {
      if (isSelected) {
        if (result.isNotEmpty) result += '\n\n';
        result += 'Visita de ${UtilData.obterDataDDMMAAAA(DateTime.fromMillisecondsSinceEpoch(loadedVisitas[index].data))}';
        result += '\nDescrição: ${loadedVisitas[index].descricao}';
      }
    });

    Share.share(result, subject: 'Compartilhando as visitas');
  }

  void onLongPress(bool isSelected, int index) {
    setState(() {
      selectedFlag[index] = !isSelected;
      isSelectionMode = selectedFlag.containsValue(true);
    });
  }

  void onTap(bool isSelected, int index, Visita visita) {
    if (isSelectionMode) {
      setState(() {
        selectedFlag[index] = !isSelected;
        isSelectionMode = selectedFlag.containsValue(true);
      });
    } else {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PopScope(
          onPopInvoked: (_) {
            // ignore: unused_result
            ref.refresh(visitasNotifierProvider(widget.clienteID));
          },
          child: EditVisitaScreen(
            visita: visita,
          ),
        ),
      ));
    }
  }

  Widget? _buildSelectIcon(bool isSelected) {
    if (isSelectionMode) {
      return Icon(
        isSelected ? Icons.check_box : Icons.check_box_outline_blank,
        color: Theme.of(context).colorScheme.primary,
      );
    } else {
      return null;
    }
  }

  Widget visitaList(List<Visita> visitasList) {
    return ListView.separated(
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        selectedFlag[index] = selectedFlag[index] ?? false;
        bool isSelected = selectedFlag[index]!;

        String data = UtilData.obterDataDDMMAAAA(DateTime.fromMillisecondsSinceEpoch(visitasList[index].data));
        return Material(
          elevation: 1,
          child: ListTile(
            contentPadding: const EdgeInsets.only(left: 12),
            onTap: () => onTap(isSelected, index, visitasList[index]),
            onLongPress: () => onLongPress(isSelected, index),
            leading: _buildSelectIcon(isSelected),
            title: Text(data),
            subtitle: Text(visitasList[index].descricao),
            trailing: isSelectionMode
                ? null
                : IconButton(
                    iconSize: 20,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => const ConfirmationDialog(title: 'Excluir visita', dialog: 'Deseja excluir a visita?'),
                      ).then((deleteVisita) {
                        if (deleteVisita ?? false) {
                          ref.read(visitasNotifierProvider(widget.clienteID).notifier).deleteVisitaByID(visitasList[index].id);
                        }
                      });
                    },
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.grey,
                    ),
                  ),
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
        actions: isSelectionMode ? [IconButton(onPressed: shareVisitas, icon: const Icon(Icons.share))] : null,
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
            loadedVisitas = visitasList;

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
