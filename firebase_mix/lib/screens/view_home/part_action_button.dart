import 'package:flutter/material.dart';
import 'package:firebase_mix/screens/view_default_test.dart';
import 'package:firebase_mix/services/handler_view.dart';
import 'package:firebase_mix/widgets/main_apk_dialog_update/w_apk_update_dialog.dart';

class ActionButtonSection extends StatelessWidget {
  final HandlerView updateHandler;
  final VoidCallback onUpdate;
  final VoidCallback onCancel;

  const ActionButtonSection({
    super.key,
    required this.updateHandler,
    required this.onUpdate,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
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
      onPressed: () => showDialog(
        context: context,
        builder: (context) => WApkUpdateAlertDialog(
          onUpdate: onUpdate,
          onCancel: onCancel,
          versionDetail: updateHandler.remoteDetail,
          mobileVersion: updateHandler.remoteVersion,
          apkUrl: updateHandler.remoteApkUrl,
        ),
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
