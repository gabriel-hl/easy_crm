import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({super.key, required this.title, required this.dialog});

  final String title;
  final String dialog;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          const Icon(
            Icons.warning_outlined,
            color: Colors.orange,
          ),
          const SizedBox(width: 8),
          Text(title),
        ],
      ),
      content: Text(dialog),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: const Text(
            'Confirmar',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: Text(
            'Cancelar',
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.normal),
          ),
        )
      ],
    );
  }
}
