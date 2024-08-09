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
  String textoRandom = '';
  String svrDetalleVersion = '';
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _checkForUpdates();
  }

  void _checkForUpdates() async {
    await _versionCheckService.checkVersion();
    setState(() {
      versionMiMovil = _versionCheckService.versionMiMovil;
      textoRandom = _versionCheckService.svrTextoVersion;
      svrDetalleVersion = _versionCheckService.svrDetalleVersion;
      isButtonEnabled = !_versionCheckService.isUpdateAvailable;
    });

    if (_versionCheckService.isUpdateAvailable) {
      _showUpdateDialog();
    }
  }

  void _showUpdateDialog() {
    showDialog(
      context: context,
      builder: (context) => UpdateAlertDialog(
        onUpdate: () {
          Navigator.of(context).pop();
          _versionCheckService.redirectToDownload();
        },
        onCancel: () {
          Navigator.of(context).pop();
        },
        versionDetail: svrDetalleVersion,
      ),
    );
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
            InfoCard(title: 'Versión de mi Móvil', subtitle: versionMiMovil),
            const SizedBox(height: 20),
            InfoCard(title: 'Texto Random', subtitle: textoRandom),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isButtonEnabled
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NewRoute(),
                        ),
                      );
                    }
                  : null,
              child: const Text('Ir a nueva ruta'),
            ),
          ],
        ),
      ),
    );
  }
}
