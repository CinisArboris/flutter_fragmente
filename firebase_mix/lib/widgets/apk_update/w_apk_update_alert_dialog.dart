import 'package:firebase_mix/screens/view_update_apk.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dialog_title.dart'; // Importamos el archivo auxiliar para el título
import 'dialog_content.dart'; // Importamos el archivo auxiliar para el contenido
import 'dialog_actions.dart'; // Importamos el archivo auxiliar para las acciones

class WApkUpdateAlertDialog extends StatelessWidget {
  final VoidCallback onUpdate;
  final VoidCallback onCancel;
  final String versionDetail;
  final String mobileVersion;

  const WApkUpdateAlertDialog({
    super.key,
    required this.onUpdate,
    required this.onCancel,
    required this.versionDetail,
    required this.mobileVersion,
  });

  Future<void> _checkForDownloadedUpdate(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    bool updateDownloaded = prefs.getBool('update_downloaded') ?? false;

    if (updateDownloaded) {
      debugPrint(
          ':::: UpdateDialog - Actualización ya descargada, procediendo a instalación.');
      onUpdate(); // Proceder directamente a la instalación
    } else {
      debugPrint(
          ':::: UpdateDialog - No hay actualización descargada, iniciando descarga.');
      Navigator.of(context).pop();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ViewUpdateApk(apkUrl: mobileVersion),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(':::: UpdateDialog - Renderizando diálogo de actualización');
    return AlertDialog(
      backgroundColor: Colors.red[600],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      // Usamos la función importada para construir el título
      title: buildDialogTitle(),
      // Usamos la función importada para construir el contenido
      content: buildDialogContent(versionDetail, mobileVersion),
      // Usamos la función importada para construir las acciones
      actions: buildDialogActions(context, _checkForDownloadedUpdate, onCancel),
    );
  }
}
