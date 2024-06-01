import 'package:auto_size_text/auto_size_text.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:easy_crm/data/datasources/cliente_db_datasource.dart';
import 'package:easy_crm/data/datasources/contato_db_datasource.dart';
import 'package:easy_crm/models/cliente_model.dart';
import 'package:easy_crm/models/contato_model.dart';
import 'package:easy_crm/repository/cliente_repository.dart';
import 'package:easy_crm/screens/cliente/edit_cliente_screen.dart';
import 'package:easy_crm/screens/visitas/visitas_screen.dart';
import 'package:easy_crm/util/custom_icons.dart';
import 'package:easy_crm/util/launcher.dart';
import 'package:easy_crm/widgets/confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ClienteScreen extends StatefulWidget {
  const ClienteScreen({super.key, required this.cliente});
  final Cliente cliente;

  @override
  State<ClienteScreen> createState() => _ClienteScreenState();
}

class _ClienteScreenState extends State<ClienteScreen> {
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
      color: Theme.of(context).colorScheme.primaryContainer,
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            CircleAvatar(
              radius: 70,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Text(
                widget.cliente.nomeRazao[0],
                style: TextStyle(fontSize: 60, color: Theme.of(context).colorScheme.onPrimary),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: AutoSizeText(
                maxLines: 2,
                textAlign: TextAlign.center,
                widget.cliente.nomeRazao,
                style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
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
                TextButton.icon(
                  onPressed: () => Launcher.launchPhone(context, phone: widget.cliente.telefone),
                  //onPressed: () => launchPhone(widget.cliente.telefone),
                  icon: const Icon(Icons.call),
                  label: const Text('Ligar'),
                ),
                TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => VisitasScreen(clienteID: widget.cliente.id),
                      ),
                    );
                  },
                  icon: const Icon(Icons.tour),
                  label: const Text('Visitas'),
                ),
                TextButton.icon(
                  onPressed: () => Launcher.launchMap(
                    context,
                    endereco: widget.cliente.endereco,
                    numero: widget.cliente.numero,
                    cidade: widget.cliente.cidade,
                    estado: widget.cliente.estado,
                  ),
                  icon: const Icon(Icons.map),
                  label: const Text('Mapa'),
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
                child: const Icon(CustomIcons.whatsapp),
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
        ),
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
              color: Theme.of(context).colorScheme.secondaryContainer,
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
      child: Material(
        elevation: 2,
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
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
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PopScope(
                            onPopInvoked: (_) => setState(() {}),
                            child: EditClientScreen(
                              cliente: widget.cliente,
                            ),
                          )));
                },
                icon: const Icon(Icons.edit_outlined)),
            PopupMenuButton(
              itemBuilder: (context) => [
                /* PopupMenuItem(
                  onTap: () {
                    // TODO: implementar copiar dados
                  },
                  child: const Text('Copiar dados'),
                ), */
                PopupMenuItem(
                  onTap: () {
                    // TODO: implementar inativar
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) => const ConfirmationDialog(title: 'Inativar cliente', dialog: 'Deseja inativar o cliente?'),
                    ).then((inactivateCliente) async {
                      if (inactivateCliente) {
                        var clienteRepo = ClienteRepository(clienteDataSource: ClienteDBDataSource(), contatoDataSource: ContatoDBDataSource());

                        await clienteRepo.inactivateCliente(widget.cliente);
                        if (context.mounted) Navigator.of(context).pop();
                      }
                    });
                  },
                  child: Text(
                    'Inativar',
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                ),
              ],
            ),
          ],
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
              enderecoCliente(focusNode),
              const SizedBox(height: 5),
              contatoCliente(),
            ],
          ),
        ),
      ),
    );
  }
}
