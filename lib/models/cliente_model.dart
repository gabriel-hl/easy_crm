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

  factory Cliente.fromJSON(Map<String, dynamic> json) {
    return Cliente(
      id: json['id'],
      ativo: json['ativo'],
      nomeRazao: json['nomeRazao'],
      apelidoFantasia: json['apelidoFantasia'],
      cpfCnpj: json['cpfCnpj'],
      telefone: json['telefone'],
      email: json['email'],
      dataCadastro: json['dataCadastro'],
      cep: json['cep'],
      estado: json['estado'],
      cidade: json['cidade'],
      bairro: json['bairro'],
      endereco: json['endereco'],
      numero: json['numero'],
      complemento: json['complemento'],
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
