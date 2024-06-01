import 'package:easy_crm/models/cliente_model.dart';
import 'package:easy_crm/util/database_util.dart';
import 'package:sqflite/sqflite.dart';

class ClienteDBDataSource {
  final _clienteTableDB = 'cliente';

  Future<void> insertCliente(Cliente cliente) async {
    try {
      Database db = await DB.instance.database;

      await db.insert(_clienteTableDB, cliente.toJson());
    } catch (error) {
      throw error.toString();
    }
  }

  Future<void> insertClienteFromJson(Map<String, dynamic> json) async {
    try {
      Database db = await DB.instance.database;

      await db.insert(_clienteTableDB, json);
    } catch (error) {
      throw error.toString();
    }
  }

  Future<void> updateCliente(Cliente cliente) async {
    try {
      Database db = await DB.instance.database;

      await db.update(_clienteTableDB, cliente.toJson(), where: 'id = ?', whereArgs: [cliente.id]);
    } catch (error) {
      throw error.toString();
    }
  }

  Future<void> deleteCliente(Cliente cliente) async {
    try {
      Database db = await DB.instance.database;

      await db.delete(_clienteTableDB, where: 'id = ?', whereArgs: [cliente.id]);
    } catch (error) {
      throw error.toString();
    }
  }

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

  Future<List<Map<String, dynamic>>> getActiveClientes() async {
    try {
      Database db = await DB.instance.database;
      return await db.query(_clienteTableDB, where: 'ativo = ?', whereArgs: [1], orderBy: 'nomeRazao ASC');
    } catch (error) {
      throw error.toString();
    }
  }

  Future<List<Map<String, dynamic>>> getInactiveClientes() async {
    try {
      Database db = await DB.instance.database;
      return await db.query(_clienteTableDB, where: 'ativo = ?', whereArgs: [0], orderBy: 'nomeRazao ASC');
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
}
