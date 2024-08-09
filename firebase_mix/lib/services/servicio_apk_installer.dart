import 'package:install_plugin/install_plugin.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ApkInstaller {
  final String apkUrl;
  double _progressValue = 0.0;

  ApkInstaller(this.apkUrl);

  Future<void> downloadAndInstallApk() async {
    try {
      var appDocDir = await getTemporaryDirectory();
      String savePath = "${appDocDir.path}/app_update.apk";

      debugPrint('Iniciando la descarga de la APK desde $apkUrl...');
      await Dio().download(apkUrl, savePath, onReceiveProgress: (count, total) {
        if (total != 0) {
          _progressValue = (count / total) * 100; // Progreso en porcentaje
          _progressValue = _progressValue.clamp(
              0.0, 100.0); // Asegura que el progreso esté entre 0 y 100
        } else {
          _progressValue = 0.0;
        }
        debugPrint(
            'Progreso de descarga: ${_progressValue.toStringAsFixed(2)}%');
      });

      debugPrint('Descarga completa. Iniciando instalación...');
      await InstallPlugin.install(savePath);
      debugPrint('Instalación iniciada con éxito.');
    } catch (e) {
      debugPrint('Error durante la descarga o instalación de la APK: $e');
      throw e;
    }
  }

  String get progressValue => _progressValue.toStringAsFixed(2);
}
