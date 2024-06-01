import 'package:auto_size_text/auto_size_text.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:easy_crm/data/datasources/cliente_db_datasource.dart';
import 'package:easy_crm/data/datasources/contato_db_datasource.dart';
import 'package:easy_crm/data/datasources/visita_db_datasource.dart';
import 'package:easy_crm/models/cliente_model.dart';
import 'package:easy_crm/models/contato_model.dart';
import 'package:easy_crm/repository/cliente_repository.dart';
import 'package:easy_crm/repository/visita_repository.dart';
import 'package:easy_crm/util/launcher.dart';
import 'package:easy_crm/widgets/confirmation_dialog.dart';
import 'package:flutter/material.dart';

class InactiveClienteScreen extends StatefulWidget {
  const InactiveClienteScreen({super.key, required this.cliente});
  final Cliente cliente;

  @override
  State<InactiveClienteScreen> createState() => _InactiveClienteScreenState();
}

class _InactiveClienteScreenState extends State<InactiveClienteScreen> {
  Widget contatoTile(Contato contato) {
    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      title: AutoSizeText('${contato.nome}\n${contato.cargo}'),
      subtitle: Visibility(
        visible: contato.telefone?.isNotEmpty ?? false,
        child: AutoSizeText(contato.telefone!),
      ),
      trailing: PopupMenuButton(
        itemBuilder: (context) => [
          PopupMenuItem(
            onTap: () => Launcher.launchPhone(context, phone: contato.telefone),
            child: const Text('Ligar'),
          ),
          PopupMenuItem(
            onTap: () => Launcher.launchWhatsApp(context, phone: contato.telefone),
            child: const Text('Whatsapp'),
          ),
          const PopupMenuItem(
            // TODO: compartilhar
            //onTap: () => Launcher.launchWhatsApp(context, phone: widget.cliente.contatoTelefone),
            child: Text('Compartilhar'),
          ),
        ],
      ),
    );
  }

  Widget headerCliente() {
    return Material(
      borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
      elevation: 3,
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            CircleAvatar(
              radius: 70,
              backgroundColor: Theme.of(context).colorScheme.error,
              child: Text(
                widget.cliente.nomeRazao[0],
                style: TextStyle(fontSize: 60, color: Theme.of(context).colorScheme.onError),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: AutoSizeText(
                maxLines: 2,
                textAlign: TextAlign.center,
                widget.cliente.nomeRazao,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20, color: Theme.of(context).colorScheme.error),
              ),
            ),
            Visibility(
              visible: widget.cliente.apelidoFantasia?.isNotEmpty ?? false,
              child: Text(
                widget.cliente.apelidoFantasia ?? '',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            Text(
              'Cadastrado em ${UtilData.obterDataDDMMAAAA(DateTime.fromMillisecondsSinceEpoch(widget.cliente.dataCadastro))}',
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) => const ConfirmationDialog(title: 'Reativar cliente', dialog: 'Deseja reativar o cliente?'),
                      ).then((reactivateCliente) async {
                        if (reactivateCliente) {
                          var clienteRepo = ClienteRepository(clienteDataSource: ClienteDBDataSource(), contatoDataSource: ContatoDBDataSource());

                          await clienteRepo.activateCliente(widget.cliente);

                          if (context.mounted) Navigator.of(context).pop();
                        }
                      });
                    });
                  },
                  child: const Text('Reativar'),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () async {
                    setState(() {
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) => const ConfirmationDialog(title: 'Excluir cliente', dialog: 'Deseja excluir permanentemente o cliente e suas visitas?'),
                      ).then((deleteCliente) async {
                        if (deleteCliente) {
                          var clienteRepo = ClienteRepository(clienteDataSource: ClienteDBDataSource(), contatoDataSource: ContatoDBDataSource());
                          var visitasRepo = VisitaRepository(VisitaDBDataSource());

                          await visitasRepo.deleteVisitasByClienteID(widget.cliente.id);
                          await clienteRepo.deleteCliente(widget.cliente);

                          if (context.mounted) Navigator.of(context).pop();
                        }
                      });
                    });
                  },
                  icon: Icon(
                    Icons.delete_forever_outlined,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  label: Text(
                    'Excluir',
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget dataCliente(FocusNode focusNode) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Material(
          elevation: 2,
          borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
          child: ListTile(
            leading: const Icon(Icons.apartment_outlined),
            title: const Text(
              'CNPJ/CPF',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: Text(widget.cliente.cpfCnpj),
          ),
        ),
        const SizedBox(height: 8),
        Visibility(
          visible: widget.cliente.telefone?.isNotEmpty ?? false,
          child: Material(
            elevation: 2,
            borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
            child: ListTile(
              leading: InkWell(
                child: const Icon(Icons.phone_outlined),
                onTap: () => Launcher.launchPhone(context, phone: widget.cliente.telefone),
              ),
              trailing: InkWell(
                child: const Icon(Icons.textsms_outlined),
                onTap: () => Launcher.launchWhatsApp(context, phone: widget.cliente.telefone),
              ),
              title: const Text('Telefone', style: TextStyle(fontWeight: FontWeight.w500)),
              subtitle: Text(widget.cliente.telefone ?? ''),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Visibility(
          visible: widget.cliente.email?.isNotEmpty ?? false,
          child: Material(
            elevation: 2,
            borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
            child: ListTile(
              leading: InkWell(
                onTap: () => Launcher.launchEmail(context, email: widget.cliente.email),
                child: const Icon(Icons.mail_outlined),
              ),
              title: const Text('Email', style: TextStyle(fontWeight: FontWeight.w500)),
              subtitle: Text(widget.cliente.email ?? ''),
            ),
          ),
        )
      ],
    );
  }

  Widget contatoCliente() {
    return SizedBox(
      width: double.infinity,
      child: Visibility(
        visible: widget.cliente.contatos?.isNotEmpty ?? false,
        //visible: widget.cliente.contatoPessoa?.isNotEmpty ?? false,
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Card(
              margin: const EdgeInsets.all(8),
              elevation: 0,
              color: Theme.of(context).colorScheme.surfaceVariant,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const Text('Dados do contato', style: TextStyle(fontWeight: FontWeight.bold)),
                    for (Contato contato in widget.cliente.contatos!) contatoTile(contato),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget enderecoCliente(FocusNode focusNode) {
    String endereco = '';

    if (widget.cliente.endereco?.isNotEmpty ?? false) endereco += widget.cliente.endereco!;
    if (widget.cliente.numero?.isNotEmpty ?? false) endereco += ', ${widget.cliente.numero!}';
    if (widget.cliente.complemento?.isNotEmpty ?? false) endereco += ', ${widget.cliente.complemento!}';
    if (widget.cliente.cidade?.isNotEmpty ?? false) endereco += '\n${widget.cliente.cidade!}';
    if (widget.cliente.estado?.isNotEmpty ?? false) endereco += '/${widget.cliente.estado!}';
    if (widget.cliente.cep?.isNotEmpty ?? false) endereco += '\nCEP: ${widget.cliente.cep!}';

    return Visibility(
      visible: widget.cliente.endereco?.isNotEmpty ?? false,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Container(
          width: double.infinity,
          height: 120,
          margin: const EdgeInsets.only(top: 6.0),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(15.0)),
            color: Theme.of(context).colorScheme.surface,
            //color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Theme.of(context).colorScheme.shadow,
                  offset: const Offset(0, 1), //(x,y)
                  blurRadius: 3.0),
            ],
          ),
          child: ListTile(
            leading: InkWell(
              onTap: () => Launcher.launchMap(
                context,
                endereco: widget.cliente.endereco,
                numero: widget.cliente.numero,
                cidade: widget.cliente.cidade,
                estado: widget.cliente.estado,
              ),
              child: const Icon(Icons.location_on_outlined),
            ),
            title: const Text('Endereço', style: TextStyle(fontWeight: FontWeight.w500)),
            subtitle: Text(endereco),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    FocusNode focusNode = FocusNode();

    return SelectionArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
          title: Text(
            'Cliente Inativo',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              headerCliente(),
              const SizedBox(height: 5),
              dataCliente(focusNode),
              const SizedBox(height: 5),
              contatoCliente(),
              Align(
                alignment: Alignment.bottomLeft,
                child: enderecoCliente(focusNode),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
