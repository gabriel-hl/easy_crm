import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    super.key,
    this.enabled = true,
    this.maxLines = 1,
    this.controller,
    this.initialValue,
    this.keyboardType,
    this.inputFormatters,
    this.validator,
    this.icon,
    this.suffixIcon,
    this.labelText,
  });

  final bool enabled;
  final TextEditingController? controller;
  final String? initialValue;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final Widget? icon;
  final Widget? suffixIcon;
  final String? labelText;
  final int? maxLines;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: widget.maxLines,
      enabled: widget.enabled,
      initialValue: widget.initialValue,
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatters,
      validator: widget.validator,
      decoration: InputDecoration(
        icon: widget.icon,
        suffixIcon: widget.suffixIcon,
        labelText: widget.labelText,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
