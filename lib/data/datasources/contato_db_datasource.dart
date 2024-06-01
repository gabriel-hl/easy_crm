import 'package:easy_crm/models/contato_model.dart';
import 'package:easy_crm/util/database_util.dart';
import 'package:sqflite/sqflite.dart';

class ContatoDBDataSource {
  final _contatoTableDB = 'contato';

  Future<void> insertContato(Contato contato) async {
    try {
      Database db = await DB.instance.database;

      await db.insert(_contatoTableDB, contato.toJson());
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

  Future<void> insertContatoFromJson(Map<String, dynamic> json) async {
    try {
      Database db = await DB.instance.database;

      await db.insert(_contatoTableDB, json);
    } catch (error) {
      throw error.toString();
    }
  }

  Future<void> updateContato(Contato contato) async {
    try {
      Database db = await DB.instance.database;

      await db.update(_contatoTableDB, contato.toJson(), where: 'id = ?', whereArgs: [contato.id]);
    } catch (error) {
      throw error.toString();
    }
  }

  Future<void> deleteContato(Contato contato) async {
    try {
      Database db = await DB.instance.database;

      await db.delete(_contatoTableDB, where: 'id = ?', whereArgs: [contato.id]);
    } catch (error) {
      throw error.toString();
    }
  }

  Future<List<Map<String, dynamic>>> getContatosByClienteID(int clienteID) async {
    try {
      Database db = await DB.instance.database;
      return await db.query(_contatoTableDB, where: 'cliente_id = ?', whereArgs: [clienteID]);
    } catch (error) {
      throw error.toString();
    }
  }
}
