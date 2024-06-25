import 'package:easy_crm/providers/inactive_clientes_provider.dart';
import 'package:easy_crm/providers/visitas_provider.dart';
import 'package:easy_crm/util/custom_icons.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:easy_crm/models/cliente_model.dart';
import 'package:easy_crm/models/contato_model.dart';
import 'package:easy_crm/util/launcher.dart';
import 'package:easy_crm/widgets/confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

class InactiveClienteScreen extends ConsumerStatefulWidget {
  const InactiveClienteScreen({super.key, required this.cliente});
  final Cliente cliente;

  @override
  ConsumerState<InactiveClienteScreen> createState() => _InactiveClienteScreenState();
}

class _InactiveClienteScreenState extends ConsumerState<InactiveClienteScreen> {
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
      color: Theme.of(context).colorScheme.surfaceVariant,
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
                      ).then((activateCliente) async {
                        if (activateCliente) {
                          await ref.read(inactiveClientesNotifierProvider.notifier).activateCliente(widget.cliente);
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
                          await ref.read(visitasNotifierProvider(widget.cliente.id).notifier).deleteVisitasByClienteID(widget.cliente.id);
                          await ref.read(inactiveClientesNotifierProvider.notifier).deleteCliente(widget.cliente);

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
