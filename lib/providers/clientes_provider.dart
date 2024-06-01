import 'package:easy_crm/data/datasources/cliente_db_datasource.dart';
import 'package:easy_crm/data/datasources/contato_db_datasource.dart';
import 'package:easy_crm/models/cliente_model.dart';
import 'package:easy_crm/repository/cliente_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'clientes_provider.g.dart';

@riverpod
class ClientesNotifier extends _$ClientesNotifier {
  final ClienteRepository _clienteRepository = ClienteRepository(clienteDataSource: ClienteDBDataSource(), contatoDataSource: ContatoDBDataSource());

  @override
  Future<List<Cliente>> build() async {
    return _clienteRepository.getActiveClientes();
  }
}
