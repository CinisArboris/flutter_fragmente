import 'package:firebase_mix/utils_services/shared_preferences_apk.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/material.dart';

class TransformacionesAPK {
  static void _logWithSeparator(String message) {
    debugPrint('\n----------------------------------------');
    debugPrint(':::: TransformacionesAPK - $message');
    debugPrint('----------------------------------------\n');
  }

  // Setters

  /// Guarda la URL del APK y procesa su nombre para almacenarlo
  static Future<void> setApkUrlAndProcessFileName(String url) async {
    await SharedPreferencesAPK.setApkUrl(url);
    await _setApkFileNameFromUrl(url);
  }

  /// Guarda el nombre del archivo APK extraído desde la URL
  static Future<void> _setApkFileNameFromUrl(String url) async {
    String fileName = _extractFileNameFromUrl(url);
    await SharedPreferencesAPK.setApkFileName(fileName);
  }

  // Getters

  /// Obtiene la URL del APK guardada en SharedPreferences
  static Future<String?> getSavedApkUrl() async {
    return await SharedPreferencesAPK.getApkUrl();
  }

  /// Obtiene la ruta completa de guardado para el archivo APK
  static Future<String> getApkSavePath() async {
    String? fileName = await SharedPreferencesAPK.getApkFileName();
    if (fileName == null) {
      _logWithSeparator(
          'Error: Nombre del archivo APK no encontrado en SharedPreferences');
      throw Exception('Nombre del archivo APK no encontrado');
    }
    var appDocDir = await getTemporaryDirectory();
    String filePath = "${appDocDir.path}/$fileName";
    _logWithSeparator('Ruta de guardado obtenida: $filePath');
    return filePath;
  }

  /// Verifica si la actualización de la APK ya se ha descargado
  static Future<bool> isApkUpdateDownloaded() async {
    final updateDownloaded = await SharedPreferencesAPK.isApkUpdateDownloaded();
    _logWithSeparator(
        'Estado de descarga de la APK: ${updateDownloaded ? "Descargada" : "No descargada"}');
    return updateDownloaded;
  }

  // Transformaciones

  /// Extrae el nombre del archivo desde la URL proporcionada
  static String _extractFileNameFromUrl(String url) {
    Uri uri = Uri.parse(url);
    String fileName = uri.pathSegments.last;
    _logWithSeparator('Nombre de archivo extraído de la URL: $fileName');
    return fileName;
  }

  /// Verifica si el archivo APK existe en la ruta de guardado
  static Future<bool> checkIfApkExists() async {
    String filePath = await getApkSavePath();
    final file = File(filePath);
    bool exists = await file.exists();
    _logWithSeparator(
        'Verificación de archivo en $filePath: ${exists ? "Existe" : "No existe"}');
    return exists;
  }

  /// Elimina el archivo APK si existe en la ruta de guardado
  static Future<void> deleteExistingApk() async {
    String filePath = await getApkSavePath();
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
      _logWithSeparator('Archivo eliminado: $filePath');
    } else {
      _logWithSeparator('Archivo no encontrado para eliminar: $filePath');
    }
  }
}
