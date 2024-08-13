import 'package:flutter/material.dart';

Widget buildDialogTitle() {
  debugPrint(':::: UpdateDialog - Construyendo título del diálogo');
  return const Row(
    children: [
      Icon(Icons.system_update, color: Colors.white),
      SizedBox(width: 10),
      Text(
        'Actualización disponible',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    ],
  );
}
