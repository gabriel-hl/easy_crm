import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  const ErrorDialog({super.key, required this.title, required this.error});

  final String title;
  final String error;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          const Icon(
            Icons.error_rounded,
            color: Colors.red,
          ),
          const SizedBox(width: 8),
          Text(title),
        ],
      ),
      content: Text(error),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('OK'),
        )
      ],
    );
  }
}
