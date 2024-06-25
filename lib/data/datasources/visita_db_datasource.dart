import 'package:easy_crm/models/visita_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:easy_crm/util/database_util.dart';

class VisitaDBDataSource {
  final _visitaTableDB = 'visita';

  Future<void> insertVisita(Visita visita) async {
    try {
      Database db = await DB.instance.database;
      await db.insert(_visitaTableDB, visita.toJson());
    } catch (error) {
      throw error.toString();
    }
  }

  Future<void> insertVisitaFromJson(Map<String, dynamic> json) async {
    try {
      Database db = await DB.instance.database;
      await db.insert(_visitaTableDB, json);
    } catch (error) {
      throw error.toString();
    }
  }

  Future<void> updateVisita(Visita visita) async {
    try {
      Database db = await DB.instance.database;

      await db.update(_visitaTableDB, visita.toJson(), where: 'id = ?', whereArgs: [visita.id]);
    } catch (error) {
      throw error.toString();
    }
  }

  Future<int> deleteVisitaByID(int id) async {
    try {
      Database db = await DB.instance.database;

      return await db.delete(_visitaTableDB, where: 'id = ?', whereArgs: [id]);
    } catch (error) {
      throw error.toString();
    }
  }

  Future<void> deleteVisitasByClienteID(int clienteID) async {
    try {
      Database db = await DB.instance.database;

      await db.delete(_visitaTableDB, where: 'cliente_id = ?', whereArgs: [clienteID]);
    } catch (error) {
      throw error.toString();
    }
  }

  Future<List<Map<String, dynamic>>> getVisitasByClienteID(int clienteID) async {
    try {
      Database db = await DB.instance.database;
      return await db.query(_visitaTableDB, where: 'cliente_id = ?', whereArgs: [clienteID], orderBy: 'data DESC, id DESC');
    } catch (error) {
      throw error.toString();
    }
  }
}
