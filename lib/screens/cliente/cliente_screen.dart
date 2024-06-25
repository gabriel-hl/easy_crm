import 'package:auto_size_text/auto_size_text.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:easy_crm/models/cliente_model.dart';
import 'package:easy_crm/models/contato_model.dart';
import 'package:easy_crm/providers/clientes_provider.dart';
import 'package:easy_crm/screens/cliente/edit_cliente_screen.dart';
import 'package:easy_crm/screens/visitas/visitas_screen.dart';
import 'package:easy_crm/util/custom_icons.dart';
import 'package:easy_crm/util/launcher.dart';
import 'package:easy_crm/widgets/confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

class ClienteScreen extends ConsumerStatefulWidget {
  const ClienteScreen({super.key, required this.cliente});
  final Cliente cliente;

  @override
  ConsumerState<ClienteScreen> createState() => _ClienteScreenState();
}

class _ClienteScreenState extends ConsumerState<ClienteScreen> {
  String shareDataCliente() {
    String result = '';
    String endereco = '';

    if (widget.cliente.endereco?.isNotEmpty ?? false) endereco += widget.cliente.endereco!;
    if (widget.cliente.numero?.isNotEmpty ?? false) endereco += ', ${widget.cliente.numero!}';
    if (widget.cliente.complemento?.isNotEmpty ?? false) endereco += ', ${widget.cliente.complemento!}';
    if (widget.cliente.cidade?.isNotEmpty ?? false) endereco += '\n${widget.cliente.cidade!}';
    if (widget.cliente.estado?.isNotEmpty ?? false) endereco += '/${widget.cliente.estado!}';
    if (widget.cliente.cep?.isNotEmpty ?? false) endereco += '\nCEP: ${widget.cliente.cep!}';

    result += '${widget.cliente.nomeRazao} - ${widget.cliente.apelidoFantasia}';
    result += '\nCNPJ/CPF: ${widget.cliente.cpfCnpj}';
    result += '\n\nTelefone: ${widget.cliente.telefone}';
    result += '\nEmail: ${widget.cliente.email}';
    result += '\n\nEndereço: $endereco';

    return result;
  }

  Widget contatoTile(Contato contato) {
    RichText title = RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.titleMedium,
        text: contato.nome,
        children: [
          if (contato.cargo?.isNotEmpty ?? false)
            TextSpan(
              text: '\n${contato.cargo}',
              style: Theme.of(context).textTheme.labelMedium,
            ),
        ],
      ),
    );

    return Material(
      color: Theme.of(context).colorScheme.secondaryContainer,
      elevation: 2,
      borderRadius: const BorderRadius.all(Radius.circular(15)),
      child: ListTile(
        contentPadding: const EdgeInsets.only(left: 10, top: 2, bottom: 2),
        title: title,
        subtitle: Visibility(
          visible: contato.telefone?.isNotEmpty ?? false,
          child: AutoSizeText(contato.telefone!),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(visualDensity: VisualDensity.compact, onPressed: () => Launcher.launchPhone(context, phone: contato.telefone), icon: const Icon(Icons.phone_enabled)),
            IconButton(visualDensity: VisualDensity.compact, onPressed: () => Launcher.launchWhatsApp(context, phone: contato.telefone), icon: const Icon(CustomIcons.whatsapp)),
            IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: () => Share.share('Contato: ${contato.nome}\nCargo: ${contato.cargo}\nTelefone: ${contato.telefone}', subject: 'Dados do contato ${contato.nome}'),
                icon: const Icon(Icons.share_outlined)),
          ],
        ),
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
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Material(
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
        ),
        Visibility(
          visible: widget.cliente.telefone?.isNotEmpty ?? false,
          child: Padding(
            padding: const EdgeInsets.only(top: 4.0),
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
        ),
        Visibility(
          visible: widget.cliente.email?.isNotEmpty ?? false,
          child: Padding(
            padding: const EdgeInsets.only(top: 4.0),
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
        ),
      ],
    );
  }

  Widget contatoCliente() {
    return SizedBox(
      width: double.infinity,
      child: Visibility(
        visible: widget.cliente.contatos?.isNotEmpty ?? false,
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              elevation: 0,
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 12),
                      child: Text('Contatos', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    if (widget.cliente.contatos != null && widget.cliente.contatos!.isNotEmpty)
                      for (Contato contato in widget.cliente.contatos!.reversed)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: contatoTile(contato),
                        ),
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
      child: Padding(
        padding: const EdgeInsets.only(top: 4.0),
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
                            onPopInvoked: (_) {
                              setState(() {});
                            },
                            child: EditClientScreen(
                              cliente: widget.cliente,
                            ),
                          )));
                },
                icon: const Icon(Icons.edit_outlined)),
            PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  onTap: () => Share.share(shareDataCliente(), subject: 'Dados do cliente ${widget.cliente.nomeRazao}'),
                  child: const Text('Compartilhar'),
                ),
                PopupMenuItem(
                  onTap: () {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) => const ConfirmationDialog(title: 'Inativar cliente', dialog: 'Deseja inativar o cliente?'),
                    ).then((inactivateCliente) async {
                      if (inactivateCliente) {
                        await ref.read(clientesNotifierProvider.notifier).inactivateCliente(widget.cliente);

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
              dataCliente(focusNode),
              enderecoCliente(focusNode),
              contatoCliente(),
            ],
          ),
        ),
      ),
    );
  }
}
