import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesAPK {
  static const String _isDownloadingKey = 'is_downloading';
  static const String _isInstallingKey = 'is_installing';
  static const String _apkUrlKey = 'apk_url';
  static const String _apkFileNameKey = 'apk_file_name';
  static const String _updateDownloadedKey = 'update_downloaded';

  static void _logWithSeparator(String message) {
    debugPrint('\n----------------------------------------');
    debugPrint(':::: SharedPreferencesAPK - $message');
    debugPrint('----------------------------------------\n');
  }

  // Guardar estado de la flag "isDownloading"
  static Future<void> setDownloading(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isDownloadingKey, value);
    _logWithSeparator('Flag "isDownloading" guardada con valor: $value');
  }

  // Obtener estado de la flag "isDownloading"
  static Future<bool> isDownloading() async {
    final prefs = await SharedPreferences.getInstance();
    bool value = prefs.getBool(_isDownloadingKey) ?? false;
    _logWithSeparator('Flag "isDownloading" obtenida con valor: $value');
    return value;
  }

  // Guardar estado de la flag "isInstalling"
  static Future<void> setInstalling(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isInstallingKey, value);
    _logWithSeparator('Flag "isInstalling" guardada con valor: $value');
  }

  // Obtener estado de la flag "isInstalling"
  static Future<bool> isInstalling() async {
    final prefs = await SharedPreferences.getInstance();
    bool value = prefs.getBool(_isInstallingKey) ?? false;
    _logWithSeparator('Flag "isInstalling" obtenida con valor: $value');
    return value;
  }

  // Guardar la URL de la APK
  static Future<void> setApkUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_apkUrlKey, url);
    _logWithSeparator('URL de la APK guardada: $url');
  }

  // Obtener la URL de la APK
  static Future<String?> getApkUrl() async {
    final prefs = await SharedPreferences.getInstance();
    String? url = prefs.getString(_apkUrlKey);
    _logWithSeparator('URL de la APK obtenida: $url');
    return url;
  }

  // Guardar el nombre del archivo APK
  static Future<void> setApkFileName(String fileName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_apkFileNameKey, fileName);
    _logWithSeparator('Nombre del archivo APK guardado: $fileName');
  }

  // Obtener el nombre del archivo APK
  static Future<String?> getApkFileName() async {
    final prefs = await SharedPreferences.getInstance();
    String? fileName = prefs.getString(_apkFileNameKey);
    _logWithSeparator('Nombre del archivo APK obtenido: $fileName');
    return fileName;
  }

  // Guardar estado de la descarga y la URL de la APK
  static Future<void> guardarEstadoDescarga(bool estado, String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_updateDownloadedKey, estado);
    await prefs.setString(_apkUrlKey, url);
    _logWithSeparator('Estado de descarga guardado: $estado, URL: $url');
  }

  // Limpiar estado de la descarga y las flags
  static Future<void> limpiarEstadoDescarga() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_updateDownloadedKey);
    await prefs.remove(_apkUrlKey);
    _logWithSeparator('Estado de instalación limpiado.');
  }

  // Limpiar todas las flags y datos relacionados
  static Future<void> clearFlags() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_isDownloadingKey);
    await prefs.remove(_isInstallingKey);
    await prefs.remove(_apkUrlKey);
    await prefs.remove(_apkFileNameKey);
    _logWithSeparator(
        'Flags "isDownloading", "isInstalling", "apkUrl" y "apkFileName" limpiadas.');
  }
}
