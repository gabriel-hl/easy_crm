import 'dart:convert';

import 'package:http/http.dart' as http;

class BrasilAPIDataSource {
  Future<Map<String, dynamic>> getCNPJ(String cnpj) async {
    final url = Uri.parse('https://brasilapi.com.br/api/cnpj/v1/${cnpj.replaceAll(RegExp(r'[./-]'), '')}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('HTTP Error: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> getCEP(String cep) async {
    final url = Uri.parse('https://brasilapi.com.br/api/cep/v1/${cep.replaceAll(RegExp(r'[.-]'), '')}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('HTTP Error: ${response.statusCode}');
    }
  }
}
