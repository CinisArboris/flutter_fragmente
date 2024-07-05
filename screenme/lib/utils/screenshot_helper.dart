import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:gallery_saver_plus/gallery_saver.dart';

import 'package:screenme/utils/email_sender.dart';

class ScreenshotHelper {
  static Future<void> captureAndSave(
    BuildContext context,
    GlobalKey repaintBoundaryKey,
    TextEditingController messageController,
  ) async {
    try {
      RenderRepaintBoundary boundary = repaintBoundaryKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final directory = (await getExternalStorageDirectory())!.path;
      final path =
          '$directory/screenshot_${DateTime.now().millisecondsSinceEpoch}.png';
      File imgFile = File(path);
      await imgFile.writeAsBytes(pngBytes);

      await GallerySaver.saveImage(imgFile.path, albumName: 'ScreenMe');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Captura guardada en la galería')),
      );
      debugPrint('Captura guardada en la galería: $path');

      // Enviar la captura de pantalla por correo
      final emailSender = EmailSender();
      await emailSender.sendEmail(path, messageController.text);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Captura enviada por correo')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al capturar la pantalla: $e')),
      );
      debugPrint('Error al capturar la pantalla: $e');
    }
  }
}
