import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:screenshot/screenshot.dart';

class ScreenshotHelper {
  static Future<void> captureAndSave(
    BuildContext context,
    ScreenshotController screenshotController,
  ) async {
    try {
      // Esperar un poco más para asegurarse de que todo esté renderizado
      await Future.delayed(const Duration(milliseconds: 500));

      final Uint8List? image = await screenshotController.capture(
        delay: const Duration(milliseconds: 200),
      );

      if (image != null) {
        await ImageGallerySaver.saveImage(image,
            quality: 100,
            name: 'screenshot_${DateTime.now().millisecondsSinceEpoch}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Screenshot saved to gallery')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error capturing screenshot: $error')),
      );
    }
  }
}
