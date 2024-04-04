import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:onalert/onAlert/platform_audio.dart';

class AlertManager {
  final AudioPlayer player = AudioPlayer();
  Timer? alertTimer;
  Timer? vibrationTimer;

  void startAlertTimer() {
    alertTimer = Timer.periodic(
      const Duration(minutes: 1),
      (Timer t) => playAlert(),
    );
  }

  Future<void> playAlert() async {
    await setVolumeToMax();
    await playSound();
    startVibration();
  }

  Future<void> setVolumeToMax() async {
    try {
      await PlatformAudio.setVolumeToMax();
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print("Failed to set volume: '${e.message}'.");
      }
    }
  }

  Future<void> playSound() async {
    await player.play(AssetSource('audio/AC_CD_highway_to_hell.mp3'));
  }

  void startVibration() {
    vibrationTimer?.cancel();
    vibrationTimer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer t) async => await vibratePhone(),
    );
  }

  Future<void> vibratePhone() async {
    try {
      await PlatformAudio.vibratePhone();
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print("Failed to vibrate: '${e.message}'.");
      }
    }
  }

  void stopAlert() {
    player.stop();
    vibrationTimer?.cancel();
  }

  void dispose() {
    alertTimer?.cancel();
    vibrationTimer?.cancel();
    player.dispose();
  }
}
