import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class VersionCheckService {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;
  String versionMiMovil = '';
  String svrTextoVersion = '';
  String svrDetalleVersion = '';
  String clienteLatestApkUrl = '';
  bool isUpdateAvailable = false;

  Future<void> checkVersion() async {
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: const Duration(hours: 1),
    ));
    await _remoteConfig.fetchAndActivate();

    svrTextoVersion = _remoteConfig.getString('svr_texto_version');
    svrDetalleVersion = _remoteConfig.getString('svr_detalle_version');
    clienteLatestApkUrl = _remoteConfig.getString('cliente_latest_apk_url');

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    versionMiMovil = packageInfo.version;

    if (versionMiMovil != svrTextoVersion) {
      isUpdateAvailable = true;
    }
  }

  Future<void> redirectToDownload() async {
    final Uri url = Uri.parse(clienteLatestApkUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'No se puede lanzar $clienteLatestApkUrl';
    }
  }
}
