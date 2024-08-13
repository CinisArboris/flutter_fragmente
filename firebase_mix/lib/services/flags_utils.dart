import 'package:shared_preferences/shared_preferences.dart';

class FlagsUtils {
  static const String _isDownloadingKey = 'is_downloading';
  static const String _isInstallingKey = 'is_installing';

  // Guardar estado de la flag "isDownloading"
  static Future<void> setDownloading(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isDownloadingKey, value);
  }

  // Obtener estado de la flag "isDownloading"
  static Future<bool> isDownloading() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isDownloadingKey) ?? false;
  }

  // Guardar estado de la flag "isInstalling"
  static Future<void> setInstalling(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isInstallingKey, value);
  }

  // Obtener estado de la flag "isInstalling"
  static Future<bool> isInstalling() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isInstallingKey) ?? false;
  }

  // Limpiar flags
  static Future<void> clearFlags() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_isDownloadingKey);
    await prefs.remove(_isInstallingKey);
  }
}
