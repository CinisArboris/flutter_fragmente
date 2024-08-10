import 'package:flutter/material.dart';
import 'package:firebase_mix/services/servicio_gestor_de_actualizacion.dart';
import 'package:firebase_mix/widgets/dio_download.dart';
import 'package:firebase_mix/widgets/dio_error.dart';
import 'package:firebase_mix/widgets/dio_success.dart';

class ViewUpdateApk extends StatefulWidget {
  final String apkUrl;

  const ViewUpdateApk({super.key, required this.apkUrl});

  @override
  ViewUpdateApkState createState() => ViewUpdateApkState();
}

class ViewUpdateApkState extends State<ViewUpdateApk> {
  GestorDeActualizaciones? installer;
  final GlobalKey<DioDownloadingWidgetState> _downloadingWidgetKey =
      GlobalKey<DioDownloadingWidgetState>();

  @override
  void initState() {
    super.initState();
    installer = GestorDeActualizaciones(widget.apkUrl);

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
