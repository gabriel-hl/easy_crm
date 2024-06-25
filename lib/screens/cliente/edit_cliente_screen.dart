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

class EditClientScreen extends ConsumerStatefulWidget {
  const EditClientScreen({super.key, required this.cliente});

  final Cliente cliente;

  @override
  ConsumerState<EditClientScreen> createState() => _EditClientScreenState();
}

class _EditClientScreenState extends ConsumerState<EditClientScreen> {
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
  final _contatoForms = <CustomContatoForm>[];

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

    if (widget.cliente.contatos?.isNotEmpty ?? false) {
      for (var contato in widget.cliente.contatos!) {
        _contatoForms.add(CustomContatoForm(
          contatoID: contato.id,
          nomeController: TextEditingController(text: contato.nome),
          cargoController: TextEditingController(text: contato.cargo),
          telefoneController: TextEditingController(text: contato.telefone),
        ));
      }
    }
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
    // Pra cada CustomContatoForm criado
    for (var form in _contatoForms) {
      form.cargoController.dispose();
      form.nomeController.dispose();
      form.telefoneController.dispose();
    }
    super.dispose();
  }

  Future<bool> saveCliente() async {
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

    List<int> idsToRemove = [];

    // Deletar contatos que foram removidos
    // verifica se a lista "original" de contatos não é vazia ou nula
    if (widget.cliente.contatos?.isNotEmpty ?? false) {
      // pra cada contato "original" na lista...
      for (var contatoOriginal in widget.cliente.contatos!) {
        // pra cada formulário em _contatoForms...
        // isso aqui é 'basicamente' um for loop dentro de um for loop
        if (!_contatoForms.any((form) => form.contatoID == contatoOriginal.id)) {
          // se nos formulários não tiver nenhum contato com o ID da interação contatoOriginal.id,
          // significa que o usuário excluiu o formulário do contato com intenção de excluí-lo
          idsToRemove.add(contatoOriginal.id);
        }
      }

      for (var id in idsToRemove) {
        await ref.read(clientesNotifierProvider.notifier).deleteContatoByID(id);
        widget.cliente.contatos!.removeWhere((contato) => contato.id == id);
      }
    }

    // Atualizar ou inserir contato
    for (var form in _contatoForms) {
      Contato contato = Contato(
        id: form.contatoID,
        clienteID: widget.cliente.id,
        nome: form.nomeController.text,
        cargo: form.cargoController.text,
        telefone: form.telefoneController.text,
      );

      if (contato.id == 0) {
        // Insere novo contato
        int newContatoID = await ref.read(clientesNotifierProvider.notifier).insertContato(contato);

        widget.cliente.contatos ??= [];
        widget.cliente.contatos!.add(contato.copyWith(id: newContatoID));
      } else {
        // Atualiza o contato existente
        await ref.read(clientesNotifierProvider.notifier).updateContato(contato);
        widget.cliente.contatos![widget.cliente.contatos!.indexWhere((oldContato) => oldContato.id == contato.id)] = contato;
      }
    }

    await ref.read(clientesNotifierProvider.notifier).updateCliente(widget.cliente);

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
            contatoForms: _contatoForms,
          ),
        ),
      ),
    );
  }
}
