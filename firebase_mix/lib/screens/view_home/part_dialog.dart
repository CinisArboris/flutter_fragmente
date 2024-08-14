import 'package:flutter/material.dart';
import 'package:firebase_mix/widgets/apk_update/w_apk_update_alert_dialog.dart';
import 'package:firebase_mix/services/handler_view.dart';

class UpdateDialogHandler {
  void handleUpdateDialog({
    required BuildContext context,
    required HandlerView updateHandler,
    required VoidCallback onUpdate,
    required VoidCallback onCancel,
  }) async {
    if (await updateHandler.isUpdateDownloaded()) {
      await updateHandler.installUpdate();
    } else {
      if (context.mounted) {
        showUpdateDialog(
          context: context,
          updateHandler: updateHandler,
          onUpdate: onUpdate,
          onCancel: onCancel,
        );
      }
    }
  }

  void showUpdateDialog({
    required BuildContext context,
    required HandlerView updateHandler,
    required VoidCallback onUpdate,
    required VoidCallback onCancel,
  }) {
    showDialog(
      context: context,
      builder: (context) => WApkUpdateAlertDialog(
        onUpdate: onUpdate,
        onCancel: onCancel,
        versionDetail: updateHandler.remoteDetail,
        mobileVersion: updateHandler.remoteVersion,
        apkUrl: updateHandler.remoteApkUrl,
      ),
    );
  }
}
