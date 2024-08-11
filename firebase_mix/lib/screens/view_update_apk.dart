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
      setState(() {
        errorMessage =
            'Error conectando a Firebase. Favor de actualizar las URLs o contactar con soporte.';
      });
    } else {
      _startDownload();
    }
  }

  void _startDownload() {
    installer?.descargarEInstalarActualizacion(
      onBytesDownloaded: (mbDownloaded) {
        _downloadingWidgetKey.currentState?.updateBytesDownloaded(mbDownloaded);
      },
    ).catchError((error) {
      setState(() {
        errorMessage =
            'Error durante la descarga o instalación de la APK: $error';
      });
    });
  }

  Widget _buildErrorWidget() {
    return DioErrorWidget(error: errorMessage);
  }

  Widget _buildDownloadingWidget() {
    return DioDownloadingWidget(
      key: _downloadingWidgetKey,
    );
  }

  Widget _buildSuccessWidget() {
    return const DioSuccessWidget();
  }

  Widget _buildFutureBuilder() {
    return FutureBuilder(
      future: installer?.descargarEInstalarActualizacion(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildDownloadingWidget();
        } else if (snapshot.hasError) {
          return DioErrorWidget(error: snapshot.error.toString());
        } else {
          return _buildSuccessWidget();
        }
      },
    );
  }

  Widget _buildContainer() {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 300,
        maxHeight: 400,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey.shade400,
          width: 2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16), // Reducir el padding interno
      child: errorMessage != null ? _buildErrorWidget() : _buildFutureBuilder(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // Fondo gris claro
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: _buildContainer(),
        ),
      ),
    );
  }
}
