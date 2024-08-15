import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesAPK {
  static const String _isDownloadingKey = 'is_downloading';
  static const String _isInstallingKey = 'is_installing';
  static const String _apkUrlKey = 'apk_url';
  static const String _apkFileNameKey = 'apk_file_name';
  static const String _updateDownloadedKey = 'update_downloaded';
  static const String _apkVersionKey = 'apk_version';
  static const String _apkDetailKey = 'apk_detail';

  static void _logWithSeparator(String message) {
    // debugPrint('\n----------------------------------------');
    // debugPrint(':::: SharedPreferencesAPK - $message');
    // debugPrint('----------------------------------------\n');
  }

  // Setters

  /// Guarda el estado de la flag "isDownloading"
  static Future<void> setDownloading(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isDownloadingKey, value);
    _logWithSeparator('Flag "isDownloading" guardada con valor: $value');
  }

  /// Guarda el estado de la flag "isInstalling"
  static Future<void> setInstalling(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isInstallingKey, value);
    _logWithSeparator('Flag "isInstalling" guardada con valor: $value');
  }

  /// Guarda la URL de la APK
  static Future<void> setApkUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_apkUrlKey, url);
    _logWithSeparator('URL de la APK guardada: $url');
  }

  /// Guarda el nombre del archivo APK
  static Future<void> setApkFileName(String fileName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_apkFileNameKey, fileName);
    _logWithSeparator('Nombre del archivo APK guardado: $fileName');
  }

  /// Guarda el estado de la descarga de la APK
  static Future<void> setApkUpdateDownloaded(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_updateDownloadedKey, value);
    _logWithSeparator('Estado de descarga de APK guardado: $value');
  }

  /// Guarda la versión del APK
  static Future<void> setApkVersion(String version) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_apkVersionKey, version);
    _logWithSeparator('Versión del APK guardada: $version');
  }

  /// Guarda el detalle de la versión del APK
  static Future<void> setApkDetail(String detail) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_apkDetailKey, detail);
    _logWithSeparator('Detalle del APK guardado: $detail');
  }

  // Getters

  /// Obtiene el estado de la flag "isDownloading"
  static Future<bool> isDownloading() async {
    final prefs = await SharedPreferences.getInstance();
    bool value = prefs.getBool(_isDownloadingKey) ?? false;
    _logWithSeparator('Flag "isDownloading" obtenida con valor: $value');
    return value;
  }

  /// Obtiene el estado de la flag "isInstalling"
  static Future<bool> isInstalling() async {
    final prefs = await SharedPreferences.getInstance();
    bool value = prefs.getBool(_isInstallingKey) ?? false;
    _logWithSeparator('Flag "isInstalling" obtenida con valor: $value');
    return value;
  }

  /// Obtiene la URL de la APK
  static Future<String?> getApkUrl() async {
    final prefs = await SharedPreferences.getInstance();
    String? url = prefs.getString(_apkUrlKey);
    _logWithSeparator('URL de la APK obtenida: $url');
    return url;
  }

  /// Obtiene el nombre del archivo APK
  static Future<String?> getApkFileName() async {
    final prefs = await SharedPreferences.getInstance();
    String? fileName = prefs.getString(_apkFileNameKey);
    _logWithSeparator('Nombre del archivo APK obtenido: $fileName');
    return fileName;
  }

  /// Obtiene el estado de la descarga de la APK
  static Future<bool> isApkUpdateDownloaded() async {
    final prefs = await SharedPreferences.getInstance();
    bool value = prefs.getBool(_updateDownloadedKey) ?? false;
    _logWithSeparator('Estado de descarga de APK obtenido con valor: $value');
    return value;
  }

  /// Obtiene la versión del APK
  static Future<String?> getApkVersion() async {
    final prefs = await SharedPreferences.getInstance();
    String? version = prefs.getString(_apkVersionKey);
    _logWithSeparator('Versión del APK obtenida: $version');
    return version;
  }

  /// Obtiene el detalle de la versión del APK
  static Future<String?> getApkDetail() async {
    final prefs = await SharedPreferences.getInstance();
    String? detail = prefs.getString(_apkDetailKey);
    _logWithSeparator('Detalle del APK obtenido: $detail');
    return detail;
  }

  // Clear methods

  /// Limpia el estado de la descarga de la APK y las flags relacionadas
  static Future<void> clearApkDownloadState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_updateDownloadedKey);
    await prefs.remove(_apkUrlKey);
    await prefs.remove(_apkFileNameKey);
    await prefs.remove(_apkVersionKey);
    await prefs.remove(_apkDetailKey);
    _logWithSeparator('Estado de instalación y flags relacionadas limpiadas.');
  }

  /// Limpia todas las flags y datos relacionados
  static Future<void> clearAllFlags() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_isDownloadingKey);
    await prefs.remove(_isInstallingKey);
    await prefs.remove(_apkUrlKey);
    await prefs.remove(_apkFileNameKey);
    await prefs.remove(_updateDownloadedKey);
    await prefs.remove(_apkVersionKey);
    await prefs.remove(_apkDetailKey);
    _logWithSeparator('Todas las flags y datos relacionados limpiados.');
  }
}
