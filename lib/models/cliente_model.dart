import 'package:easy_crm/models/contato_model.dart';

class Cliente {
  final int id;
  int ativo;
  String nomeRazao;
  String? apelidoFantasia;
  String cpfCnpj;
  String? telefone;
  String? email;
  final int dataCadastro;
  String? cep;
  String? estado;
  String? cidade;
  String? bairro;
  String? endereco;
  String? numero;
  String? complemento;
  List<Contato>? contatos;

  Cliente({
    required this.id,
    this.ativo = 1,
    required this.nomeRazao,
    this.apelidoFantasia,
    required this.cpfCnpj,
    this.telefone,
    this.email,
    required this.dataCadastro,
    this.cep,
    this.estado,
    this.cidade,
    this.bairro,
    this.endereco,
    this.numero,
    this.complemento,
    this.contatos,
  });

  // Método para entregar uma nova instância de um Cliente, com as devidas alterações
  Cliente copyWith({
    int? ativo,
    String? nomeRazao,
    String? apelidoFantasia,
    String? cpfCnpj,
    String? telefone,
    String? email,
    String? cep,
    String? estado,
    String? cidade,
    String? bairro,
    String? endereco,
    String? numero,
    String? complemento,
    List<Contato>? contatos,
  }) {
    return Cliente(
      id: id,
      ativo: ativo ?? this.ativo,
      nomeRazao: nomeRazao ?? this.nomeRazao,
      apelidoFantasia: apelidoFantasia ?? this.apelidoFantasia,
      cpfCnpj: cpfCnpj ?? this.cpfCnpj,
      telefone: telefone ?? this.telefone,
      email: email ?? this.email,
      dataCadastro: dataCadastro,
      cep: cep ?? this.cep,
      estado: estado ?? this.estado,
      cidade: cidade ?? this.cidade,
      bairro: bairro ?? this.bairro,
      endereco: endereco ?? this.endereco,
      numero: numero ?? this.numero,
      complemento: complemento ?? this.complemento,
      contatos: contatos ?? this.contatos,
    );
  }

  Map<String, dynamic> toJson() => {
        'ativo': ativo,
        'nomeRazao': nomeRazao,
        'apelidoFantasia': apelidoFantasia,
        'cpfCnpj': cpfCnpj,
        'telefone': telefone,
        'email': email,
        'dataCadastro': dataCadastro,
        'cep': cep,
        'estado': estado,
        'cidade': cidade,
        'bairro': bairro,
        'endereco': endereco,
        'numero': numero,
        'complemento': complemento,
      };
}
