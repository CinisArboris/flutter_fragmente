import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:install_plugin/install_plugin.dart';
import 'package:path_provider/path_provider.dart';

class ApkInstaller {
  final String apkUrl;
  double _progressValue = 0.0;

  ApkInstaller(this.apkUrl);

  // Aquí definimos el parámetro opcional onProgress
  Future<void> downloadAndInstallApk({Function(double)? onProgress}) async {
    try {
      var appDocDir = await getTemporaryDirectory();
      String savePath = "${appDocDir.path}/app_update.apk";

      debugPrint('Iniciando la descarga de la APK desde $apkUrl...');
      await Dio().download(apkUrl, savePath, onReceiveProgress: (count, total) {
        if (total != 0) {
          _progressValue = (count / total) * 100;
          _progressValue = _progressValue.clamp(0.0, 100.0);
          debugPrint(
              'Progreso descarga: ${_progressValue.toStringAsFixed(2)}%');

          // Si se ha proporcionado el callback onProgress, llámalo
          if (onProgress != null) {
            onProgress(_progressValue);
          }
        } else {
          debugPrint('Error: Total de bytes es 0.');
        }
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
