import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:install_plugin/install_plugin.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils_services/file_utils.dart';
import '../utils_services/prefs_utils.dart';

class ServiceCheckVersion {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;
  String localVersion = ''; // Versión instalada en el dispositivo
  String remoteVersion = ''; // Versión obtenida desde Firebase
  String remoteDetail = ''; // Detalle de la versión desde Firebase
  String remoteApkUrl = ''; // URL de descarga de la APK desde Firebase
  bool isUpdateAvailable = false;

  void _logWithSeparator(String message) {
    debugPrint(
        '\n-----------------------------\n$message\n-----------------------------\n');
  }

  Future<void> checkVersion() async {
    try {
      _logWithSeparator('Configurando Firebase Remote Config...');
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(minutes: 1),
      ));
      _logWithSeparator('Firebase Remote Config configurado.');

      _logWithSeparator('Fetching y activando configuraciones...');
      await _remoteConfig.fetchAndActivate();
      _logWithSeparator('Configuraciones activadas.');

      // Obteniendo datos desde Firebase Remote Config
      remoteVersion = _remoteConfig.getString('svr_ultima_version');
      remoteDetail = _remoteConfig.getString('svr_detalle_version');
      remoteApkUrl = _remoteConfig.getString('svr_url_descargar_apk');

      // Verificar si los datos obtenidos desde Firebase son válidos
      if (remoteVersion.isEmpty ||
          remoteDetail.isEmpty ||
          remoteApkUrl.isEmpty) {
        _logWithSeparator(
            'Datos obtenidos desde Firebase son inválidos. Abandonando la comparación.');
        return;
      }

      _logWithSeparator('Versión en servidor (Firebase): $remoteVersion\n'
          'Detalle de la versión (Firebase): $remoteDetail\n'
          'URL de descarga de la APK (Firebase): $remoteApkUrl');

      // Obteniendo la versión instalada en el dispositivo
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      localVersion = packageInfo.version;

      _logWithSeparator('Versión del móvil (Local): $localVersion\n'
          'Comparando versiones...');

      // Comparando la versión local con la versión remota
      if (localVersion != remoteVersion) {
        isUpdateAvailable = true;
        _logWithSeparator('Se requiere actualización.');
      } else {
        _logWithSeparator('No se requiere actualización.');
        await limpiarDatosDeInstalacion(); // Limpia datos si no se necesita actualización
      }
    } catch (e) {
      _logWithSeparator('Error durante la verificación de versión: $e');
      rethrow;
    }
  }

  Future<void> redirectToDownload() async {
    if (remoteApkUrl.isEmpty) {
      _logWithSeparator(
          'URL de descarga de la APK es inválida. No se puede iniciar la descarga.');
      return;
    }

    try {
      var appDocDir = await getTemporaryDirectory();
      String savePath = "${appDocDir.path}/app_update.apk";

      _logWithSeparator(
          'Iniciando la descarga de la APK desde $remoteApkUrl...');
      await Dio().download(remoteApkUrl, savePath,
          onReceiveProgress: (count, total) {
        _logWithSeparator(
            'Progreso de descarga: ${(count / total * 100).toStringAsFixed(0)}%');
      });

      _logWithSeparator('Descarga completa. Iniciando instalación...');
      await installDownloadedUpdate(savePath);
    } catch (e) {
      _logWithSeparator(
          'Error durante la descarga o instalación de la APK: $e');
      rethrow;
    }
  }

  Future<void> installDownloadedUpdate(String savePath) async {
    await InstallPlugin.install(savePath);
    if (await _isVersionUpdated()) {
      await limpiarDatosDeInstalacion(); // Limpiar solo si la instalación fue exitosa
    }
  }

  Future<bool> _isVersionUpdated() async {
    // Lógica para verificar si la versión instalada es la esperada
    // Se puede comparar la versión instalada actual con la esperada desde Firebase
    // Aquí simplemente devuelvo true para fines de ejemplo, pero deberías añadir la lógica necesaria
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version == remoteVersion;
  }

  Future<void> limpiarDatosDeInstalacion() async {
    final savePath = await FileUtils.obtenerRutaGuardado('app_update.apk');
    await FileUtils.eliminarArchivo(savePath);
    await PrefsUtils.limpiarEstadoDescarga();
    _logWithSeparator('Datos de instalación limpiados.');
  }

  Future<bool> isUpdateDownloaded() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('update_downloaded') ?? false;
  }
}
