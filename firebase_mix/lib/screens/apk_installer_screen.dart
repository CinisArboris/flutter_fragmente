import 'package:firebase_mix/services/servicio_apk_installer.dart';
import 'package:firebase_mix/widgets/dio_download.dart';
import 'package:firebase_mix/widgets/dio_error.dart';
import 'package:firebase_mix/widgets/dio_success.dart';
import 'package:flutter/material.dart';

class ApkInstallScreen extends StatefulWidget {
  final String apkUrl;

  const ApkInstallScreen({super.key, required this.apkUrl});

  @override
  ApkInstallScreenState createState() => ApkInstallScreenState();
}

class ApkInstallScreenState extends State<ApkInstallScreen> {
  ApkInstaller? installer;
  final GlobalKey<DioDownloadingWidgetState> _downloadingWidgetKey =
      GlobalKey<DioDownloadingWidgetState>();

  @override
  void initState() {
    super.initState();
    installer = ApkInstaller(widget.apkUrl);

    // Empezar la descarga e instalar el APK con el callback onProgress
    installer?.downloadAndInstallApk(onProgress: (progress) {
      _downloadingWidgetKey.currentState
          ?.updateProgress(progress.toStringAsFixed(2));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instalación de APK'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: FutureBuilder(
            future: installer?.downloadAndInstallApk(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return DioDownloadingWidget(
                  key: _downloadingWidgetKey,
                  initialProgress: '0.00',
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
