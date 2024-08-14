import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/material.dart';

class UtilsAPK {
  static void _logWithSeparator(String message) {
    debugPrint('\n----------------------------------------');
    debugPrint(':::: UtilsAPK - $message');
    debugPrint('----------------------------------------\n');
  }

  // Nueva función para extraer el nombre del archivo desde la URL
  static String extraerNombreDesdeUrl(String url) {
    Uri uri = Uri.parse(url);
    String fileName = uri.pathSegments.last;
    _logWithSeparator('Nombre de archivo extraído de la URL: $fileName');
    return fileName;
  }

  static Future<String> obtenerRutaGuardado(String fileName) async {
    var appDocDir = await getTemporaryDirectory();
    String filePath = "${appDocDir.path}/$fileName";
    _logWithSeparator('Ruta de guardado obtenida: $filePath');
    return filePath;
  }

  static Future<void> eliminarArchivo(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
      _logWithSeparator('Archivo eliminado: $filePath');
    } else {
      _logWithSeparator('Archivo no encontrado para eliminar: $filePath');
    }
  }

  static Future<bool> verificarArchivo(String filePath) async {
    final file = File(filePath);
    bool exists = await file.exists();
    _logWithSeparator(
        'Verificación de archivo en $filePath: ${exists ? 'Existe' : 'No existe'}');
    return exists;
  }
}
