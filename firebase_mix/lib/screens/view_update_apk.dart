import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:firebase_mix/services/servicio_gestor_de_actualizacion.dart';
import 'package:firebase_mix/utils_services/transformaciones_apk.dart';
import 'package:firebase_mix/widgets/w_apk_dio_download.dart';
import 'package:firebase_mix/widgets/w_apk_dio_error.dart';
import 'package:firebase_mix/widgets/w_apk_dio_success.dart';

class ViewUpdateApk extends StatefulWidget {
  final String apkUrl;

  const ViewUpdateApk({
    super.key,
    required this.apkUrl,
  });

  @override
  ViewUpdateApkState createState() => ViewUpdateApkState();
}

class ViewUpdateApkState extends State<ViewUpdateApk> {
  ServicioGestorDeActualizacion? installer;
  final GlobalKey<DioDownloadingWidgetState> _downloadingWidgetKey =
      GlobalKey<DioDownloadingWidgetState>();

  String? errorMessage;
  bool isDownloading = false;
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

  void _startDownload() async {
    // Verificar si el archivo APK ya existe
    final fileExists = await TransformacionesAPK.checkIfApkExists();

    if (fileExists) {
      // Si el archivo ya existe, proceder directamente a la instalación
      setState(() {
        isDownloading = false;
        isInstalling = true;
      });

      // Iniciar el proceso de instalación directamente
      final savePath = await TransformacionesAPK.getApkSavePath();
      await installer?.installDownloadedUpdate(savePath);
    } else {
      // Si el archivo no existe, proceder con la descarga
      setState(() {
        isDownloading = true;
        errorMessage = null;
      });

      try {
        // Iniciar el proceso de descarga e instalación
        await installer?.descargarEInstalarActualizacion(
          onProgress: (progress) {
            // Actualizar la UI con el progreso de la descarga si es necesario
          },
          onBytesDownloaded: (mbDownloaded) {
            _downloadingWidgetKey.currentState
                ?.updateBytesDownloaded(mbDownloaded);
          },
        );

        // Verificar si el archivo realmente existe después de la descarga
        final fileExistsAfterDownload =
            await TransformacionesAPK.checkIfApkExists();

        if (fileExistsAfterDownload) {
          setState(() {
            isDownloading = false;
            isInstalling = true;
          });

          // Iniciar el proceso de instalación directamente
          final savePath = await TransformacionesAPK.getApkSavePath();
          await installer?.installDownloadedUpdate(savePath);
        } else {
          // Si el archivo no se encuentra después de la descarga, mostramos un error
          setState(() {
            isDownloading = false;
            errorMessage =
                'El archivo APK no se encontró después de la descarga.';
          });
        }
      } catch (error) {
        // Capturamos cualquier error durante la descarga e instalación
        if (error is DioException) {
          // Especificar el tipo de error y el código de estado
          setState(() {
            isDownloading = false;
            String errorType = error.type.toString();
            String? statusCode = error.response?.statusCode?.toString();
            errorMessage =
                'Dio Error: $errorType, Código de estado: $statusCode';
          });
        } else {
          setState(() {
            isDownloading = false;
            errorMessage =
                'Error desconocido durante la descarga/instalación: $error';
          });
        }
      }
    }
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

  Widget _buildContent() {
    if (isDownloading) {
      return _buildDownloadingWidget();
    } else if (isInstalling) {
      return _buildSuccessWidget();
    } else if (errorMessage != null) {
      return _buildErrorWidget();
    } else {
      // Estado por defecto para mostrar el widget de descarga
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
      child: _buildContent(),
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
