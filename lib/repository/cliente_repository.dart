import 'package:easy_crm/data/datasources/cliente_db_datasource.dart';
import 'package:easy_crm/data/datasources/contato_db_datasource.dart';
import 'package:easy_crm/models/cliente_model.dart';
import 'package:easy_crm/models/contato_model.dart';

class ClienteRepository {
  final ClienteDBDataSource clienteDataSource;
  final ContatoDBDataSource contatoDataSource;

  ClienteRepository({required this.clienteDataSource, required this.contatoDataSource});

  Future<int> insertCliente(Cliente cliente) async {
    int clienteID = await clienteDataSource.insertCliente(cliente);

    if (cliente.contatos?.isNotEmpty ?? false) {
      for (Contato contato in cliente.contatos!) {
        await contatoDataSource.insertContato(contato.copyWith(clienteID: clienteID));
      }
    }

    return clienteID;
  }

  Future<List<Cliente>> getActiveClientes() async {
    // Obtém os CLIENTES ativos

    List<Cliente> clientes = await clienteDataSource.getActiveClientes();

    if (clientes.isEmpty) return [];

    // Para cada cliente, obtém seus contatos e adiciona à lista de contatos do cliente
    for (Cliente cliente in clientes) {
      // Obtém a lista de contatos
      List<Contato> contatos = await contatoDataSource.getContatosByClienteID(cliente.id);

      if (contatos.isEmpty) continue;

      cliente.contatos = contatos;
    }

    return clientes;
  }

  Future<List<Cliente>> getInactiveClientes() async {
    List<Cliente> clientes = await clienteDataSource.getInactiveClientes();

    if (clientes.isEmpty) return [];

    for (Cliente cliente in clientes) {
      List<Contato> contatos = await contatoDataSource.getContatosByClienteID(cliente.id);

      if (contatos.isEmpty) continue;

      cliente.contatos = contatos;
    }

    return clientes;
  }

  Future<void> updateCliente(Cliente cliente) async {
    await clienteDataSource.updateCliente(cliente);
  }

  Future<void> inactivateCliente(Cliente cliente) async {
    await clienteDataSource.inactivateCliente(cliente);
  }

  Future<void> activateCliente(Cliente cliente) async {
    await clienteDataSource.activateCliente(cliente);
  }

  Future<void> deleteCliente(Cliente cliente) async {
    await contatoDataSource.deleteContatosByClienteID(cliente.id);
    await clienteDataSource.deleteCliente(cliente);
  }

  Future<bool> clienteAlreadyExists(String cpfCnpj) async {
    return await clienteDataSource.clienteAlreadyExists(cpfCnpj);
  }

  Future<bool> isClienteActive(String cpfCnpj) async {
    return await clienteDataSource.isClienteActive(cpfCnpj);
  }

  Future<int> deleteContatoByContatoID(int contatoID) async {
    return await contatoDataSource.deleteContatoByID(contatoID);
  }

  Future<int> insertContato(Contato contato) async {
    return await contatoDataSource.insertContato(contato);
  }

  Future<void> updateContato(Contato contato) async {
    await contatoDataSource.updateContato(contato);
  }

/*   Future<int> insertContatoFromJson(Map<String, dynamic> json) async {
    return await contatoDataSource.insertContatoFromJson(json);
  }

  

  Future<void> updateContatoByContatoID(int contatoID, Map<String, dynamic> json) async {
    await contatoDataSource.updateContatoByID(contatoID, json);
  }

  Future<int> insertClienteFromJson(Map<String, dynamic> json) async {
    return await clienteDataSource.insertClienteFromJson(json);
  } */
}
