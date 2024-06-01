import 'package:brasil_fields/brasil_fields.dart';
import 'package:easy_crm/data/datasources/cliente_db_datasource.dart';
import 'package:easy_crm/data/datasources/contato_db_datasource.dart';
import 'package:easy_crm/models/cliente_model.dart';
import 'package:easy_crm/repository/cliente_repository.dart';
import 'package:easy_crm/widgets/custom_cliente_data_fields.dart';
import 'package:easy_crm/widgets/error_dialog.dart';
import 'package:easy_crm/widgets/loading_dialog.dart';
import 'package:flutter/material.dart';

class EditClientScreen extends StatefulWidget {
  const EditClientScreen({super.key, required this.cliente});

  final Cliente cliente;

  @override
  State<EditClientScreen> createState() => _EditClientScreenState();
}

class _EditClientScreenState extends State<EditClientScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dataCadastroController = TextEditingController();
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

  @override
  void initState() {
    super.initState();
    _dataCadastroController.text = UtilData.obterDataDDMMAAAA(DateTime.fromMillisecondsSinceEpoch(widget.cliente.dataCadastro));
    _cnpjCpfController.text = widget.cliente.cpfCnpj;
    _razaoSocialNomeController.text = widget.cliente.nomeRazao;
    _nomeFantasiaApelidoController.text = widget.cliente.apelidoFantasia ?? '';
    _telefoneController.text = widget.cliente.telefone ?? '';
    _emailController.text = widget.cliente.email ?? '';
    _cepController.text = widget.cliente.cep ?? '';
    _logradouroController.text = widget.cliente.endereco ?? '';
    _numeroController.text = widget.cliente.numero ?? '';
    _complementoController.text = widget.cliente.complemento ?? '';
    _bairroController.text = widget.cliente.bairro ?? '';
    _cidadeController.text = widget.cliente.cidade ?? '';
    _estadoController.text = widget.cliente.estado ?? '';
  }

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
    super.dispose();
  }

  Future<bool> saveCliente() async {
    var clienteRepo = ClienteRepository(clienteDataSource: ClienteDBDataSource(), contatoDataSource: ContatoDBDataSource());

    widget.cliente.nomeRazao = _razaoSocialNomeController.text;
    widget.cliente.apelidoFantasia = _nomeFantasiaApelidoController.text;
    widget.cliente.cpfCnpj = _cnpjCpfController.text;
    widget.cliente.telefone = _telefoneController.text;
    widget.cliente.email = _emailController.text;
    widget.cliente.cep = _cepController.text;
    widget.cliente.estado = _estadoController.text;
    widget.cliente.cidade = _cidadeController.text;
    widget.cliente.bairro = _bairroController.text;
    widget.cliente.endereco = _logradouroController.text;
    widget.cliente.numero = _numeroController.text;
    widget.cliente.complemento = _complementoController.text;

    await clienteRepo.updateCliente(widget.cliente);

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Editando cliente'),
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
                    await saveCliente();
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
          child: CustomClienteDataFields(
            formKey: _formKey,
            editableDataCadastro: false,
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
          ),
        ),
      ),
    );
  }
}
