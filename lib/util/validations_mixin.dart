import 'package:brasil_fields/brasil_fields.dart';
import 'package:intl/intl.dart';

mixin ValidationsMixin {
  String? combine(List<String? Function()> validators) {
    for (final func in validators) {
      final validation = func();
      if (validation != null) return validation;
    }
    return null;
  }

  String? isNotEmpty(String? value, [String? message]) {
    if (value!.isEmpty) return message ?? 'Esse campo é obrigatório';

    return null;
  }

  String? isCNPJCPFValid(String? value, [String? message]) {
    if (!UtilBrasilFields.isCNPJValido(value) && !UtilBrasilFields.isCPFValido(value)) return message ?? 'CNPJ ou CPF inválido';

    return null;
  }

  String? isDateValid(String? value, [String? message]) {
    if (value == null || value.isEmpty) return message ?? 'Data inválida';

    // Expressão regular para verificar o formato da data (DD/MM/AAAA)
    RegExp regex = RegExp(r'^\d{2}/\d{2}/\d{4}$');

    // Verifica se a data possui o formato correto
    if (!regex.hasMatch(value)) return message ?? 'Data inválida';

    // Verifica se é uma data válida usando a classe DateTime
    try {
      List<String> dateParts = value.split('/');
      String formattedDate = '${dateParts[2]}-${dateParts[1]}-${dateParts[0]}';
      DateFormat('yyyy-MM-dd').parseStrict(formattedDate);
      return null;
    } catch (e) {
      return message ?? 'Data inválida';
    }
  }
}
