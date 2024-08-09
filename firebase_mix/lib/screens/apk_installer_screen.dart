import 'package:firebase_mix/services/servicio_apk_installer.dart';
import 'package:firebase_mix/widgets/dio_download.dart';
import 'package:firebase_mix/widgets/dio_error.dart';
import 'package:firebase_mix/widgets/dio_success.dart';
import 'package:flutter/material.dart';

class ApkInstallScreen extends StatefulWidget {
  final String apkUrl;

  const ApkInstallScreen({super.key, required this.apkUrl});

  @override
  _ApkInstallScreenState createState() => _ApkInstallScreenState();
}

class _ApkInstallScreenState extends State<ApkInstallScreen> {
  ApkInstaller? installer;

  @override
  void initState() {
    super.initState();
    installer = ApkInstaller(widget.apkUrl);
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
                return StreamBuilder<double>(
                  stream: Stream.periodic(const Duration(milliseconds: 500),
                      (count) {
                    return double.tryParse(installer?.progressValue ?? '0.0') ??
                        0.0;
                  }),
                  builder: (context, snapshot) {
                    return DioDownloadingWidget(
                      progress: snapshot.data?.toStringAsFixed(2) ?? '0.00',
                    );
                  },
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
