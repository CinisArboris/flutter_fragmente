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
    debugPrint(
        ':::: DioDownload - Bytes descargados actualizados: ${_mbDownloaded.toStringAsFixed(2)} MB');
  }

  @override
  void initState() {
    super.initState();
    debugPrint(':::: DioDownload - Widget DioDownloadingWidget inicializado');
  }

  @override
  void dispose() {
    debugPrint(':::: DioDownload - Widget DioDownloadingWidget destruido');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(
        ':::: DioDownload - Renderizando widget con $_mbDownloaded MB descargados');
    return Center(
      child: _buildDownloadCard(),
    );
  }

  Widget _buildDownloadCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildProgressIndicator(),
            const SizedBox(height: 20),
            _buildDownloadedText(),
            const SizedBox(height: 20),
            _buildInstructionText(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return const CircularProgressIndicator();
  }

  Widget _buildDownloadedText() {
    return Text(
      'Descargando... ${_mbDownloaded.toStringAsFixed(2)} MB',
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 16),
    );
  }

  Widget _buildInstructionText() {
    return const Text(
      'Por favor, espere mientras se descarga e instala la nueva versión de la aplicación.',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 16),
    );
  }
}
