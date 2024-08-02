import 'package:flutter/material.dart';

class UpdateAlertDialog extends StatelessWidget {
  final VoidCallback onUpdate;
  final VoidCallback onCancel;
  final String versionDetail;

  const UpdateAlertDialog({
    super.key,
    required this.onUpdate,
    required this.onCancel,
    required this.versionDetail,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.yellow[100],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      title: const Row(
        children: [
          Icon(Icons.system_update, color: Colors.red),
          SizedBox(width: 10),
          Text(
            'Nueva versión disponible',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Hay una nueva versión de la aplicación disponible. ¿Desea descargarla ahora?',
            style: TextStyle(color: Colors.black),
          ),
          const SizedBox(height: 10),
          const Text(
            'Detalles:',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          Text(
            versionDetail,
            style: const TextStyle(color: Colors.black),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: onCancel,
          child: const Text(
            'Cancelar',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        TextButton(
          onPressed: onUpdate,
          child: const Text(
            'Descargar',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }
}
