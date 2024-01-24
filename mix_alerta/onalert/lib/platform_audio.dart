import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class PlatformAudio {
  static const platform = MethodChannel('com.cinisarboris.example/audio');

  static Future<void> setVolumeToMax() async {
    try {
      await platform.invokeMethod('setVolumeToMax');
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print("Failed to set volume: '${e.message}'.");
      }
    }
  }

  static Future<void> vibratePhone() async {
    try {
      await platform.invokeMethod('vibratePhone');
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print("Failed to vibrate: '${e.message}'.");
      }
    }
  }
}
