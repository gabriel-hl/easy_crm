import 'package:brasil_fields/brasil_fields.dart';
import 'package:easy_crm/data/datasources/visita_db_datasource.dart';
import 'package:easy_crm/models/visita_model.dart';
import 'package:easy_crm/repository/visita_repository.dart';
import 'package:easy_crm/util/validations_mixin.dart';
import 'package:easy_crm/widgets/custom_text_form_field.dart';
import 'package:easy_crm/widgets/error_dialog.dart';
import 'package:easy_crm/widgets/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditVisitaScreen extends StatefulWidget {
  const EditVisitaScreen({super.key, required this.visita});

  final Visita visita;

  @override
  State<EditVisitaScreen> createState() => _EditVisitaScreenState();
}

class _EditVisitaScreenState extends State<EditVisitaScreen> with ValidationsMixin {
  final _formKey = GlobalKey<FormState>();
  final _dataVisitaController = TextEditingController();
  final _descricaoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dataVisitaController.text = UtilData.obterDataDDMMAAAA(DateTime.fromMillisecondsSinceEpoch(widget.visita.data));
    _descricaoController.text = widget.visita.descricao;
  }

  @override
  void dispose() {
    super.dispose();
    _dataVisitaController.dispose();
    _descricaoController.dispose();
  }

  Future<bool> saveVisita() async {
    final visitaRepo = VisitaRepository(VisitaDBDataSource());

    List<String> dateParts = _dataVisitaController.text.split('/');
    String formattedDate = '${dateParts[2]}-${dateParts[1]}-${dateParts[0]}';
    DateTime date = DateTime.parse(formattedDate);

    widget.visita.data = date.millisecondsSinceEpoch;
    widget.visita.descricao = _descricaoController.text;

    await visitaRepo.updateVisita(widget.visita);

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Editando visita'),
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
                  await saveVisita();
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
            child: const Text('Salvar'),
          ),
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
