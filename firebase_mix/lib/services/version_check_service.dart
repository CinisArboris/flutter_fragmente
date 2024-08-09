import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:install_plugin/install_plugin.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

class VersionCheckService {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;
  String versionMiMovil = '';
  String svrUltimaVersion = '';
  String svrDetalleVersion = '';
  String svrUrlDescargarApk = '';
  bool isUpdateAvailable = false;

  Future<void> checkVersion() async {
    try {
      debugPrint('Configurando Firebase Remote Config...');
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(minutes: 1),
      ));
      debugPrint('Firebase Remote Config configurado.');

      debugPrint('Fetching y activando configuraciones...');
      await _remoteConfig.fetchAndActivate();
      debugPrint('Configuraciones activadas.');

      svrUltimaVersion = _remoteConfig.getString('svr_ultima_version');
      svrDetalleVersion = _remoteConfig.getString('svr_detalle_version');
      svrUrlDescargarApk = _remoteConfig.getString('svr_url_descargar_apk');

      debugPrint('Versión en servidor: $svrUltimaVersion');
      debugPrint('Detalle de la versión: $svrDetalleVersion');
      debugPrint('URL de descarga de la APK: $svrUrlDescargarApk');

      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      versionMiMovil = packageInfo.version;

      debugPrint('Versión del móvil: $versionMiMovil');
      debugPrint('Comparando versiones...');

      if (versionMiMovil != svrUltimaVersion) {
        isUpdateAvailable = true;
        debugPrint('Se requiere actualización.');
      } else {
        debugPrint('No se requiere actualización.');
      }
    } catch (e) {
      debugPrint('Error durante la verificación de versión: $e');
      rethrow;
    }
  }

  Future<void> redirectToDownload() async {
    try {
      var appDocDir = await getTemporaryDirectory();
      String savePath = "${appDocDir.path}/app_update.apk";

      debugPrint(
          'Iniciando la descarga de la APK desde $svrUrlDescargarApk...');
      await Dio().download(svrUrlDescargarApk, savePath,
          onReceiveProgress: (count, total) {
        debugPrint(
            'Progreso de descarga: ${(count / total * 100).toStringAsFixed(0)}%');
      });

      debugPrint('Descarga completa. Iniciando instalación...');
      await InstallPlugin.install(savePath);
      debugPrint('Instalación iniciada con éxito.');
    } catch (e) {
      debugPrint('Error durante la descarga o instalación de la APK: $e');
      rethrow;
    }
  }
}
