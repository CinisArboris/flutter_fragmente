import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:install_plugin/install_plugin.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

class ServiceCheckVersion {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;
  String localVersion = ''; // Versión instalada en el dispositivo
  String remoteVersion = ''; // Versión obtenida desde Firebase
  String remoteDetail = ''; // Detalle de la versión desde Firebase
  String remoteApkUrl = ''; // URL de descarga de la APK desde Firebase
  bool isUpdateAvailable = false;

  Future<void> checkVersion() async {
    try {
      debugPrint('::::Configurando Firebase Remote Config...');
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(minutes: 1),
      ));
      debugPrint('::::Firebase Remote Config configurado.');

      debugPrint('::::Fetching y activando configuraciones...');
      await _remoteConfig.fetchAndActivate();
      debugPrint('::::Configuraciones activadas.');

      // Obteniendo datos desde Firebase Remote Config
      remoteVersion = _remoteConfig.getString('svr_ultima_version');
      remoteDetail = _remoteConfig.getString('svr_detalle_version');
      remoteApkUrl = _remoteConfig.getString('svr_url_descargar_apk');

      // Verificar si los datos obtenidos desde Firebase son válidos
      if (remoteVersion.isEmpty ||
          remoteDetail.isEmpty ||
          remoteApkUrl.isEmpty) {
        debugPrint(
            'Datos obtenidos desde Firebase son inválidos. Abandonando la comparación.');
        return;
      }

      debugPrint('::::Versión en servidor (Firebase): $remoteVersion');
      debugPrint('::::Detalle de la versión (Firebase): $remoteDetail');
      debugPrint('::::URL de descarga de la APK (Firebase): $remoteApkUrl');

      // Obteniendo la versión instalada en el dispositivo
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      localVersion = packageInfo.version;

      debugPrint('::::Versión del móvil (Local): $localVersion');
      debugPrint('::::Comparando versiones...');

      // Comparando la versión local con la versión remota
      if (localVersion != remoteVersion) {
        isUpdateAvailable = true;
        debugPrint('::::Se requiere actualización.');
      } else {
        debugPrint('::::No se requiere actualización.');
      }
    } catch (e) {
      debugPrint('::::Error durante la verificación de versión: $e');
      rethrow;
    }
  }

  Future<void> redirectToDownload() async {
    if (remoteApkUrl.isEmpty) {
      debugPrint(
          'URL de descarga de la APK es inválida. No se puede iniciar la descarga.');
      return;
    }

    try {
      var appDocDir = await getTemporaryDirectory();
      String savePath = "${appDocDir.path}/app_update.apk";

      debugPrint('::::Iniciando la descarga de la APK desde $remoteApkUrl...');
      await Dio().download(remoteApkUrl, savePath,
          onReceiveProgress: (count, total) {
        debugPrint(
            'Progreso de descarga: ${(count / total * 100).toStringAsFixed(0)}%');
      });

      debugPrint('::::Descarga completa. Iniciando instalación...');
      await InstallPlugin.install(savePath);
      debugPrint('::::Instalación iniciada con éxito.');
    } catch (e) {
      debugPrint('::::Error durante la descarga o instalación de la APK: $e');
      rethrow;
    }
  }
}
