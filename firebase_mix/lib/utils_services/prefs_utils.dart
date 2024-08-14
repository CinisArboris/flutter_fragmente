import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsUtils {
  static void _logWithSeparator(String message) {
    debugPrint('\n----------------------------------------');
    debugPrint(':::: PrefsUtils - $message');
    debugPrint('----------------------------------------\n');
  }

  static Future<void> guardarEstadoDescarga(bool estado, String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('update_downloaded', estado);
    await prefs.setString('apk_download_url', url);
    _logWithSeparator('Estado de descarga guardado: $estado, URL: $url');
  }

  static Future<void> limpiarEstadoDescarga() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('update_downloaded');
    await prefs.remove('apk_download_url');
    _logWithSeparator('Estado de instalación limpiado.');
  }
}
