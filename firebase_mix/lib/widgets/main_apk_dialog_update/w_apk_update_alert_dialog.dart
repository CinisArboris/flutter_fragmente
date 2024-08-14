import 'package:firebase_mix/screens/view_update_apk.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    debugPrint('\n-----------------------------');
    debugPrint(':::: UpdateDialog - $message');
    debugPrint('-----------------------------\n');
  }

  Future<void> _checkForDownloadedUpdate() async {
    final prefs = await SharedPreferences.getInstance();
    bool updateDownloaded = prefs.getBool('update_downloaded') ?? false;

    // Obtener el nombre del archivo desde la URL
    final fileName = UtilsAPK.extraerNombreDesdeUrl(widget.apkUrl);

    // Obtener la ruta del archivo donde se guarda la APK
    final filePath = await UtilsAPK.obtenerRutaGuardado(fileName);

    if (!mounted) return;

    if (updateDownloaded && await UtilsAPK.verificarArchivo(filePath)) {
      _logWithSeparator(
          'Actualización ya descargada y archivo encontrado, procediendo a instalación.');
      if (mounted) {
        widget.onUpdate(); // Proceder directamente a la instalación
      }
    } else {
      _logWithSeparator(
          'Archivo no encontrado o no se ha descargado la actualización, iniciando descarga.');
      if (mounted) {
        _startDownloadAgain(filePath);
      }
    }
  }

  void _startDownloadAgain(String filePath) async {
    // Eliminar cualquier archivo existente antes de iniciar una nueva descarga
    await UtilsAPK.eliminarArchivo(filePath);

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
