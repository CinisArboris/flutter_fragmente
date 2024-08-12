import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsUtils {
  static Future<void> guardarEstadoDescarga(bool estado, String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('update_downloaded', estado);
    await prefs.setString('apk_download_url', url);
  }

  static Future<void> limpiarEstadoDescarga() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('update_downloaded');
    await prefs.remove('apk_download_url');
    debugPrint('::::Estado de instalación limpiado.');
  }
}
