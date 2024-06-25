import 'package:brasil_fields/brasil_fields.dart';
import 'package:easy_crm/util/input_formatters/uppercase_input_formatter.dart';
import 'package:easy_crm/util/validations_mixin.dart';
import 'package:easy_crm/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomContatoForm extends StatelessWidget with ValidationsMixin {
  final int contatoID;
  final TextEditingController nomeController;
  final TextEditingController cargoController;
  final TextEditingController telefoneController;

  const CustomContatoForm({
    super.key,
    required this.contatoID, // Utiliza-se contatoID = 0 quando for um novo contato
    required this.nomeController,
    required this.cargoController,
    required this.telefoneController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomTextFormField(
          controller: nomeController,
          inputFormatters: [FilteringTextInputFormatter.singleLineFormatter, UpperCaseInputFormatter()],
          validator: isNotEmpty,
          icon: const Icon(Icons.person),
          labelText: 'Nome',
        ),
        const SizedBox(height: 12),
        CustomTextFormField(
          controller: cargoController,
          inputFormatters: [FilteringTextInputFormatter.singleLineFormatter, UpperCaseInputFormatter()],
          icon: const Icon(null),
          labelText: 'Cargo',
        ),
        const SizedBox(height: 12),
        CustomTextFormField(
          controller: telefoneController,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.singleLineFormatter, FilteringTextInputFormatter.digitsOnly, TelefoneInputFormatter()],
          icon: const Icon(null),
          labelText: 'Telefone',
        ),
      ],
    );
  }
}
