import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'remote_config_service.dart';

class VersionCheckService {
  final RemoteConfigService _remoteConfigService = RemoteConfigService();
  String versionMiMovil = '';
  String textoRandom = '';
  String latestVersion = '';
  bool isUpdateAvailable = false;
  String downloadUrl = 'https://example.com/download';

  Future<void> checkVersion() async {
    await _remoteConfigService.initialize();
    latestVersion = _remoteConfigService.getLatestVersion();
    textoRandom = _remoteConfigService.getTextoRandom();

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    versionMiMovil = packageInfo.version;

    // Compara la versión actual con la versión más reciente
    if (_compareVersion(versionMiMovil, latestVersion) < 0) {
      isUpdateAvailable = true;
    }
  }

  int _compareVersion(String currentVersion, String latestVersion) {
    int currentVersionInt = _versionToInt(currentVersion);
    int latestVersionInt = _versionToInt(latestVersion);

    debugPrint('::: currentVersion  $currentVersion');
    debugPrint('::: latestVersion  $latestVersion');
    debugPrint('::: currentVersionInt  $currentVersionInt');
    debugPrint('::: latestVersionInt  $latestVersionInt');

    if (latestVersionInt > currentVersionInt) {
      return -1; // Hay una actualización disponible
    } else if (latestVersionInt < currentVersionInt) {
      return 1; // La versión actual es más reciente
    }
    return 0; // Las versiones son iguales
  }

  int _versionToInt(String version) {
    // Remover puntos y convertir a entero
    return int.tryParse(version.replaceAll('.', '')) ?? 0;
  }

  void redirectToDownload() async {
    Uri url = Uri.parse(downloadUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $downloadUrl';
    }
  }
}
