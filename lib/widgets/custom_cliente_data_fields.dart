import 'package:brasil_fields/brasil_fields.dart';
import 'package:easy_crm/data/datasources/brasil_api_datasource.dart';

import 'package:easy_crm/util/input_formatters/lowercase_input_formatter.dart';
import 'package:easy_crm/util/input_formatters/uppercase_input_formatter.dart';
import 'package:easy_crm/util/validations_mixin.dart';
import 'package:easy_crm/widgets/confirmation_dialog.dart';
import 'package:easy_crm/widgets/custom_contato_form.dart';
import 'package:easy_crm/widgets/custom_text_form_field.dart';
import 'package:easy_crm/widgets/error_dialog.dart';
import 'package:easy_crm/widgets/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomClienteDataFields extends StatefulWidget {
  const CustomClienteDataFields({
    super.key,
    required this.formKey,
    this.editableDataCadastro = true,
    required this.dataCadastroController,
    required this.cnpjCpfController,
    required this.razaoSocialNomeController,
    required this.nomeFantasiaApelidoController,
    required this.telefoneController,
    required this.emailController,
    required this.cepController,
    required this.logradouroController,
    required this.numeroController,
    required this.complementoController,
    required this.bairroController,
    required this.cidadeController,
    required this.estadoController,
    required this.contatoForms,
  });

  final Key formKey;
  final bool editableDataCadastro;
  final TextEditingController dataCadastroController;
  final TextEditingController cnpjCpfController;
  final TextEditingController razaoSocialNomeController;
  final TextEditingController nomeFantasiaApelidoController;
  final TextEditingController telefoneController;
  final TextEditingController emailController;
  final TextEditingController cepController;
  final TextEditingController logradouroController;
  final TextEditingController numeroController;
  final TextEditingController complementoController;
  final TextEditingController bairroController;
  final TextEditingController cidadeController;
  final TextEditingController estadoController;
  final List<CustomContatoForm> contatoForms;

  @override
  State<CustomClienteDataFields> createState() => _CustomClienteDataFieldsState();
}

class _CustomClienteDataFieldsState extends State<CustomClienteDataFields> with ValidationsMixin {
  void removeContatoForm(CustomContatoForm form) {
    setState(() {
      widget.contatoForms.remove(form);
    });
  }

  List<Widget> contatoFormsList() {
    List<Widget> forms = [];

    for (var form in widget.contatoForms) {
      forms.add(
        Card.filled(
          color: Theme.of(context).colorScheme.secondaryContainer,
          child: Padding(
            padding: const EdgeInsets.only(top: 12.0, left: 12, right: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                form,
                IconButton(
                  onPressed: () {
                    if (form.nomeController.text.isNotEmpty || form.cargoController.text.isNotEmpty || form.telefoneController.text.isNotEmpty) {
                      showDialog(
                        context: context,
                        builder: (context) => const ConfirmationDialog(title: 'Excluir contato', dialog: 'Deseja excluir o contato?'),
                      ).then((deleteContato) {
                        if (deleteContato ?? false) removeContatoForm(form);
                      });
                    } else {
                      removeContatoForm(form);
                    }
                  },
                  icon: const Icon(Icons.close),
                )
              ],
            ),
          ),
        ),
      );
    }

