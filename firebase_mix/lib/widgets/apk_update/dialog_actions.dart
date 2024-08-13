import 'package:flutter/material.dart';

List<Widget> buildDialogActions(
  BuildContext context,
  Future<void> Function(BuildContext) checkForDownloadedUpdate,
  VoidCallback onCancel,
) {
  void _logWithSeparator(String message) {
    debugPrint(':::: UpdateDialog - $message');
  }

  _logWithSeparator('Construyendo botones de acción');

  return [
    TextButton(
      onPressed: () {
        _logWithSeparator('Botón "Cancelar" presionado');
        onCancel();
      },
      child: const Text(
        'Cancelar',
        style: TextStyle(color: Colors.white),
      ),
    ),
    ElevatedButton(
      onPressed: () async {
        _logWithSeparator('Botón "Actualizar" presionado');
        await checkForDownloadedUpdate(context);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
      ),
      child: const Text(
        'Actualizar',
        style: TextStyle(color: Colors.red),
      ),
    ),
  ];
}
