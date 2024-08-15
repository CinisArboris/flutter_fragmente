import 'package:firebase_mix/screens/view_home/part_action_button.dart';
import 'package:firebase_mix/screens/view_home/part_info_card_section.dart';
import 'package:flutter/material.dart';
import 'package:firebase_mix/services/handler_view.dart';
import 'package:firebase_mix/screens/view_update_apk.dart';
import 'package:firebase_mix/widgets/main_apk_dialog_update/w_apk_update_dialog.dart';
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
  final String logPrefix = 'MyHomePage';

  @override
  void initState() {
    super.initState();
    _isDialogShown = false;
    _checkForUpdates();
  }

  Future<void> _checkForUpdates() async {
    _log('Verificando actualizaciones...');
    await _updateHandler.checkForUpdates();

    if (!mounted) return;
    setState(() {});

    if (!_updateHandler.isUpdateAvailable) {
      _log('No hay actualización. Limpieza.');
      await _updateHandler.cleanUp();
    } else if (!_isDialogShown) {
      _log('Actualización disponible. Mostrando diálogo.');
      if (!mounted) return;
      _showUpdateDialog();
      _isDialogShown = true;
    }
  }

  void _showUpdateDialog() {
    _log('Mostrando diálogo de actualización.');
    showDialog(
      context: context,
      builder: (context) => WApkUpdateAlertDialog(
        versionDetail: _updateHandler.remoteDetail,
        mobileVersion: _updateHandler.remoteVersion,
        apkUrl: _updateHandler.remoteApkUrl,
      ),
    );
  }

  void _onUpdate() {
    _log('Iniciando actualización...');
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
    _log('Cancelando actualización.');
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  void _log(String message) {
    debugPrint('$logPrefix: $message');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Remote Config Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InfoCardSection(updateHandler: _updateHandler),
            ActionButtonSection(
              updateHandler: _updateHandler,
              onUpdate: _onUpdate,
              onCancel: _onCancel,
            ),
          ],
        ),
      ),
    );
  }
}
