import 'package:firebase_mix/utils_firebase_udpate/transformaciones_apk.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:install_plugin/install_plugin.dart';
import 'package:dio/dio.dart';

class ServiceCheckVersion {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;
  String localVersion = ''; // Versión instalada en el dispositivo
  String remoteVersion = ''; // Versión obtenida desde Firebase
  String remoteDetail = ''; // Detalle de la versión desde Firebase
  String remoteApkUrl = ''; // URL de descarga de la APK desde Firebase
  bool isUpdateAvailable = false;

  static void _logWithSeparator(String message) {
    debugPrint('\n----------------------------------------');
    debugPrint(':::: ServiceCheckVersion - $message');
    debugPrint('----------------------------------------\n');
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

      // Guardar los detalles obtenidos desde Firebase en SharedPreferences a través de TransformacionesAPK
      await TransformacionesAPK.setApkVersion(remoteVersion);
      await TransformacionesAPK.setApkDetail(remoteDetail);
      await TransformacionesAPK.setApkUrlAndProcessFileName(remoteApkUrl);

      // Verificar si los datos obtenidos desde Firebase son válidos
      if (remoteVersion.isEmpty ||
          remoteDetail.isEmpty ||
          remoteApkUrl.isEmpty) {
        _logWithSeparator(
          'Datos obtenidos desde Firebase son inválidos. Abandonando la comparación.',
        );
        return;
      }

      _logWithSeparator(
        'Versión en servidor (Firebase): $remoteVersion\nDetalle de la versión (Firebase): $remoteDetail\nURL de descarga de la APK (Firebase): $remoteApkUrl',
      );

      // Obteniendo la versión instalada en el dispositivo
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      localVersion = packageInfo.version;

      _logWithSeparator(
        'Versión del móvil (Local): $localVersion\nComparando versiones...',
      );

      // Comparando la versión local con la versión remota
      if (localVersion != remoteVersion) {
        isUpdateAvailable = true;
        _logWithSeparator('Se requiere actualización.');
        await TransformacionesAPK.setApkUpdateDownloaded(false);
      } else {
        _logWithSeparator('No se requiere actualización.');
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
      final savePath = await TransformacionesAPK.getApkSavePath();

      _logWithSeparator(
        'Iniciando la descarga de la APK desde $remoteApkUrl...',
      );
      await Dio().download(remoteApkUrl, savePath,
          onReceiveProgress: (count, total) {
        _logWithSeparator(
          'Progreso de descarga: ${(count / total * 100).toStringAsFixed(0)}%',
        );
      });

      _logWithSeparator('Descarga completa. Iniciando instalación...');
      await TransformacionesAPK.setApkUpdateDownloaded(true);
      await installDownloadedUpdate(savePath);
    } catch (e) {
      _logWithSeparator(
        'Error durante la descarga o instalación de la APK: $e',
      );
      rethrow;
    }
  }

  Future<void> installDownloadedUpdate(String savePath) async {
    await InstallPlugin.install(savePath);
    if (await _isVersionUpdated()) {
      // No se limpia la instalación automáticamente
      _logWithSeparator('Instalación completada con éxito.');
    }
  }

  Future<bool> _isVersionUpdated() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version == remoteVersion;
  }

  // No se incluye la eliminación automática del APK
  Future<void> limpiarDatosDeInstalacion() async {
    await TransformacionesAPK.clearApkDownloadState();
    _logWithSeparator('Datos de instalación limpiados (sin eliminar APK).');
  }

  Future<bool> isUpdateDownloaded() async {
    return await TransformacionesAPK.isApkUpdateDownloaded();
  }
}