    return forms.reversed.toList();
  }

  void adicionarContato() {
    setState(() {
      var newContato = CustomContatoForm(
        contatoID: 0,
        nomeController: TextEditingController(),
        cargoController: TextEditingController(),
        telefoneController: TextEditingController(),
      );

      widget.contatoForms.add(newContato);
    });
  }

  void getCNPJFromField() async {
    // Método para pegar o CNPJ e pesquisar os dados na API online

    final context = this.context;
    Map<String, dynamic> clienteData;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => const LoadingDialog(),
    );

    try {
      clienteData = await BrasilAPIDataSource().getCNPJ(widget.cnpjCpfController.text);
      String logradouroCompleto = '${clienteData['descricao_tipo_de_logradouro']} ${clienteData['logradouro']}'.toUpperCase();
      widget.razaoSocialNomeController.text = clienteData['razao_social'].toString().toUpperCase();
      widget.nomeFantasiaApelidoController.text = clienteData['nome_fantasia'].toString().toUpperCase();
      widget.cepController.text = UtilBrasilFields.obterCep(clienteData['cep'].toString());
      widget.logradouroController.text = logradouroCompleto;
      widget.numeroController.text = clienteData['numero'].toString().toUpperCase();
      widget.complementoController.text = clienteData['complemento'].toString().toUpperCase();
      widget.bairroController.text = clienteData['bairro'].toString().toUpperCase();
      widget.cidadeController.text = clienteData['municipio'].toString().toUpperCase();
      widget.estadoController.text = clienteData['uf'].toString().toUpperCase();

      if (context.mounted) Navigator.of(context).pop();
    } catch (error) {
      if (context.mounted) {
        Navigator.of(context).pop();
        showDialog(
          context: context,
          builder: (context) => ErrorDialog(title: 'Erro ao carregar', error: 'Não foi possível carregar os dados da empresa. Preencha manualmente.\n\n${error.toString()}'),
        );
      }
    }
  }

  void getCEPFromField() async {
    final context = this.context;

    Map<String, dynamic> enderecoData;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => const LoadingDialog(),
    );

    try {
      enderecoData = await BrasilAPIDataSource().getCEP(widget.cepController.text);

      widget.logradouroController.text = enderecoData['street'].toString().toUpperCase();
      widget.numeroController.text = '';
      widget.complementoController.text = '';
      widget.bairroController.text = enderecoData['neighborhood'].toString().toUpperCase();
      widget.cidadeController.text = enderecoData['city'].toString().toUpperCase();
      widget.estadoController.text = enderecoData['state'].toString().toUpperCase();

      if (context.mounted) Navigator.of(context).pop();
    } catch (error) {
      if (context.mounted) {
        Navigator.of(context).pop();
        showDialog(
          context: context,
          builder: (context) => ErrorDialog(title: 'Erro ao carregar', error: 'Não foi possível carregar o endereço. Preencha manualmente.\n\n${error.toString()}'),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextFormField(
              enabled: widget.editableDataCadastro,
              controller: widget.dataCadastroController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.singleLineFormatter, FilteringTextInputFormatter.digitsOnly, DataInputFormatter()],
              validator: isDateValid,
              icon: const Icon(Icons.calendar_month),
              labelText: 'Data cadastro',
            ),
            const SizedBox(height: 12),
            CustomTextFormField(
              controller: widget.cnpjCpfController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.singleLineFormatter, FilteringTextInputFormatter.digitsOnly, CpfOuCnpjFormatter()],
              validator: (value) => combine([
                () => isNotEmpty(value),
                () => isCNPJCPFValid(value),
              ]),
              icon: const Icon(Icons.apartment),
              suffixIcon: IconButton(
                onPressed: () async {
                  FocusManager.instance.primaryFocus?.unfocus();
                  getCNPJFromField();
                },
                icon: const Icon(Icons.search_outlined),
              ),
              labelText: 'CNPJ / CPF',
            ),
            const SizedBox(height: 12),
            CustomTextFormField(
              controller: widget.razaoSocialNomeController,
              inputFormatters: [FilteringTextInputFormatter.singleLineFormatter, UpperCaseInputFormatter()],
              validator: isNotEmpty,
              icon: const Icon(null),
              labelText: 'Razão Social / Nome',
            ),
            const SizedBox(height: 12),
            CustomTextFormField(
              controller: widget.nomeFantasiaApelidoController,
              inputFormatters: [FilteringTextInputFormatter.singleLineFormatter, UpperCaseInputFormatter()],
              icon: const Icon(null),
              labelText: 'Nome Fantasia / Apelido',
            ),
            const SizedBox(height: 18),
            CustomTextFormField(
              controller: widget.telefoneController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.singleLineFormatter, FilteringTextInputFormatter.digitsOnly, TelefoneInputFormatter()],
              icon: const Icon(Icons.phone),
              labelText: 'Telefone',
            ),
            const SizedBox(height: 18),
            CustomTextFormField(
              controller: widget.emailController,
              keyboardType: TextInputType.emailAddress,
              inputFormatters: [FilteringTextInputFormatter.singleLineFormatter, LowerCaseInputFormatter()],
              icon: const Icon(Icons.mail),
              labelText: 'Email',
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 12),
            CustomTextFormField(
              controller: widget.cepController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.singleLineFormatter, FilteringTextInputFormatter.digitsOnly, CepInputFormatter()],
              suffixIcon: IconButton(
                  onPressed: () async {
                    FocusManager.instance.primaryFocus?.unfocus();
                    getCEPFromField();
                  },
                  icon: const Icon(Icons.search)),
              icon: const Icon(Icons.location_on),
              labelText: 'CEP',
            ),
            const SizedBox(height: 12),
            CustomTextFormField(
              controller: widget.logradouroController,
              inputFormatters: [FilteringTextInputFormatter.singleLineFormatter, UpperCaseInputFormatter()],
              icon: const Icon(null),
              labelText: 'Logradouro',
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: CustomTextFormField(
                    controller: widget.numeroController,
                    inputFormatters: [FilteringTextInputFormatter.singleLineFormatter, UpperCaseInputFormatter()],
                    icon: const Icon(null),
                    labelText: 'Número',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 3,
                  child: CustomTextFormField(
                    controller: widget.complementoController,
                    inputFormatters: [FilteringTextInputFormatter.singleLineFormatter, UpperCaseInputFormatter()],
                    labelText: 'Complemento',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            CustomTextFormField(
              controller: widget.bairroController,
              inputFormatters: [FilteringTextInputFormatter.singleLineFormatter, UpperCaseInputFormatter()],
              icon: const Icon(null),
              labelText: 'Bairro',
            ),
            const SizedBox(height: 12),
            CustomTextFormField(
              controller: widget.cidadeController,
              inputFormatters: [FilteringTextInputFormatter.singleLineFormatter, UpperCaseInputFormatter()],
              icon: const Icon(null),
              labelText: 'Cidade',
            ),
            const SizedBox(height: 12),
            CustomTextFormField(
              controller: widget.estadoController,
              inputFormatters: [FilteringTextInputFormatter.singleLineFormatter, UpperCaseInputFormatter()],
              icon: const Icon(null),
              labelText: 'Estado',
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(left: 12, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Contatos',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Novo'),
                    onPressed: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      adicionarContato();
                    },
                  )
                ],
              ),
            ),
            ...contatoFormsList()
          ],
        ),
      ),
    );
  }
}
