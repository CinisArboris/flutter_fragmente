import 'package:firebase_mix/screens/view_update_apk.dart';
import 'package:firebase_mix/services/version_check_service.dart';
import 'package:firebase_mix/widgets/w_info_card.dart';
import 'package:firebase_mix/widgets/w_apk_update_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'view_default_test.dart';

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
  final VersionCheckService _versionCheckService = VersionCheckService();
  String versionMiMovil = '';
  String svrDetalleVersion = '';
  String svrUltimaVersion = '';
  String svrUrlDescargarApk = '';
  bool isUpdateAvailable = false;

  @override
  void initState() {
    super.initState();
    _checkForUpdates();
  }

  Future<void> _checkForUpdates() async {
    await _versionCheckService.checkVersion();
    _updateVersionInfo();
    _handleUpdateDialog();
  }

  void _updateVersionInfo() {
    setState(() {
      versionMiMovil = _versionCheckService.versionMiMovil;
      svrDetalleVersion = _versionCheckService.svrDetalleVersion;
      svrUltimaVersion = _versionCheckService.svrUltimaVersion;
      svrUrlDescargarApk = _versionCheckService.svrUrlDescargarApk;
      isUpdateAvailable = _versionCheckService.isUpdateAvailable;
    });
  }

  void _handleUpdateDialog() {
    if (isUpdateAvailable) {
      _showUpdateDialog();
    }
  }

  void _showUpdateDialog() {
    showDialog(
      context: context,
      builder: (context) => UpdateAlertDialog(
        onUpdate: _navigateToUpdatePage,
        onCancel: _onCancel,
        versionDetail: svrDetalleVersion,
        mobileVersion: svrUltimaVersion,
      ),
    );
  }

  void _onUpdate() {
    _navigateToUpdatePage();
  }

  void _onCancel() {
    Navigator.of(context).pop();
  }

  void _navigateToUpdatePage() {
    Navigator.of(context).pop();
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ViewUpdateApk(apkUrl: svrUrlDescargarApk)),
    );
  }

  void _recheckVersionAndNavigate() async {
    await _versionCheckService.checkVersion();
    if (_versionCheckService.isUpdateAvailable) {
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
            subtitle: 'Modulos disponibles : 5',
          ),
          const SizedBox(height: 20),
          _buildVersionInfoCard(
              'Versión instalada en el dispositivo', versionMiMovil),
          const SizedBox(height: 20),
          _buildVersionInfoCard('Descripción de la APK', svrDetalleVersion),
          const SizedBox(height: 20),
          _buildVersionInfoCard(
              'Versión disponible en el servidor', svrUltimaVersion),
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
        if (isUpdateAvailable) ...[
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
      onPressed: _onUpdate,
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
