class Visita {
  final int id;
  final int clienteID;
  int data;
  String descricao;

  Visita({
    required this.id,
    required this.clienteID,
    required this.data,
    required this.descricao,
  });

  factory Visita.fromJson(Map<String, dynamic> json) {
    return Visita(
      id: json['id'],
      clienteID: json['cliente_id'],
      data: json['data'],
      descricao: json['descricao'],
    );
  }

  Map<String, dynamic> toJson() => {
        'cliente_id': clienteID,
        'data': data,
        'descricao': descricao,
      };
}
