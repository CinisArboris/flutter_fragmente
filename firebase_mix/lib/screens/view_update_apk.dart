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
  ServicioGestorDeActualizacion? installer;
  final GlobalKey<DioDownloadingWidgetState> _downloadingWidgetKey =
      GlobalKey<DioDownloadingWidgetState>();

  String? errorMessage;
  bool isInstalling = false;

  @override
  void initState() {
    super.initState();
    installer = ServicioGestorDeActualizacion(widget.apkUrl);

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
      onProgress: (progress) {
        // Aquí podrías actualizar la UI con el progreso si es necesario
      },
      onBytesDownloaded: (mbDownloaded) {
        _downloadingWidgetKey.currentState?.updateBytesDownloaded(mbDownloaded);
      },
    ).then((_) {
      setState(() {
        isInstalling = true;
      });
    }).catchError((error) async {
      setState(() {
        errorMessage =
            'Error durante la descarga o instalación de la APK: $error';
      });
      // Limpiar datos en caso de error
      await installer?.limpiarDatosDeInstalacion();
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
    if (isInstalling) {
      return _buildSuccessWidget();
    } else if (errorMessage != null) {
      return _buildErrorWidget();
    } else {
      return _buildDownloadingWidget();
    }
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
      padding: const EdgeInsets.all(16),
      child: _buildFutureBuilder(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: _buildContainer(),
        ),
      ),
    );
  }
}
