import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:install_plugin/install_plugin.dart';
import 'package:path_provider/path_provider.dart';

class GestorDeActualizaciones {
  final String apkUrl;

  GestorDeActualizaciones(this.apkUrl);

  Future<void> descargarEInstalarActualizacion(
      {Function(double)? onProgress,
      Function(double)? onBytesDownloaded}) async {
    try {
      var savePath = await _obtenerRutaGuardado();

      debugPrint('Iniciando la descarga de la actualización desde $apkUrl...');

      double totalSizeMB = 0;
      double lastPrintMB = 0;

      await Dio().download(
        apkUrl,
        savePath,
        onReceiveProgress: (count, total) {
          if (total != -1) {
            totalSizeMB = _calcularTamanoTotalMB(total);
            _manejarProgreso(count, total, totalSizeMB, lastPrintMB, onProgress,
                onBytesDownloaded);
          } else {
            _manejarProgresoSinTotal(count, lastPrintMB, onBytesDownloaded);
          }
        },
      );

      debugPrint('Descarga completa. Iniciando instalación...');
      await InstallPlugin.install(savePath);
      debugPrint('Instalación iniciada con éxito.');
    } catch (e) {
      debugPrint('Error durante la descarga o instalación de la APK: $e');
      throw e;
    }
  }

  Future<String> _obtenerRutaGuardado() async {
    var appDocDir = await getTemporaryDirectory();
    return "${appDocDir.path}/app_update.apk";
  }

  double _calcularTamanoTotalMB(int total) {
    return total / (1024 * 1024);
  }

  void _manejarProgreso(
      int count,
      int total,
      double totalSizeMB,
      double lastPrintMB,
      Function(double)? onProgress,
      Function(double)? onBytesDownloaded) {
    double progress = (count / total) * 100;
    progress = progress.clamp(0.0, 100.0);
    debugPrint('Progreso descarga: ${progress.toStringAsFixed(2)}%');

    double mbDownloaded = count / (1024 * 1024);

    if (mbDownloaded - lastPrintMB >= 10 || mbDownloaded == totalSizeMB) {
      lastPrintMB = mbDownloaded;
      debugPrint(
          'Bytes descargados: ${mbDownloaded.toStringAsFixed(2)} MB de ${totalSizeMB.toStringAsFixed(2)} MB');
    }

    if (onProgress != null) {
      onProgress(progress);
    }

    if (onBytesDownloaded != null) {
      onBytesDownloaded(mbDownloaded);
    }
  }

  void _manejarProgresoSinTotal(
      int count, double lastPrintMB, Function(double)? onBytesDownloaded) {
    double mbDownloaded = count / (1024 * 1024);

    if (mbDownloaded - lastPrintMB >= 10) {
      lastPrintMB = mbDownloaded;
      debugPrint('Bytes descargados: ${mbDownloaded.toStringAsFixed(2)} MB');
    }

    if (onBytesDownloaded != null) {
      onBytesDownloaded(mbDownloaded);
    }
  }
}
