import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:install_plugin/install_plugin.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class ServicioGestorDeActualizacion {
  final String apkUrl;

  ServicioGestorDeActualizacion(this.apkUrl);

  Future<void> descargarEInstalarActualizacion(
      {Function(double)? onProgress,
      Function(double)? onBytesDownloaded}) async {
    try {
      var savePath = await obtenerRutaGuardado();

      debugPrint(
          '::::Iniciando la descarga de la actualización desde $apkUrl...');

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

      // Guardar en SharedPreferences que la actualización ha sido descargada y la URL
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('update_downloaded', true);
      await prefs.setString('apk_download_url', apkUrl);

      debugPrint('::::Descarga completa. Iniciando instalación...');
      await InstallPlugin.install(savePath);
      debugPrint('::::Instalación iniciada con éxito.');

      // Limpieza después de la instalación exitosa
      await limpiarDatosDeInstalacion();
    } catch (e) {
      debugPrint('::::Error durante la descarga o instalación de la APK: $e');
      rethrow;
    }
  }

  Future<String> obtenerRutaGuardado() async {
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
    debugPrint('::::Progreso descarga: ${progress.toStringAsFixed(2)}%');

    double mbDownloaded = count / (1024 * 1024);

    if (mbDownloaded - lastPrintMB >= 10 || mbDownloaded == totalSizeMB) {
      lastPrintMB = mbDownloaded;
      debugPrint(
          '::::Bytes descargados: ${mbDownloaded.toStringAsFixed(2)} MB de ${totalSizeMB.toStringAsFixed(2)} MB');
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
      debugPrint(
          '::::Bytes descargados: ${mbDownloaded.toStringAsFixed(2)} MB');
    }

    if (onBytesDownloaded != null) {
      onBytesDownloaded(mbDownloaded);
    }
  }

  Future<void> limpiarDatosDeInstalacion() async {
    final prefs = await SharedPreferences.getInstance();
    final apkFilePath = await obtenerRutaGuardado();

    // Eliminar el archivo APK
    final file = File(apkFilePath);
    if (await file.exists()) {
      await file.delete();
      debugPrint('::::APK eliminado después de la instalación.');
    }

    // Limpiar SharedPreferences
    await prefs.remove('update_downloaded');
    await prefs.remove('apk_download_url');
    debugPrint('::::Estado de instalación limpiado.');
  }
}
