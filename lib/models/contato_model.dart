class Contato {
  final int id;
  final int clienteID;
  String nome;
  String? cargo;
  String? telefone;

  Contato({
    required this.id,
    required this.clienteID,
    required this.nome,
    this.cargo,
    this.telefone,
  });

  Contato copyWith({int? id, int? clienteID, String? nome, String? cargo, String? telefone}) {
    return Contato(
      id: id ?? this.id,
      clienteID: clienteID ?? this.clienteID,
      nome: nome ?? this.nome,
      cargo: cargo ?? this.cargo,
      telefone: telefone ?? this.telefone,
    );
  }

/*   factory Contato.fromJson(Map<String, dynamic> json) {
    return Contato(
      id: json['id'],
      clienteID: json['cliente_id'],
      nome: json['nome'],
      cargo: json['cargo'],
      telefone: json['telefone'],
    );
  } */

  Map<String, dynamic> toJson() => {
        'cliente_id': clienteID,
        'nome': nome,
        'cargo': cargo,
        'telefone': telefone,
      };
}
