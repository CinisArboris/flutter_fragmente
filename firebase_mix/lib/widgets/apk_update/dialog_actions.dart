import 'package:flutter/material.dart';

List<Widget> buildDialogActions(
  BuildContext context,
  Future<void> Function(BuildContext) checkForDownloadedUpdate,
  VoidCallback onCancel,
) {
  debugPrint(':::: UpdateDialog - Construyendo botones de acción');
  return [
    TextButton(
      onPressed: () {
        debugPrint(':::: UpdateDialog - Botón "Cancelar" presionado');
        onCancel();
      },
      child: const Text(
        'Cancelar',
        style: TextStyle(color: Colors.white),
      ),
    ),
    ElevatedButton(
      onPressed: () async {
        debugPrint(':::: UpdateDialog - Botón "Actualizar" presionado');
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
