import 'dart:async';

import 'package:alerta_caida/plartorm_audio.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final player = AudioPlayer();
  Timer? alertTimer;
  Timer? vibrationTimer;

  @override
  void initState() {
    super.initState();
    alertTimer =
        Timer.periodic(const Duration(minutes: 2), (Timer t) => playAlert());
  }

  // Iniciar la reproducción de sonido y la vibración
  Future<void> playAlert() async {
    await playSound();
    startVibration();
  }

  Future<void> playSound() async {
    await PlatformAudio.setVolumeToMax();
    await player.play(AssetSource('audio/AC_CD_highway_to_hell.mp3'));
  }

  // Iniciar la vibración periódica
  void startVibration() {
    vibrationTimer?.cancel(); // Cancelar cualquier vibración anterior
    vibrationTimer = Timer.periodic(
        const Duration(seconds: 1), (Timer t) async => await vibratePhone());
  }

  Future<void> vibratePhone() async {
    try {
      await PlatformAudio.vibratePhone();
    } on PlatformException catch (e) {
      print("Failed to vibrate: '${e.message}'.");
    }
  }

  // Detener la reproducción de sonido y la vibración
  Future<void> stopAlert() async {
    await player.stop();
    vibrationTimer?.cancel();
  }

  @override
  void dispose() {
    alertTimer?.cancel();
    vibrationTimer?.cancel();
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Presiona el botón para probar la alerta de sonido.'),
            ElevatedButton(
              onPressed: playSound,
              child: const Text('Probar Sonido'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: stopAlert,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Detener Sonido y Vibración'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: playSound,
        tooltip: 'Probar Sonido',
        child: const Icon(Icons.notification_important),
      ),
    );
  }
}
