import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/material.dart';

class FileUtils {
  static Future<String> obtenerRutaGuardado(String fileName) async {
    var appDocDir = await getTemporaryDirectory();
    return "${appDocDir.path}/$fileName";
  }

  static Future<void> eliminarArchivo(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
      debugPrint('::::Archivo eliminado: $filePath');
    }
  }

  static Future<bool> verificarArchivo(String filePath) async {
    final file = File(filePath);
    bool exists = await file.exists();
    debugPrint(
        '::::Verificación de archivo en $filePath: ${exists ? 'Existe' : 'No existe'}');
    return exists;
  }
}
