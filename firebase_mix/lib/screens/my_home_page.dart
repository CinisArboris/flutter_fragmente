import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import '../services/version_check_service.dart';
import '../widgets/info_card.dart';

class MyHomePage extends StatefulWidget {
  final FirebaseAnalytics analytics;

  const MyHomePage({super.key, required this.analytics});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final VersionCheckService _versionCheckService = VersionCheckService();
  String versionMiMovil = '';
  String textoRandom = '';

  @override
  void initState() {
    super.initState();
    _checkForUpdates();
  }

  void _checkForUpdates() async {
    await _versionCheckService.checkVersion();
    setState(() {
      versionMiMovil = _versionCheckService.versionMiMovil;
      textoRandom = _versionCheckService.textoRandom;
    });

    if (_versionCheckService.isUpdateAvailable) {
      _showUpdateDialog();
    }
  }

  void _showUpdateDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Nueva versión disponible'),
        content: Text(
            'Hay una nueva versión de la aplicación disponible. ¿Desea descargarla ahora?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _versionCheckService.redirectToDownload();
            },
            child: Text('Descargar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Remote Config Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InfoCard(title: 'Versión de mi Móvil', subtitle: versionMiMovil),
            SizedBox(height: 20),
            InfoCard(title: 'Texto Random', subtitle: textoRandom),
          ],
        ),
      ),
    );
  }
}
