import 'package:firebase_mix/screens/view_update_apk.dart';
import 'package:firebase_mix/services/service_check_version.dart';
import 'package:firebase_mix/services/servicio_gestor_de_actualizacion.dart';
import 'package:firebase_mix/widgets/w_info_card.dart';
import 'package:firebase_mix/widgets/w_apk_update_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:install_plugin/install_plugin.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  final ServiceCheckVersion _versionCheckService = ServiceCheckVersion();
  String localVersion = '';
  String remoteDetail = '';
  String remoteVersion = '';
  String remoteApkUrl = '';
  bool isUpdateAvailable = false;
  bool _isDialogShown = false;

  @override
  void initState() {
    super.initState();
    _checkForUpdates();
  }

  Future<void> _checkForUpdates() async {
    debugPrint('::::Iniciando verificación de actualizaciones...');
    await _versionCheckService.checkVersion();
    _updateVersionInfo();
    if (isUpdateAvailable && !_isDialogShown) {
      _handleUpdateDialog();
    }
  }

  void _updateVersionInfo() {
    setState(() {
      localVersion = _versionCheckService.localVersion;
      remoteDetail = _versionCheckService.remoteDetail;
      remoteVersion = _versionCheckService.remoteVersion;
      remoteApkUrl = _versionCheckService.remoteApkUrl;
      isUpdateAvailable = _versionCheckService.isUpdateAvailable;
    });
    debugPrint('::::Información de la versión actualizada:');
    debugPrint('::::Versión local: $localVersion');
    debugPrint('::::Versión remota: $remoteVersion');
    debugPrint('::::Detalle de la versión remota: $remoteDetail');
    debugPrint('::::URL de descarga de la APK: $remoteApkUrl');
  }

  void _handleUpdateDialog() async {
    final prefs = await SharedPreferences.getInstance();
    bool updateDownloaded = prefs.getBool('update_downloaded') ?? false;

    if (isUpdateAvailable && !updateDownloaded && !_isDialogShown) {
      debugPrint('::::Mostrando diálogo de actualización...');
      _isDialogShown = true;
      _showUpdateDialog();
    } else if (updateDownloaded) {
      debugPrint('::::Actualización ya descargada. Iniciando instalación.');
      _installDownloadedUpdate();
    } else {
      debugPrint('::::Error en la actualización, limpieza de estado...');
      await limpiarDatosDeInstalacion();
    }
  }

  void _installDownloadedUpdate() async {
    final gestor = ServicioGestorDeActualizacion(remoteApkUrl);
    final savePath = await gestor.obtenerRutaGuardado();
    await InstallPlugin.install(savePath);
    debugPrint(
        '::::Instalación iniciada con éxito desde el método _installDownloadedUpdate.');

    // Limpieza después de la instalación exitosa
    await gestor.limpiarDatosDeInstalacion();
  }

  void _showUpdateDialog() {
    showDialog(
      context: context,
      builder: (context) => UpdateAlertDialog(
        onUpdate: _onUpdate,
        onCancel: _onCancel,
        versionDetail: remoteDetail,
        mobileVersion: remoteVersion,
      ),
    ).then((_) {
      debugPrint('::::Diálogo de actualización cerrado.');
      _isDialogShown = false;
    });
  }

  void _onUpdate() {
    debugPrint('::::Usuario ha decidido actualizar.');
    Navigator.of(context).pop();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewUpdateApk(apkUrl: remoteApkUrl),
      ),
    );
  }

  void _onCancel() {
    debugPrint('::::Usuario ha cancelado la actualización.');
    Navigator.of(context).pop();
  }

  void _recheckVersionAndNavigate() async {
    debugPrint('::::Re-verificando versiones antes de la navegación...');
    await _versionCheckService.checkVersion();
    if (_versionCheckService.isUpdateAvailable) {
      debugPrint('::::Actualización disponible después de la re-verificación.');
      _showUpdateDialog();
    } else {
      debugPrint(
          '::::No hay actualizaciones. Navegando a la página de prueba.');
      _navigateToDefaultTestPage();
    }
  }

  void _navigateToDefaultTestPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ViewDefaultTest()),
    );
  }

  Future<void> limpiarDatosDeInstalacion() async {
    final gestor = ServicioGestorDeActualizacion(remoteApkUrl);
    await gestor.limpiarDatosDeInstalacion();
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
          _buildVersionInfoCard(
              'Versión instalada en el dispositivo', localVersion),
          const SizedBox(height: 20),
          _buildVersionInfoCard('Descripción de la APK', remoteDetail),
          const SizedBox(height: 20),
          _buildVersionInfoCard(
              'Versión disponible en el servidor', remoteVersion),
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
