import 'package:flutter/material.dart';

class UpdateAlertDialog extends StatelessWidget {
  final VoidCallback onUpdate;
  final VoidCallback onCancel;
  final String versionDetail;
  final String mobileVersion;

  const UpdateAlertDialog({
    super.key,
    required this.onUpdate,
    required this.onCancel,
    required this.versionDetail,
    required this.mobileVersion,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.lightBlue[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: const BorderSide(color: Colors.lightBlue, width: 2),
      ),
      title: Row(
        children: [
          Icon(Icons.update, color: Colors.lightBlue, size: 30),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              '🔄 Nueva versión disponible',
              style: TextStyle(
                color: Colors.lightBlue,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
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
            '📱 Versión del móvil:',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          Text(
            mobileVersion,
            style: const TextStyle(color: Colors.black),
          ),
          const SizedBox(height: 10),
          const Text(
            '📋 Detalles:',
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
        ElevatedButton(
          onPressed: onUpdate,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.lightBlue, // Color de fondo celeste
          ),
          child: const Text(
            'Descargar',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
