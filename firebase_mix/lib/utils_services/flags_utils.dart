import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FlagsUtils {
  static const String _isDownloadingKey = 'is_downloading';
  static const String _isInstallingKey = 'is_installing';

  static void _logWithSeparator(String message) {
    debugPrint('\n----------------------------------------');
    debugPrint(':::: FlagsUtils - $message');
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

  // Limpiar flags
  static Future<void> clearFlags() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_isDownloadingKey);
    await prefs.remove(_isInstallingKey);
    _logWithSeparator('Flags "isDownloading" y "isInstalling" limpiadas.');
  }
}
