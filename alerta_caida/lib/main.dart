import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart'; // Importa para MethodChannel

void main() {
  runApp(const MyApp());
}

// Asumiendo que la clase PlatformAudio ya está definida en otro lugar de tu proyecto
class PlatformAudio {
  static const platform = MethodChannel('com.cinisarboris.example/audio');

  static Future<void> setVolumeToMax() async {
    try {
      await platform.invokeMethod('setVolumeToMax');
    } on PlatformException catch (e) {
      print("Failed to set volume: '${e.message}'.");
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo de Alerta',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Demo de Alerta de Caída'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final player = AudioPlayer();

  Future<void> playSound() async {
    // Establecer el volumen al máximo
    await PlatformAudio.setVolumeToMax();
    // Reproducir el sonido
    await player.play(AssetSource('audio/AC_CD_highway_to_hell.mp3'));
  }

  Future<void> stopSound() async {
    // Detener la reproducción del sonido
    await player.stop();
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
            const SizedBox(height: 20), // Espacio entre los botones
            ElevatedButton(
              onPressed: stopSound,
              child: const Text('Detener Sonido'),
              style: ElevatedButton.styleFrom(
                primary: Colors.red, // Color del botón
              ),
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
