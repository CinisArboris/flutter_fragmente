import 'package:install_plugin/install_plugin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_mix/services/file_utils.dart';
import 'package:firebase_mix/services/prefs_utils.dart';

class UpdateManager {
  Future<void> limpiarDatosDeInstalacion(String apkUrl) async {
    final savePath = await FileUtils.obtenerRutaGuardado('app_update.apk');
    await FileUtils.eliminarArchivo(savePath);
    await PrefsUtils.limpiarEstadoDescarga();
  }

  Future<bool> isUpdateDownloaded(String apkUrl) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('update_downloaded') ?? false;
  }

  Future<void> installDownloadedUpdate(String apkUrl) async {
    final savePath = await FileUtils.obtenerRutaGuardado('app_update.apk');
    await InstallPlugin.install(savePath);
    await limpiarDatosDeInstalacion(apkUrl);
  }
}
