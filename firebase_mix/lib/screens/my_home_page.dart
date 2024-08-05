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
  String svrDetalleVersion = '';
  bool isUpdateAvailable = false;

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
      isUpdateAvailable = _versionCheckService.isUpdateAvailable;
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

  void _onUpdate() async {
    try {
      Navigator.of(context).pop();
      await _versionCheckService.redirectToDownload();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
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
        MaterialPageRoute(builder: (context) => NewRoute()),
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
            InfoCard(
              title: 'Versión actual del móvil',
              subtitle: versionMiMovil,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isUpdateAvailable
                  ? _versionCheckService.redirectToDownload
                  : _recheckVersionAndNavigate,
              child: Text(isUpdateAvailable ? 'Actualizar' : 'Ir a nueva ruta'),
            ),
          ],
        ),
      ),
    );
  }
}
