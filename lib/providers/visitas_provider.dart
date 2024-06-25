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

  Future<void> insertVisita(Visita visita) async {
    try {
      state = const AsyncValue.loading();
      await _visitaRepository.insertVisita(visita);
      final visitas = await _visitaRepository.getVisitasByClienteID(visita.clienteID);
      state = AsyncValue.data(visitas);
    } catch (error, stacktrace) {
      state = AsyncValue.error(error, stacktrace);
    }
  }

  Future<void> updateVisita(Visita visita) async {
    try {
      state = const AsyncValue.loading();
      await _visitaRepository.updateVisita(visita);
      final visitas = await _visitaRepository.getVisitasByClienteID(visita.clienteID);
      state = AsyncValue.data(visitas);
    } catch (error, stacktrace) {
      state = AsyncValue.error(error, stacktrace);
    }
  }

  Future<void> deleteVisitaByID(int visitaID) async {
    try {
      List<Visita> oldVisitas = state.value!;

      state = const AsyncValue.loading();
      await _visitaRepository.deleteVisitaByID(visitaID);
      oldVisitas.removeWhere((visita) => visita.id == visitaID);
      state = AsyncValue.data(oldVisitas);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> deleteVisitasByClienteID(int clienteID) async {
    await _visitaRepository.deleteVisitasByClienteID(clienteID);
  }
}
