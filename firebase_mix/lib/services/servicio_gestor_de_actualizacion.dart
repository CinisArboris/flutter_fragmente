import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:install_plugin/install_plugin.dart';
import '../utils_services/transformaciones_apk.dart';

class ServicioGestorDeActualizacion {
  final String apkUrl;

  ServicioGestorDeActualizacion(this.apkUrl);

  Future<void> descargarEInstalarActualizacion({
    Function(double)? onProgress,
    Function(double)? onBytesDownloaded,
  }) async {
    // Verificar si ya se está descargando o instalando
    if (await TransformacionesAPK.isDownloading() ||
        await TransformacionesAPK.isInstalling()) {
      debugPrint(
        ':::: Servicio Gestor Actualizacion - Operación de descarga o instalación ya en curso.',
      );
      return;
    }

    try {
      // Marcar como en curso la descarga
      await TransformacionesAPK.setDownloading(true);

      // Obtener la ruta de guardado para el archivo APK
      var savePath = await TransformacionesAPK.getApkSavePath();

      debugPrint(
        ':::: Servicio Gestor Actualizacion - Iniciando la descarga de la actualización desde $apkUrl...',
      );

      double lastPrintMB = 0;

      await Dio().download(
        apkUrl,
        savePath,
        onReceiveProgress: (count, total) {
          lastPrintMB = _handleProgressWithoutTotal(
              count, lastPrintMB, onProgress, onBytesDownloaded);
        },
      );

      // Guardar en TransformacionesAPK que la actualización ha sido descargada
      await TransformacionesAPK.setApkUpdateDownloaded(true);

      debugPrint(
        ':::: Servicio Gestor Actualizacion - Descarga completa. Iniciando instalación...',
      );
      await TransformacionesAPK.setDownloading(false); // Descargar completada

      // Verificar si el archivo realmente existe antes de intentar la instalación
      final fileExists = await TransformacionesAPK.checkIfApkExists();
      if (fileExists) {
        await TransformacionesAPK.setInstalling(
            true); // Marcar como en curso la instalación
        await InstallPlugin.install(savePath);
        debugPrint(
          ':::: Servicio Gestor Actualizacion - Instalación iniciada con éxito.',
        );

        // Marcar instalación como completada
        await TransformacionesAPK.setInstalling(false);
      } else {
        debugPrint(
          ':::: Servicio Gestor Actualizacion - Error: El archivo APK no se encontró en la ruta especificada.',
        );
      }
    } catch (e) {
      debugPrint(
        ':::: Servicio Gestor Actualizacion - Error durante la descarga o instalación de la APK: $e',
      );
      await TransformacionesAPK.setDownloading(false);
      await TransformacionesAPK.setInstalling(false);
      rethrow;
    }
  }

  double _handleProgressWithoutTotal(
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

  Future<void> installDownloadedUpdate(String savePath) async {
    try {
      // Verificar si el archivo realmente existe antes de intentar la instalación
      final fileExists = await TransformacionesAPK.checkIfApkExists();
      if (!fileExists) {
        debugPrint(
            ':::: Servicio Gestor Actualizacion - Error: El archivo APK no se encontró en la ruta: $savePath');
        return;
      }

      // Marcar como en curso la instalación
      await TransformacionesAPK.setInstalling(true);
      debugPrint(':::: Servicio Gestor - Iniciando instalación...');
      debugPrint(':::: $savePath');

      // Iniciar la instalación del APK
      await InstallPlugin.install(savePath).then((result) {
        debugPrint(
            ':::: Servicio Gestor Actualizacion - Instalación completada con resultado: $result');
      }).catchError((error) {
        debugPrint(
            ':::: Servicio Gestor Actualizacion - Error durante la instalación del APK: $error');
        throw error;
      });
    } catch (e) {
      debugPrint(
          ':::: Servicio Gestor Actualizacion - Excepción capturada durante la instalación: $e');
      rethrow; // Re-lanzar el error para que pueda ser manejado externamente si es necesario
    } finally {
      // Marcar la instalación como completada (esto se realiza sin importar si hay un error)
      await TransformacionesAPK.setInstalling(false);
      debugPrint(
          ':::: Servicio Gestor Actualizacion - Proceso de instalación finalizado.');
    }
  }
}
