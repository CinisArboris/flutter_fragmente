import 'package:firebase_mix/services_firebase_update/service_check_version.dart';

class HandlerView {
  final ServiceCheckVersion _versionCheckService = ServiceCheckVersion();

  String get localVersion => _versionCheckService.localVersion;
  String get remoteDetail => _versionCheckService.remoteDetail;
  String get remoteVersion => _versionCheckService.remoteVersion;
  String get remoteApkUrl => _versionCheckService.remoteApkUrl;
  bool get isUpdateAvailable => _versionCheckService.isUpdateAvailable;

  Future<void> checkForUpdates() async {
    await _versionCheckService.checkVersion();
  }

  Future<void> cleanUp() async {
    await _versionCheckService.limpiarDatosDeInstalacion();
  }

  Future<bool> isUpdateDownloaded() async {
    return await _versionCheckService.isUpdateDownloaded();
  }

  Future<void> installUpdate() async {
    await _versionCheckService
        .installDownloadedUpdate(_versionCheckService.remoteApkUrl);
  }
}
