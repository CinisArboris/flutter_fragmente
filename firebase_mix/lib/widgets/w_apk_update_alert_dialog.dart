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
      backgroundColor: Colors.red[600], // Fondo rojo
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: const Row(
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
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10), // Separación entre título y descripción
          const Row(
            children: [
              Icon(Icons.new_releases, color: Colors.white),
              SizedBox(width: 5),
              Text(
                'Nueva versión:',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          Text(
            mobileVersion,
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 10),
          const Row(
            children: [
              Icon(Icons.info_outline, color: Colors.white),
              SizedBox(width: 5),
              Text(
                'Detalles de la versión:',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          Text(
            versionDetail,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: onCancel,
          child: const Text(
            'Cancelar',
            style: TextStyle(color: Colors.white),
          ),
        ),
        ElevatedButton(
          onPressed: onUpdate,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
          ),
          child: const Text(
            'Actualizar',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }
}
