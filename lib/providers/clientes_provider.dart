import 'package:easy_crm/data/datasources/cliente_db_datasource.dart';
import 'package:easy_crm/data/datasources/contato_db_datasource.dart';
import 'package:easy_crm/models/cliente_model.dart';
import 'package:easy_crm/models/contato_model.dart';
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

  Future<void> insertCliente(Cliente cliente) async {
    try {
      state = const AsyncValue.loading();
      await _clienteRepository.insertCliente(cliente);
      final clientes = await _clienteRepository.getActiveClientes();
      state = AsyncValue.data(clientes);
    } catch (error, stacktrace) {
      state = AsyncValue.error(error, stacktrace);
    }
  }

  Future<void> updateCliente(Cliente cliente) async {
    try {
      state = const AsyncValue.loading();
      await _clienteRepository.updateCliente(cliente);
      final clientes = await _clienteRepository.getActiveClientes();
      state = AsyncValue.data(clientes);
    } catch (error, stacktrace) {
      state = AsyncValue.error(error, stacktrace);
    }
  }

  Future<void> inactivateCliente(Cliente cliente) async {
    try {
      state = const AsyncValue.loading();
      await _clienteRepository.inactivateCliente(cliente);
      final clientes = await _clienteRepository.getActiveClientes();
      state = AsyncValue.data(clientes);
    } catch (error, stacktrace) {
      state = AsyncValue.error(error, stacktrace);
    }
  }

  Future<void> deleteContatoByID(int contatoID) async {
    await _clienteRepository.deleteContatoByContatoID(contatoID);
  }

  Future<int> insertContato(Contato contato) async {
    return await _clienteRepository.insertContato(contato);
  }

  Future<void> updateContato(Contato contato) async {
    await _clienteRepository.updateContato(contato);
  }

  Future<bool> clienteAlreadyExists(String cpfCnpj) async {
    return await _clienteRepository.clienteAlreadyExists(cpfCnpj);
  }

  Future<bool> isClienteActive(String cpfCnpj) async {
    return await _clienteRepository.isClienteActive(cpfCnpj);
  }
}
