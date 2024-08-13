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
      debugPrint(
        ':::: Servicio Gestor Actualizacion - Operación de descarga o instalación ya en curso.',
      );
      return;
    }

    try {
      await FlagsUtils.setDownloading(true); // Marcar como en curso la descarga
      var savePath = await FileUtils.obtenerRutaGuardado('app_update.apk');

      debugPrint(
        ':::: Servicio Gestor Actualizacion - Iniciando la descarga de la actualización desde $apkUrl...',
      );

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

      debugPrint(
        ':::: Servicio Gestor Actualizacion - Descarga completa. Iniciando instalación...',
      );
      await FlagsUtils.setDownloading(false); // Descargar completada

      // Verificar si el archivo realmente existe antes de intentar la instalación
      final fileExists = await FileUtils.verificarArchivo(savePath);
      if (fileExists) {
        await FlagsUtils.setInstalling(
            true); // Marcar como en curso la instalación
        await InstallPlugin.install(savePath);
        debugPrint(
          ':::: Servicio Gestor Actualizacion - Instalación iniciada con éxito.',
        );

        // Puedes limpiar los datos de instalación aquí si la instalación fue exitosa
        // await limpiarDatosDeInstalacion(); // Solo si es seguro borrar los archivos

        // Marcar instalación como completada
        await FlagsUtils.setInstalling(false);
      } else {
        debugPrint(
          ':::: Servicio Gestor Actualizacion - Error: El archivo APK no se encontró en la ruta especificada.',
        );
      }
    } catch (e) {
      debugPrint(
        ':::: Servicio Gestor Actualizacion - Error durante la descarga o instalación de la APK: $e',
      );
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
      debugPrint(
        ':::: Servicio Gestor Actualizacion - Bytes descargados: ${lastPrintMB.toStringAsFixed(2)} MB',
      );
    }

    if (onBytesDownloaded != null) {
      onBytesDownloaded(mbDownloaded);
    }

    return lastPrintMB;
  }

  // Este método no se llama automáticamente ahora, solo cuando estés seguro de que
  // la instalación fue completada y es seguro limpiar
  Future<void> limpiarDatosDeInstalacion() async {
    final savePath = await FileUtils.obtenerRutaGuardado('app_update.apk');
    await FileUtils.eliminarArchivo(savePath);
    await PrefsUtils.limpiarEstadoDescarga();
    await FlagsUtils.clearFlags();
    debugPrint(
      ':::: Servicio Gestor Actualizacion - Datos de instalación limpiados.',
    );
  }
}
