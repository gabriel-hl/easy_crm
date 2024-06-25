import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DB {
  //Construtor privado. Obs: Esta classe é do tipo singleton
  DB._();

  //Criando instancia do objeto DB
  static final DB instance = DB._();

  //Instancia do SQfLite
  static Database? _database;

  Future<Database> get database async {
    // Confere se já temos uma instância criada, se sim, retorna ela.
    if (_database != null) return _database!;

    // Caso contrário, iniciamos uma nova instância.
    return await _initDatabase();
  }

  Future<Database> _initDatabase() async {
    // Este método pegará a localização padrão (dependendo do OS) para salvar arquivos de dados
    var databasesPath = await getDatabasesPath();

    String path = join(databasesPath, 'easycrm.db');

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _migrateV1toV2,
    );
  }

  String get _cliente => '''
  CREATE TABLE IF NOT EXISTS cliente (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    ativo INTEGER NOT NULL DEFAULT 1,
    nomeRazao TEXT NOT NULL,
    apelidoFantasia TEXT,
    cpfCnpj TEXT NOT NULL,
    telefone TEXT,
    email TEXT,
    dataCadastro INTEGER NOT NULL,
    cep TEXT,
    estado TEXT,
    cidade TEXT,
    bairro TEXT,
    endereco TEXT,
    numero TEXT,
    complemento TEXT
  );
  ''';

  String get _visita => '''
  CREATE TABLE IF NOT EXISTS visita (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    cliente_id INTEGER NOT NULL,
    data INTEGER NOT NULL,
    descricao TEXT NOT NULL,
    FOREIGN KEY(cliente_id) REFERENCES cliente(id) ON DELETE CASCADE
  );
  ''';

  String get _contato => '''
  CREATE TABLE IF NOT EXISTS contato (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    cliente_id INTEGER NOT NULL,
    nome TEXT NOT NULL,
    cargo TEXT,
    telefone TEXT,
    FOREIGN KEY (cliente_id) REFERENCES cliente(id) ON DELETE CASCADE
  );
  ''';

  Future _createDB(Database db, int version) async {
    await db.execute(_cliente);
    await db.execute(_visita);
    await db.execute(_contato);
  }

  Future _migrateV1toV2(Database db, int oldVersion, int newVersion) async {
    if (oldVersion == 1 && newVersion == 2) {
      await db.transaction((txn) async {
        // Renomeia tabela 'cliente' para 'old_cliente'
        await txn.execute('ALTER TABLE cliente RENAME TO old_cliente');

        // Criando nova tabela de contatos
        await txn.execute(_contato);

        // Criando nova tabela de clientes (sem os dados de contato)
        await txn.execute(_cliente);

        // Migrando dados de 'old_cliente' para 'cliente'
        List<Map<String, dynamic>> clientes = await txn.query('old_cliente');
        for (var cliente in clientes) {
          // Copiando todos contatos de cada 'cliente' para a nova tabela
          if (cliente['contatoPessoa'] != null && cliente['contatoPessoa'].toString().isNotEmpty) {
            await txn.insert('contato', {
              'cliente_id': cliente['id'],
              'nome': cliente['contatoPessoa'],
              'cargo': cliente['contatoCargo'],
              'telefone': cliente['contatoTelefone'],
            });
          }

          // Copiando os clientes para a nova tabela (sem os dados de contato)
          await txn.insert('cliente', {
            'id': cliente['id'],
            'ativo': cliente['ativo'],
            'nomeRazao': cliente['nomeRazao'],
            'apelidoFantasia': cliente['apelidoFantasia'],
            'cpfCnpj': cliente['cpfCnpj'],
            'telefone': cliente['telefone'],
            'email': cliente['email'],
            'dataCadastro': cliente['dataCadastro'],
            'cep': cliente['cep'],
            'estado': cliente['estado'],
            'cidade': cliente['cidade'],
            'bairro': cliente['bairro'],
            'endereco': cliente['endereco'],
            'numero': cliente['numero'],
            'complemento': cliente['complemento'],
          });
        }

        // Dropar a tabela 'old_cliente'
        await txn.execute('DROP TABLE old_cliente');
      });
    }
  }
}
