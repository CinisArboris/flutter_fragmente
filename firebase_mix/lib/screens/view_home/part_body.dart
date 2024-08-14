import 'package:firebase_mix/screens/view_default_test.dart';
import 'package:firebase_mix/widgets/w_info_card.dart';
import 'package:flutter/material.dart';
import 'package:firebase_mix/services/handler_view.dart';
import 'package:firebase_mix/widgets/apk_update/w_apk_update_alert_dialog.dart';
import 'part_dialog.dart';

class UpdateBody extends StatelessWidget {
  final HandlerView updateHandler;
  final UpdateDialogHandler dialogHandler;

  const UpdateBody({
    super.key,
    required this.updateHandler,
    required this.dialogHandler,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const InfoCard(
            title: 'Detalle',
            subtitle: 'Modulos disponibles : 15',
          ),
          const SizedBox(height: 20),
          InfoCard(
            title: 'Versión instalada en el dispositivo',
            subtitle: updateHandler.localVersion,
          ),
          const SizedBox(height: 20),
          InfoCard(
            title: 'Descripción de la APK',
            subtitle: updateHandler.remoteDetail,
          ),
          const SizedBox(height: 20),
          InfoCard(
            title: 'Versión disponible en el servidor',
            subtitle: updateHandler.remoteVersion,
          ),
          const SizedBox(height: 20),
          _buildActionButton(context),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return Column(
      children: [
        if (updateHandler.isUpdateAvailable) ...[
          _buildUpdateButton(context),
          const SizedBox(height: 10),
        ] else ...[
          _buildNavigateButton(context),
          const SizedBox(height: 10),
        ],
      ],
    );
  }

  Widget _buildUpdateButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => dialogHandler.showUpdateDialog(
        context: context,
        updateHandler: updateHandler,
        onUpdate: () {
          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WApkUpdateAlertDialog(
                onUpdate: () {},
                onCancel: () {
                  Navigator.of(context).pop();
                },
                versionDetail: updateHandler.remoteDetail,
                mobileVersion: updateHandler.remoteVersion,
                apkUrl: updateHandler.remoteApkUrl,
              ),
            ),
          );
        },
        onCancel: () {
          Navigator.of(context).pop();
        },
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange,
      ),
      child: const Text(
        'Actualizar',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildNavigateButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ViewDefaultTest()),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
      ),
      child: const Text(
        'Ir a nueva ruta',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
