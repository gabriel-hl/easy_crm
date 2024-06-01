import 'package:easy_crm/data/datasources/visita_db_datasource.dart';
import 'package:easy_crm/models/visita_model.dart';

class VisitaRepository {
  final VisitaDBDataSource datasource;

  VisitaRepository(this.datasource);

  Future<void> insertVisitaFromJson(Map<String, dynamic> json) async {
    await datasource.insertVisitaFromJson(json);
  }

  Future<void> insertVisita(Visita visita) async {
    await datasource.insertVisita(visita);
  }

  Future<void> updateVisita(Visita visita) async {
    await datasource.updateVisita(visita);
  }

  Future<void> deleteVisitasByClienteID(int clienteID) async {
    await datasource.deleteVisitasByClienteID(clienteID);
  }

  Future<List<Visita>> getVisitasByClienteID(int clienteID) async {
    List<Map<String, dynamic>> rawVisitas = await datasource.getVisitasByClienteID(clienteID);

    if (rawVisitas.isEmpty) return [];

    List<Visita> visitas = rawVisitas.map((rawVisita) => Visita.fromJson(rawVisita)).toList();

    return visitas;
  }
}
