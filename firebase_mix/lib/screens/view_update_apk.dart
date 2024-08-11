import 'package:flutter/material.dart';
import 'package:firebase_mix/services/servicio_gestor_de_actualizacion.dart';
import 'package:firebase_mix/widgets/w_apk_dio_download.dart';
import 'package:firebase_mix/widgets/w_apk_dio_error.dart';
import 'package:firebase_mix/widgets/w_apk_dio_success.dart';

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

  String? errorMessage;

  @override
  void initState() {
    super.initState();
    installer = GestorDeActualizaciones(widget.apkUrl);

    if (widget.apkUrl.isEmpty) {
      // Si la URL es vacía, mostrar un mensaje de error
      setState(() {
        errorMessage =
            'Error conectando a Firebase. Favor de actualizar las URLs o contactar con soporte.';
      });
    } else {
      installer?.descargarEInstalarActualizacion(
        onBytesDownloaded: (mbDownloaded) {
          _downloadingWidgetKey.currentState
              ?.updateBytesDownloaded(mbDownloaded);
        },
      ).catchError((error) {
        // Manejar el error y mostrar un mensaje al usuario
        setState(() {
          errorMessage =
              'Error durante la descarga o instalación de la APK: $error';
        });
      });
    }
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
          child: errorMessage != null
              ? DioErrorWidget(error: errorMessage)
              : FutureBuilder(
                  future: installer?.descargarEInstalarActualizacion(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return DioDownloadingWidget(
                        key: _downloadingWidgetKey,
                      );
                    } else if (snapshot.hasError) {
                      return DioErrorWidget(error: snapshot.error.toString());
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
