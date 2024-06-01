import 'package:easy_crm/models/cliente_model.dart';

abstract class FilterClientes {
  static List<Cliente> filter({required List<Cliente> clientes, required String text}) {
    String filter = text.trim().toUpperCase();

    List<Cliente> filteredClientes = clientes.where((cliente) {
      return cliente.nomeRazao.toUpperCase().contains(filter) ||
          (cliente.apelidoFantasia?.toUpperCase().contains(filter) ?? false) ||
          (cliente.cidade?.toUpperCase().contains(filter) ?? false);
    }).toList();

    return filteredClientes;
  }
}
