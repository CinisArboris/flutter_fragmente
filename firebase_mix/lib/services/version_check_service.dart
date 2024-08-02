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
    versionMiMovil = _remoteConfigService.getVersionMiMovil();
    textoRandom = _remoteConfigService.getTextoRandom();

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String currentVersion = packageInfo.version;

    if (currentVersion != latestVersion) {
      isUpdateAvailable = true;
    }
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
