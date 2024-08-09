import 'package:firebase_mix/screens/apk_installer_screen.dart';
import 'package:firebase_mix/widgets/update_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import '../services/version_check_service.dart';
import '../widgets/info_card.dart';
import 'new_route.dart';

class MyHomePage extends StatefulWidget {
  final FirebaseAnalytics analytics;

  const MyHomePage({super.key, required this.analytics});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  final VersionCheckService _versionCheckService = VersionCheckService();
  String versionMiMovil = '';
  String svrDetalleVersion = ''; // Almacena la descripción de la APK
  String svrUltimaVersion = ''; // Almacena la versión en el servidor
  String svrUrlDescargarApk = ''; // Almacena la URL de descarga de la APK
  bool isUpdateAvailable = false;
  bool isButtonEnabled = true;

  @override
  void initState() {
    super.initState();
    _checkForUpdates();
  }

  Future<void> _checkForUpdates() async {
    await _versionCheckService.checkVersion();
    setState(() {
      versionMiMovil = _versionCheckService.versionMiMovil;
      svrDetalleVersion = _versionCheckService.svrDetalleVersion;
      svrUltimaVersion = _versionCheckService.svrUltimaVersion;
      svrUrlDescargarApk = _versionCheckService.svrUrlDescargarApk;
      isUpdateAvailable = _versionCheckService.isUpdateAvailable;
      isButtonEnabled = !isUpdateAvailable;
    });

    if (isUpdateAvailable) {
      _showUpdateDialog();
    }
  }

  void _showUpdateDialog() {
    showDialog(
      context: context,
      builder: (context) => UpdateAlertDialog(
        onUpdate: _onUpdate,
        onCancel: _onCancel,
        versionDetail: svrDetalleVersion,
        mobileVersion: versionMiMovil,
      ),
    );
  }

  void _onUpdate() {
    Navigator.of(context).pop();
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ApkInstallScreen(apkUrl: svrUrlDescargarApk)),
    );
  }

  void _onCancel() {
    Navigator.of(context).pop();
  }

  void _recheckVersionAndNavigate() async {
    await _versionCheckService.checkVersion();
    if (_versionCheckService.isUpdateAvailable) {
      _showUpdateDialog();
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const NewRoute()),
      );
    }
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
            const InfoCard(
              title: 'Detalle',
              subtitle: 'Modulos disponibles : 5',
            ),
            const SizedBox(height: 20),
            InfoCard(
                title: 'Versión instalada en el dispositivo',
                subtitle: versionMiMovil),
            const SizedBox(height: 20),
            InfoCard(
                title: 'Descripción de la APK', subtitle: svrDetalleVersion),
            const SizedBox(height: 20),
            InfoCard(
              title: 'Versión disponible en el servidor',
              subtitle: svrUltimaVersion,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isButtonEnabled ? _recheckVersionAndNavigate : null,
              child: Text(isUpdateAvailable ? 'Actualizar' : 'Ir a nueva ruta'),
            ),
          ],
        ),
      ),
    );
  }
}
