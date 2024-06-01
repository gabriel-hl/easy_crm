import 'package:easy_crm/data/datasources/cliente_db_datasource.dart';
import 'package:easy_crm/data/datasources/contato_db_datasource.dart';
import 'package:easy_crm/models/cliente_model.dart';
import 'package:easy_crm/models/contato_model.dart';

class ClienteRepository {
  final ClienteDBDataSource clienteDataSource;
  final ContatoDBDataSource contatoDataSource;

  ClienteRepository({required this.clienteDataSource, required this.contatoDataSource});

  Future<void> insertClienteFromJson(Map<String, dynamic> json) async {
    await clienteDataSource.insertClienteFromJson(json);
  }

  Future<void> insertCliente(Cliente cliente) async {
    await clienteDataSource.insertCliente(cliente);
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
    await clienteDataSource.deleteCliente(cliente);
  }

  Future<List<Cliente>> getActiveClientes() async {
    // Obtém os CLIENTES ativos
    List<Map<String, dynamic>> rawClientes = await clienteDataSource.getActiveClientes();

    if (rawClientes.isEmpty) return [];

    // Converte os mapas (resultado da consulta no Sqlite) em objetos CLIENTE
    List<Cliente> clientes = rawClientes.map((rawCliente) => Cliente.fromJSON(rawCliente)).toList();

    // Para cada cliente, obtém seus contatos e adiciona à lista de contatos do cliente
    for (Cliente cliente in clientes) {
      // Obtém a lista de contatos
      List<Map<String, dynamic>> rawContatos = await contatoDataSource.getContatosByClienteID(cliente.id);
      if (rawContatos.isEmpty) continue;

      cliente.contatos = rawContatos.map((rawContato) => Contato.fromJson(rawContato)).toList();
    }

    return clientes;
  }

  Future<List<Cliente>> getInactiveClientes() async {
    List<Map<String, dynamic>> rawClientes = await clienteDataSource.getInactiveClientes();

    if (rawClientes.isEmpty) return [];

    List<Cliente> clientes = rawClientes.map((rawCliente) => Cliente.fromJSON(rawCliente)).toList();

    for (Cliente cliente in clientes) {
      List<Map<String, dynamic>> rawContatos = await contatoDataSource.getContatosByClienteID(cliente.id);
      if (rawContatos.isEmpty) continue;

      cliente.contatos = rawContatos.map((rawContato) => Contato.fromJson(rawContato)).toList();
    }

    return clientes;
  }

  Future<bool> clienteAlreadyExists(String cpfCnpj) async {
    return await clienteDataSource.clienteAlreadyExists(cpfCnpj);
  }

  Future<bool> isClienteActive(String cpfCnpj) async {
    return await clienteDataSource.isClienteActive(cpfCnpj);
  }
}
