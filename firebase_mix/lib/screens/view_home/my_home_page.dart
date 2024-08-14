import 'package:firebase_mix/screens/view_default_test.dart';
import 'package:firebase_mix/screens/view_update_apk.dart';
import 'package:firebase_mix/services/handler_view.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_mix/widgets/w_info_card.dart';
import 'package:firebase_mix/widgets/apk_update/w_apk_update_alert_dialog.dart';

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
    _checkForUpdates();
  }

  Future<void> _checkForUpdates() async {
    await _updateHandler.checkForUpdates();
    setState(() {});

    if (!_updateHandler.isUpdateAvailable) {
      await _updateHandler.cleanUp();
    } else if (_updateHandler.isUpdateAvailable && !_isDialogShown) {
      _handleUpdateDialog();
    }
  }

  void _handleUpdateDialog() async {
    if (await _updateHandler.isUpdateDownloaded()) {
      await _updateHandler.installUpdate();
    } else {
      _showUpdateDialog();
    }
  }

  void _showUpdateDialog() {
    showDialog(
      context: context,
      builder: (context) => WApkUpdateAlertDialog(
        onUpdate: _onUpdate,
        onCancel: _onCancel,
        versionDetail: _updateHandler.remoteDetail,
        mobileVersion: _updateHandler.remoteVersion,
        apkUrl: _updateHandler.remoteApkUrl,
      ),
    ).then((_) {
      _isDialogShown = false;
    });
    _isDialogShown = true;
  }

  void _onUpdate() {
    Navigator.of(context).pop();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ViewUpdateApk(apkUrl: _updateHandler.remoteApkUrl),
      ),
    );
  }

  void _onCancel() {
    Navigator.of(context).pop();
  }

  void _recheckVersionAndNavigate() async {
    await _updateHandler.checkForUpdates();
    if (_updateHandler.isUpdateAvailable) {
      _showUpdateDialog();
    } else {
      _navigateToDefaultTestPage();
    }
  }

  void _navigateToDefaultTestPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ViewDefaultTest()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Remote Config Example'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const InfoCard(
            title: 'Detalle',
            subtitle: 'Modulos disponibles : 15',
          ),
          const SizedBox(height: 20),
          _buildVersionInfoCard('Versión instalada en el dispositivo',
              _updateHandler.localVersion),
          const SizedBox(height: 20),
          _buildVersionInfoCard(
              'Descripción de la APK', _updateHandler.remoteDetail),
          const SizedBox(height: 20),
          _buildVersionInfoCard('Versión disponible en el servidor',
              _updateHandler.remoteVersion),
          const SizedBox(height: 20),
          _buildActionButton(),
        ],
      ),
    );
  }

  Widget _buildVersionInfoCard(String title, String subtitle) {
    return InfoCard(
      title: title,
      subtitle: subtitle,
    );
  }

  Widget _buildActionButton() {
    return Column(
      children: [
        if (_updateHandler.isUpdateAvailable) ...[
          _buildUpdateButton(),
          const SizedBox(height: 10),
        ] else ...[
          _buildNavigateButton(),
          const SizedBox(height: 10),
        ],
      ],
    );
  }

  Widget _buildUpdateButton() {
    return ElevatedButton(
      onPressed: _showUpdateDialog,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange,
      ),
      child: const Text(
        'Actualizar',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildNavigateButton() {
    return ElevatedButton(
      onPressed: _recheckVersionAndNavigate,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
      ),
      child: const Text(
        'Ir a nueva ruta',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
