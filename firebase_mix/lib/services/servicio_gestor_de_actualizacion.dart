import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:install_plugin/install_plugin.dart';
import 'file_utils.dart';
import 'prefs_utils.dart';
import 'flags_utils.dart';

class ServicioGestorDeActualizacion {
  final String apkUrl;

  ServicioGestorDeActualizacion(this.apkUrl);

  Future<void> descargarEInstalarActualizacion({
    Function(double)? onProgress,
    Function(double)? onBytesDownloaded,
  }) async {
    // Verificar si ya se está descargando o instalando
    if (await FlagsUtils.isDownloading() || await FlagsUtils.isInstalling()) {
      debugPrint('::::Operación de descarga o instalación ya en curso.');
      return;
    }

    try {
      await FlagsUtils.setDownloading(true); // Marcar como en curso la descarga
      var savePath = await FileUtils.obtenerRutaGuardado('app_update.apk');

      debugPrint(
          '::::Iniciando la descarga de la actualización desde $apkUrl...');

      double lastPrintMB = 0;

      await Dio().download(
        apkUrl,
        savePath,
        onReceiveProgress: (count, total) {
          lastPrintMB = _manejarProgresoSinTotal(
              count, lastPrintMB, onProgress, onBytesDownloaded);
        },
      );

      // Guardar en SharedPreferences que la actualización ha sido descargada y la URL
      await PrefsUtils.guardarEstadoDescarga(true, apkUrl);

      debugPrint('::::Descarga completa. Iniciando instalación...');
      await FlagsUtils.setDownloading(false); // Descargar completada

      // Verificar si el archivo realmente existe antes de intentar la instalación
      final fileExists = await FileUtils.verificarArchivo(savePath);
      if (fileExists) {
        await FlagsUtils.setInstalling(
            true); // Marcar como en curso la instalación
        await InstallPlugin.install(savePath);
        debugPrint('::::Instalación iniciada con éxito.');

        // Limpieza después de la instalación exitosa
        await limpiarDatosDeInstalacion();
        await FlagsUtils.setInstalling(
            false); // Marcar instalación como completada
      } else {
        debugPrint(
            '::::Error: El archivo APK no se encontró en la ruta especificada.');
      }
    } catch (e) {
      debugPrint('::::Error durante la descarga o instalación de la APK: $e');
      await FlagsUtils.setDownloading(false);
      await FlagsUtils.setInstalling(false);
      rethrow;
    }
  }

  double _manejarProgresoSinTotal(
    int count,
    double lastPrintMB,
    Function(double)? onProgress,
    Function(double)? onBytesDownloaded,
  ) {
    double mbDownloaded = count / (1024 * 1024);

    // Mostrar log solo en múltiplos exactos de 5 MB
    if (mbDownloaded >= lastPrintMB + 5) {
      lastPrintMB +=
          5; // Incrementa de 5 en 5 para asegurar la siguiente impresión correcta
      debugPrint('::::Bytes descargados: ${lastPrintMB.toStringAsFixed(2)} MB');
    }

    if (onBytesDownloaded != null) {
      onBytesDownloaded(mbDownloaded);
    }

    return lastPrintMB;
  }

  Future<void> limpiarDatosDeInstalacion() async {
    final savePath = await FileUtils.obtenerRutaGuardado('app_update.apk');
    await FileUtils.eliminarArchivo(savePath);
    await PrefsUtils.limpiarEstadoDescarga();
    await FlagsUtils.clearFlags();
  }
}
