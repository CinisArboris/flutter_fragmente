import 'package:flutter/material.dart';

class DioDownloadingWidget extends StatefulWidget {
  const DioDownloadingWidget({super.key});

  @override
  DioDownloadingWidgetState createState() => DioDownloadingWidgetState();
}

class DioDownloadingWidgetState extends State<DioDownloadingWidget> {
  double _mbDownloaded = 0.0;

  void updateBytesDownloaded(double mbDownloaded) {
    setState(() {
      _mbDownloaded = mbDownloaded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 20),
                Text(
                  'Descargando... ${_mbDownloaded.toStringAsFixed(2)} MB',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Por favor, espere mientras se descarga e instala la nueva versión de la aplicación.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
