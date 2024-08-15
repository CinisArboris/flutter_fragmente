import 'package:firebase_mix/screens/view_home/update_body.dart';
import 'package:firebase_mix/screens/view_update_apk.dart';
import 'package:firebase_mix/services/handler_view.dart';
import 'package:firebase_mix/widgets/main_apk_dialog_update/w_apk_update_dialog.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class MyHomePage extends StatefulWidget {
  final FirebaseAnalytics analytics;

  const MyHomePage({
    super.key,
    required this.analytics,
  });

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  final HandlerView _updateHandler = HandlerView();
  bool _isDialogShown = false;

  @override
  void initState() {
    super.initState();
    _isDialogShown = false;
    _checkForUpdates();
  }

  Future<void> _checkForUpdates() async {
    _logWithSeparator('Iniciando verificación de actualizaciones...');
    await _updateHandler.checkForUpdates();

    if (!mounted) return;
    setState(() {});

    _logWithSeparator(
        'Verificando si se requiere actualización y si el diálogo ya se mostró.');
    if (!_updateHandler.isUpdateAvailable) {
      _logWithSeparator(
          'No se requiere actualización. Procediendo a limpieza...');
      await _updateHandler.cleanUp();
    } else if (_updateHandler.isUpdateAvailable && !_isDialogShown) {
      _logWithSeparator('Actualización disponible. Mostrando diálogo...');
      if (!mounted) return;
      _showUpdateDialog();
      _isDialogShown = true;
    }
  }

  void _showUpdateDialog() {
    _logWithSeparator('Mostrando diálogo de actualización...');
    showDialog(
      context: context,
      builder: (context) => WApkUpdateAlertDialog(
        onUpdate: _onUpdate,
        onCancel: _onCancel,
        versionDetail: _updateHandler.remoteDetail,
        mobileVersion: _updateHandler.remoteVersion,
        apkUrl: _updateHandler.remoteApkUrl,
      ),
    );
  }

  void _onUpdate() {
    _logWithSeparator(
        'Botón "Actualizar" presionado. Redirigiendo a la pantalla de descarga...');
    if (mounted) {
      Navigator.of(context).pop();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ViewUpdateApk(apkUrl: _updateHandler.remoteApkUrl),
        ),
      );
    }
  }

  void _onCancel() {
    _logWithSeparator('Botón "Cancelar" presionado. Cerrando diálogo...');
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  void _logWithSeparator(String message) {
    debugPrint('\n================== MyHomePage ==================');
    debugPrint(message);
    debugPrint('================================================\n');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Remote Config Example'),
      ),
      body: UpdateBody(
        updateHandler: _updateHandler,
      ),
    );
  }
}
