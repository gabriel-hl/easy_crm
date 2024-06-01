import 'package:easy_crm/data/datasources/visita_db_datasource.dart';
import 'package:easy_crm/models/visita_model.dart';
import 'package:easy_crm/repository/visita_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'visitas_provider.g.dart';

@riverpod
class VisitasNotifier extends _$VisitasNotifier {
  final VisitaRepository _visitaRepository = VisitaRepository(VisitaDBDataSource());

  @override
  Future<List<Visita>> build(int clienteID) async {
    return _visitaRepository.getVisitasByClienteID(clienteID);
  }
}
