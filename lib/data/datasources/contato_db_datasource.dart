import 'package:easy_crm/models/contato_model.dart';
import 'package:easy_crm/util/database_util.dart';
import 'package:sqflite/sqflite.dart';

class ContatoDBDataSource {
  final _contatoTableDB = 'contato';

  // CREATE
  Future<int> insertContato(Contato contato) async {
    try {
      Database db = await DB.instance.database;

      return await db.insert(_contatoTableDB, contato.toJson());
    } catch (error) {
      throw error.toString();
    }
  }

  Future<void> insertContatos(List<Contato> contatos) async {
    try {
      Database db = await DB.instance.database;

      for (Contato contato in contatos) {
        await db.insert(_contatoTableDB, contato.toJson());
      }
    } catch (error) {
      throw error.toString();
    }
  }

  // READ
  Future<List<Contato>> getContatosByClienteID(int clienteID) async {
    try {
      Database db = await DB.instance.database;
      List<Map<String, dynamic>> rawContatos = await db.query(_contatoTableDB, where: 'cliente_id = ?', whereArgs: [clienteID]);

      if (rawContatos.isEmpty) return [];

      List<Contato> contatos = rawContatos
          .map((rawContato) => Contato(
                id: rawContato['id'],
                clienteID: rawContato['cliente_id'],
                nome: rawContato['nome'],
                cargo: rawContato['cargo'],
                telefone: rawContato['telefone'],
              ))
          .toList();

      return contatos;
    } catch (error) {
      throw error.toString();
    }
  }

  // UPDATE
  Future<void> updateContato(Contato contato) async {
    try {
      Database db = await DB.instance.database;

      await db.update(_contatoTableDB, contato.toJson(), where: 'id = ?', whereArgs: [contato.id]);
    } catch (error) {
      throw error.toString();
    }
  }

  // DELETE
  Future<int> deleteContato(Contato contato) async {
    try {
      Database db = await DB.instance.database;

      return await db.delete(_contatoTableDB, where: 'id = ?', whereArgs: [contato.id]);
    } catch (error) {
      throw error.toString();
    }
  }

  Future<void> deleteContatosByClienteID(int clienteID) async {
    try {
      Database db = await DB.instance.database;

      await db.delete(_contatoTableDB, where: 'cliente_id = ?', whereArgs: [clienteID]);
    } catch (error) {
      throw error.toString();
    }
  }

  Future<int> deleteContatoByID(int id) async {
    try {
      Database db = await DB.instance.database;

      return await db.delete(_contatoTableDB, where: 'id = ?', whereArgs: [id]);
    } catch (error) {
      throw error.toString();
    }
  }

  // ============== OTHERS ==============

/*   Future<int> insertContatoFromJson(Map<String, dynamic> json) async {
    try {
      Database db = await DB.instance.database;

      return await db.insert(_contatoTableDB, json);
    } catch (error) {
      throw error.toString();
    }
  } */

/*   Future<void> updateContatoByID(int id, Map<String, dynamic> json) async {
    try {
      Database db = await DB.instance.database;

      await db.update(_contatoTableDB, json, where: 'id = ?', whereArgs: [id]);
    } catch (error) {
      throw error.toString();
    }
  }
 */
}
