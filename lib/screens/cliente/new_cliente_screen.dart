import 'package:brasil_fields/brasil_fields.dart';
import 'package:easy_crm/models/cliente_model.dart';
import 'package:easy_crm/models/contato_model.dart';
import 'package:easy_crm/providers/clientes_provider.dart';
import 'package:easy_crm/widgets/custom_cliente_data_fields.dart';
import 'package:easy_crm/widgets/custom_contato_form.dart';
import 'package:easy_crm/widgets/error_dialog.dart';
import 'package:easy_crm/widgets/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewClienteScreen extends ConsumerStatefulWidget {
  const NewClienteScreen({super.key});

  @override
  ConsumerState<NewClienteScreen> createState() => _NewClienteScreenState();
}

class _NewClienteScreenState extends ConsumerState<NewClienteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dataCadastroController = TextEditingController(text: UtilData.obterDataDDMMAAAA(DateTime.now()));
  final _cnpjCpfController = TextEditingController();
  final _razaoSocialNomeController = TextEditingController();
  final _nomeFantasiaApelidoController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _cepController = TextEditingController();
  final _logradouroController = TextEditingController();
  final _numeroController = TextEditingController();
  final _complementoController = TextEditingController();
  final _bairroController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _estadoController = TextEditingController();

  final _contatoForms = <CustomContatoForm>[];

  @override
  void dispose() {
    _dataCadastroController.dispose();
    _cnpjCpfController.dispose();
    _razaoSocialNomeController.dispose();
    _nomeFantasiaApelidoController.dispose();
    _telefoneController.dispose();
    _emailController.dispose();
    _cepController.dispose();
    _logradouroController.dispose();
    _numeroController.dispose();
    _complementoController.dispose();
    _bairroController.dispose();
    _cidadeController.dispose();
    _estadoController.dispose();

    // Pra cada CustomContatoForm criado
    for (var form in _contatoForms) {
      form.cargoController.dispose();
      form.nomeController.dispose();
      form.telefoneController.dispose();
    }
    super.dispose();
  }

  Future<bool> saveNewCliente() async {
    if (await ref.read(clientesNotifierProvider.notifier).clienteAlreadyExists(_cnpjCpfController.text)) {
      if (!await ref.read(clientesNotifierProvider.notifier).isClienteActive(_cnpjCpfController.text)) {
        throw 'Cliente já cadastrado porém inativo. Realize a reativação';
      }
      throw 'Já existe um cliente cadastrado com o CPF/CNPJ informado!';
    } else {
      List<String> dateParts = _dataCadastroController.text.split('/');
      String formattedDate = '${dateParts[2]}-${dateParts[1]}-${dateParts[0]}';
      DateTime date = DateTime.parse(formattedDate);

      Cliente newCliente = Cliente(
        id: 0,
        ativo: 1,
        nomeRazao: _razaoSocialNomeController.text,
        apelidoFantasia: _nomeFantasiaApelidoController.text,
        cpfCnpj: _cnpjCpfController.text,
        telefone: _telefoneController.text,
        email: _emailController.text,
        dataCadastro: date.millisecondsSinceEpoch,
        cep: _cepController.text,
        estado: _estadoController.text,
        cidade: _cidadeController.text,
        bairro: _bairroController.text,
        endereco: _logradouroController.text,
        numero: _numeroController.text,
        complemento: _complementoController.text,
      );

      List<Contato> contatos = [];

      for (CustomContatoForm form in _contatoForms) {
        contatos.add(Contato(
          id: 0,
          clienteID: 0,
          nome: form.nomeController.text,
          cargo: form.cargoController.text,
          telefone: form.telefoneController.text,
        ));
      }

      newCliente.contatos = contatos;

      ref.read(clientesNotifierProvider.notifier).insertCliente(newCliente);

      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Novo cliente'),
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
                    await saveNewCliente();
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
          child: Column(
            children: [
              CustomClienteDataFields(
                formKey: _formKey,
                editableDataCadastro: true,
                dataCadastroController: _dataCadastroController,
                cnpjCpfController: _cnpjCpfController,
                razaoSocialNomeController: _razaoSocialNomeController,
                nomeFantasiaApelidoController: _nomeFantasiaApelidoController,
                telefoneController: _telefoneController,
                emailController: _emailController,
                cepController: _cepController,
                logradouroController: _logradouroController,
                numeroController: _numeroController,
                complementoController: _complementoController,
                bairroController: _bairroController,
                cidadeController: _cidadeController,
                estadoController: _estadoController,
                contatoForms: _contatoForms,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
