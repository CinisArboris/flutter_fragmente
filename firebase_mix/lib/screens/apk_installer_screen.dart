import 'package:flutter/material.dart';
import 'package:firebase_mix/services/servicio_gestor_de_actualizacion.dart';
import 'package:firebase_mix/widgets/dio_download.dart';
import 'package:firebase_mix/widgets/dio_error.dart';
import 'package:firebase_mix/widgets/dio_success.dart';

/// Esta pantalla gestiona la actualización de la aplicación mediante la descarga e instalación de un nuevo APK.
class ApkInstallScreen extends StatefulWidget {
  final String apkUrl;

  const ApkInstallScreen({super.key, required this.apkUrl});

  @override
  ApkInstallScreenState createState() => ApkInstallScreenState();
}

class ApkInstallScreenState extends State<ApkInstallScreen> {
  GestorDeActualizaciones? installer;
  final GlobalKey<DioDownloadingWidgetState> _downloadingWidgetKey =
      GlobalKey<DioDownloadingWidgetState>();

  @override
  void initState() {
    super.initState();
    installer = GestorDeActualizaciones(widget.apkUrl);

    /// **⚠️ Observación Importante:**
    /// Este flujo está diseñado para actualizar el APK de la aplicación.
    /// Se asegura de que la última versión del APK se descargue e instale en el dispositivo.
    installer?.descargarEInstalarActualizacion(
      onBytesDownloaded: (mbDownloaded) {
        _downloadingWidgetKey.currentState?.updateBytesDownloaded(mbDownloaded);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Actualización de la Aplicación'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: FutureBuilder(
            future: installer?.descargarEInstalarActualizacion(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return DioDownloadingWidget(
                  key: _downloadingWidgetKey,
                );
              } else if (snapshot.hasError) {
                return DioErrorWidget(error: snapshot.error);
              } else {
                return const DioSuccessWidget();
              }
            },
          ),
        ),
      ),
    );
  }
}
