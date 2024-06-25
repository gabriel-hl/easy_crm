import 'package:easy_crm/models/cliente_model.dart';
import 'package:easy_crm/providers/inactive_clientes_provider.dart';
import 'package:easy_crm/screens/inactive_cliente/inactive_cliente_screen.dart';
import 'package:easy_crm/util/filter_clientes.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class InactiveClientesHomeScreen extends ConsumerStatefulWidget {
  const InactiveClientesHomeScreen({super.key});

  @override
  ConsumerState<InactiveClientesHomeScreen> createState() => _InactiveClientesHomeScreenState();
}

class _InactiveClientesHomeScreenState extends ConsumerState<InactiveClientesHomeScreen> {
  final searchController = TextEditingController();

  Widget clienteList(List<Cliente> clientes) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        searchField(searchController),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.builder(
            itemBuilder: (context, index) {
              String subtitle = '';

              if (clientes[index].apelidoFantasia?.isNotEmpty ?? false) subtitle = '${clientes[index].apelidoFantasia!}\n';

              if (clientes[index].endereco?.isNotEmpty ?? false) subtitle += clientes[index].endereco!;
              if (clientes[index].numero?.isNotEmpty ?? false) subtitle += ', ${clientes[index].numero!}';
              if (clientes[index].complemento?.isNotEmpty ?? false) subtitle += ', ${clientes[index].complemento!}';
              if (clientes[index].cidade?.isNotEmpty ?? false) subtitle += ', ${clientes[index].cidade!}';
              if (clientes[index].estado?.isNotEmpty ?? false) subtitle += '/${clientes[index].estado!}';

              return ListTile(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PopScope(
                      onPopInvoked: (_) => setState(() {
                        // ignore: unused_result
                        ref.refresh(inactiveClientesNotifierProvider);
                      }),
                      child: InactiveClienteScreen(
                        cliente: clientes[index],
                      ),
                    ),
                  ),
                ),
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  child: Text(
                    clientes[index].nomeRazao[0],
                    style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                  ),
                ),
                title: Text(
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.fade,
                  clientes[index].nomeRazao,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: subtitle.isNotEmpty ? Text(subtitle) : null,
              );
            },
            itemCount: clientes.length,
          ),
        ),
      ],
    );
  }

// Campo de pesquisa de clientes.
  TextField searchField(TextEditingController searchController) {
    return TextField(
      controller: searchController,
      onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      onChanged: (search) {
        setState(() {});
      },
      decoration: InputDecoration(
        hintText: 'Localizar cliente inativo...',
        prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.error),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              searchController.clear();
            });
          },
          icon: const Icon(Icons.close),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 2,
            color: Theme.of(context).colorScheme.errorContainer,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: Theme.of(context).colorScheme.surfaceVariant),
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    AsyncValue<List<Cliente>> inactiveClientes = ref.watch(inactiveClientesNotifierProvider);

    return Scaffold(
      //backgroundColor: Theme.of(context).colorScheme.seconde,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Clientes Inativos',
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: inactiveClientes.when(
          skipLoadingOnRefresh: false,
          data: (activeClientes) {
            return activeClientes.isEmpty
                ? const Center(
                    child: Text(
                      'Não há clientes inativados',
                      textAlign: TextAlign.center,
                    ),
                  )
                : clienteList(FilterClientes.filter(clientes: activeClientes, text: searchController.text));
          },
          error: (error, stackTrace) {
            return Center(
              child: Column(
                children: [
                  TextButton.icon(
                      onPressed: () {
                        inactiveClientes = ref.refresh(inactiveClientesNotifierProvider);
                      },
                      icon: const Icon(Icons.restart_alt),
                      label: const Text('Recarregar')),
                  const SizedBox(height: 18),
                  Text(
                    'Erro ao carregar clientes',
                    style: TextStyle(fontSize: 18, color: Theme.of(context).colorScheme.error, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 18),
                  Text(error.toString()),
                  SingleChildScrollView(child: Text(stackTrace.toString()))
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
