import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class VersionCheckService {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;
  String versionMiMovil = '';
  String svrUltimaVersion = '';
  String svrDetalleVersion = '';
  String svrUrlDescargarApk = '';
  bool isUpdateAvailable = false;

  Future<void> checkVersion() async {
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: const Duration(minutes: 1),
    ));
    await _remoteConfig.fetchAndActivate();

    svrUltimaVersion = _remoteConfig.getString('svr_ultima_version');
    svrDetalleVersion = _remoteConfig.getString('svr_detalle_version');
    svrUrlDescargarApk = _remoteConfig.getString('svr_url_descargar_apk');

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    versionMiMovil = packageInfo.version;

    debugPrint('ACTUALIZAR APK ?? :: $svrUltimaVersion|$versionMiMovil');

    if (versionMiMovil != svrUltimaVersion) {
      isUpdateAvailable = true;
    }
  }

  Future<void> redirectToDownload() async {
    final Uri url = Uri.parse(svrUrlDescargarApk);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'No se puede lanzar $svrUrlDescargarApk';
    }
  }
}
