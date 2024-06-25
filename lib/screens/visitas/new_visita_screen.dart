import 'package:brasil_fields/brasil_fields.dart';
import 'package:easy_crm/models/visita_model.dart';
import 'package:easy_crm/providers/visitas_provider.dart';
import 'package:easy_crm/util/validations_mixin.dart';
import 'package:easy_crm/widgets/custom_text_form_field.dart';
import 'package:easy_crm/widgets/error_dialog.dart';
import 'package:easy_crm/widgets/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewVisitaScreen extends ConsumerStatefulWidget {
  const NewVisitaScreen({super.key, required this.clienteID});

  final int clienteID;

  @override
  ConsumerState<NewVisitaScreen> createState() => _NewVisitaScreenState();
}

class _NewVisitaScreenState extends ConsumerState<NewVisitaScreen> with ValidationsMixin {
  final _formKey = GlobalKey<FormState>();
  final _dataVisitaController = TextEditingController(text: UtilData.obterDataDDMMAAAA(DateTime.now()));
  final _descricaoController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _dataVisitaController.dispose();
    _descricaoController.dispose();
  }

  Future<bool> saveNewVisita() async {
    List<String> dateParts = _dataVisitaController.text.split('/');
    String formattedDate = '${dateParts[2]}-${dateParts[1]}-${dateParts[0]}';
    DateTime date = DateTime.parse(formattedDate);

    final newVisita = Visita(id: 0, clienteID: widget.clienteID, data: date.millisecondsSinceEpoch, descricao: _descricaoController.text);

    await ref.read(visitasNotifierProvider(widget.clienteID).notifier).insertVisita(newVisita);

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Nova visita'),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.close_outlined),
        ),
        actions: [
          TextButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) => const LoadingDialog(),
                  );

                  try {
                    await saveNewVisita();
                    if (context.mounted) {
                      // fecha loading
                      Navigator.of(context).pop();

                      // volta pra home
                      Navigator.of(context).pop();
                    }
                  } catch (error) {
                    if (context.mounted) {
                      Navigator.of(context).pop();
                      showDialog(
                        context: context,
                        builder: (context) => ErrorDialog(title: 'Erro ao salvar', error: error.toString()),
                      );
                    }
                  }
                }
              },
              child: const Text('Salvar')),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextFormField(
                  enabled: true,
                  controller: _dataVisitaController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.singleLineFormatter, FilteringTextInputFormatter.digitsOnly, DataInputFormatter()],
                  validator: isDateValid,
                  icon: const Icon(Icons.calendar_month),
                  labelText: 'Data visita',
                ),
                const SizedBox(height: 12),
                CustomTextFormField(
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  controller: _descricaoController,
                  validator: isNotEmpty,
                  icon: const Icon(null),
                  labelText: 'Descrição',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
