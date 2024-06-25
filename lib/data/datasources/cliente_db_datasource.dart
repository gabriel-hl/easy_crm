import 'package:easy_crm/models/cliente_model.dart';
import 'package:easy_crm/util/database_util.dart';
import 'package:sqflite/sqflite.dart';

class ClienteDBDataSource {
  final _clienteTableDB = 'cliente';

  // CREATE
  Future<int> insertCliente(Cliente cliente) async {
    try {
      Database db = await DB.instance.database;

      return await db.insert(_clienteTableDB, cliente.toJson());
    } catch (error) {
      throw error.toString();
    }
  }

  // READ
  Future<List<Cliente>> getActiveClientes() async {
    try {
      Database db = await DB.instance.database;
      List<Map<String, dynamic>> rawClientes = await db.query(_clienteTableDB, where: 'ativo = ?', whereArgs: [1], orderBy: 'nomeRazao ASC');

      if (rawClientes.isEmpty) return [];

      List<Cliente> clientes = rawClientes
          .map((cliente) => Cliente(
                id: cliente['id'],
                ativo: cliente['ativo'],
                nomeRazao: cliente['nomeRazao'],
                apelidoFantasia: cliente['apelidoFantasia'],
                cpfCnpj: cliente['cpfCnpj'],
                telefone: cliente['telefone'],
                email: cliente['email'],
                dataCadastro: cliente['dataCadastro'],
                cep: cliente['cep'],
                estado: cliente['estado'],
                cidade: cliente['cidade'],
                bairro: cliente['bairro'],
                endereco: cliente['endereco'],
                numero: cliente['numero'],
                complemento: cliente['complemento'],
              ))
          .toList();

      return clientes;
    } catch (error) {
      throw error.toString();
    }
  }

  // UPDATE
  Future<void> updateCliente(Cliente cliente) async {
    try {
      Database db = await DB.instance.database;

      await db.update(_clienteTableDB, cliente.toJson(), where: 'id = ?', whereArgs: [cliente.id]);
    } catch (error) {
      throw error.toString();
    }
  }

  // DELETE
  Future<void> deleteCliente(Cliente cliente) async {
    try {
      Database db = await DB.instance.database;

      await db.delete(_clienteTableDB, where: 'id = ?', whereArgs: [cliente.id]);
    } catch (error) {
      throw error.toString();
    }
  }

  // ============== OTHERS ==============

  Future<void> inactivateCliente(Cliente cliente) async {
    try {
      Database db = await DB.instance.database;

      await db.rawUpdate('UPDATE $_clienteTableDB SET ativo = ? WHERE id = ?', [0, cliente.id]);
    } catch (error) {
      throw error.toString();
    }
  }

  Future<void> activateCliente(Cliente cliente) async {
    try {
      Database db = await DB.instance.database;

      await db.rawUpdate('UPDATE $_clienteTableDB SET ativo = ? WHERE id = ?', [1, cliente.id]);
    } catch (error) {
      throw error.toString();
    }
  }

  Future<List<Cliente>> getInactiveClientes() async {
    try {
      Database db = await DB.instance.database;
      List<Map<String, dynamic>> rawClientes = await db.query(_clienteTableDB, where: 'ativo = ?', whereArgs: [0], orderBy: 'nomeRazao ASC');

      if (rawClientes.isEmpty) return [];

      List<Cliente> clientes = rawClientes
          .map((cliente) => Cliente(
                id: cliente['id'],
                ativo: cliente['ativo'],
                nomeRazao: cliente['nomeRazao'],
                apelidoFantasia: cliente['apelidoFantasia'],
                cpfCnpj: cliente['cpfCnpj'],
                telefone: cliente['telefone'],
                email: cliente['email'],
                dataCadastro: cliente['dataCadastro'],
                cep: cliente['cep'],
                estado: cliente['estado'],
                cidade: cliente['cidade'],
                bairro: cliente['bairro'],
                endereco: cliente['endereco'],
                numero: cliente['numero'],
                complemento: cliente['complemento'],
              ))
          .toList();

      return clientes;
    } catch (error) {
      throw error.toString();
    }
  }

  Future<bool> clienteAlreadyExists(String cpfCnpj) async {
    List<Map<String, dynamic>> result = [];

    try {
      Database db = await DB.instance.database;
      result = await db.query(_clienteTableDB, where: 'cpfCnpj = ?', whereArgs: [cpfCnpj]);
    } catch (e) {
      throw e.toString();
    }

    return result.isNotEmpty;
  }

  Future<bool> isClienteActive(String cpfCnpj) async {
    List<Map<String, dynamic>> result = [];

    try {
      Database db = await DB.instance.database;
      result = await db.query(_clienteTableDB, where: 'cpfCnpj = ? AND ativo = ?', whereArgs: [cpfCnpj, 1]);
    } catch (e) {
      throw e.toString();
    }

    return result.isNotEmpty;
  }

/*   Future<int> insertClienteFromJson(Map<String, dynamic> json) async {
    try {
      Database db = await DB.instance.database;

      return await db.insert(_clienteTableDB, json);
    } catch (error) {
      throw error.toString();
    }
  } */
}
