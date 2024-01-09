import 'package:flutter/material.dart';
import 'alert_manager.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final AlertManager alertManager = AlertManager();

  @override
  void initState() {
    super.initState();
    alertManager.startAlertTimer();
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
            const Text('Presiona el botón para probar la alerta.'),
            ElevatedButton(
              onPressed:
                  alertManager.playAlert, // Iniciar alerta (sonido y vibración)
              child: const Text('Probar Alerta'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed:
                  alertManager.stopAlert, // Detener alerta (sonido y vibración)
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Detener Alerta'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
            alertManager.playAlert, // Iniciar alerta (sonido y vibración)
        tooltip: 'Probar Alerta',
        child: const Icon(Icons.notification_important),
      ),
    );
  }

  @override
  void dispose() {
    alertManager.dispose();
    super.dispose();
  }
}
