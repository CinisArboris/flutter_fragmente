import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  Future<void> initialize() async {
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: const Duration(seconds: 30),
    ));
    await _remoteConfig.fetchAndActivate();
  }

  String getLatestVersion() {
    return _remoteConfig.getString('version_mi_movil');
  }

  String getTextoRandom() {
    return _remoteConfig.getString('texto_random');
  }
}
