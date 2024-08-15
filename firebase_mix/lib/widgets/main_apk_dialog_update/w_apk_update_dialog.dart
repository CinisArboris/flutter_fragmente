import 'package:firebase_mix/screens/view_update_apk.dart';
import 'package:firebase_mix/utils_services/transformaciones_apk.dart';
import 'package:flutter/material.dart';
import 'dialog_title.dart';
import 'dialog_content.dart';

class WApkUpdateAlertDialog extends StatefulWidget {
  final VoidCallback onUpdate;
  final VoidCallback onCancel;
  final String versionDetail;
  final String mobileVersion;
  final String apkUrl;

  const WApkUpdateAlertDialog({
    super.key,
    required this.onUpdate,
    required this.onCancel,
    required this.versionDetail,
    required this.mobileVersion,
    required this.apkUrl,
  });

  @override
  WApkUpdateAlertDialogState createState() => WApkUpdateAlertDialogState();
}

class WApkUpdateAlertDialogState extends State<WApkUpdateAlertDialog> {
  void _logWithSeparator(String message) {
    debugPrint('\n================================================');
    debugPrint(':::: UpdateDialog - $message');
    debugPrint('================================================\n');
  }

  Future<void> _checkForDownloadedUpdate() async {
    // Verificar si la actualización ya se ha descargado
    bool updateDownloaded = await TransformacionesAPK.isApkUpdateDownloaded();

    // Verificar si el archivo APK existe en la ruta guardada
    bool fileExists = await TransformacionesAPK.checkIfApkExists();

    if (!mounted) return;

    if (updateDownloaded && fileExists) {
      _logWithSeparator(
          'Caso 1: APK descargado y archivo existe. Procediendo a instalación.');
      widget.onUpdate(); // Proceder directamente a la instalación
    } else if (!fileExists && widget.apkUrl.isNotEmpty) {
      _logWithSeparator(
          'Caso 2: APK no descargado o archivo no encontrado. Iniciando descarga.');
      _startDownloadAgain();
    } else if (fileExists && !updateDownloaded) {
      _logWithSeparator(
          'Caso 3: Archivo encontrado pero marcado como no descargado. Procediendo a instalación.');
      // En este caso, el archivo está presente, pero el flag indica que no está descargado.
      // Esto puede ocurrir si el proceso fue interrumpido. Reajustamos el flag y procedemos a la instalación.
      await TransformacionesAPK.setApkUpdateDownloaded(true);
      widget.onUpdate();
    } else {
      _logWithSeparator(
          'No se pudo encontrar el archivo y no hay una URL válida para descargar.');
      // Aquí podrías manejar el caso de error, mostrar un mensaje, etc.
    }
  }

  Future<void> _startDownloadAgain() async {
    if (mounted) {
      Navigator.of(context).pop();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ViewUpdateApk(apkUrl: widget.apkUrl),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _logWithSeparator('Renderizando diálogo de actualización');
    return AlertDialog(
      backgroundColor: Colors.red[600],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: buildDialogTitle(),
      content: buildDialogContent(widget.versionDetail, widget.mobileVersion),
      actions: [
        TextButton(
          onPressed: () {
            _logWithSeparator('Botón "Cancelar" presionado');
            if (mounted) {
              widget.onCancel();
            }
          },
          child: const Text(
            'Cancelar',
            style: TextStyle(color: Colors.white),
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            _logWithSeparator('Botón "Actualizar" presionado');
            await _checkForDownloadedUpdate();
          },
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
