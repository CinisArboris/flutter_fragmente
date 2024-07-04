import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:screenshot/screenshot.dart';
import '../widgets/form_simple.dart';

class ScreenshotHelper {
  static Future<void> captureAndSave(
      BuildContext context, ScreenshotController screenshotController) async {
    try {
      final Uint8List? image = await screenshotController.captureFromWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Builder(builder: (context) => FormWidget()),
            ),
          ),
        ),
        delay: const Duration(milliseconds: 200),
        pixelRatio: MediaQuery.of(context).devicePixelRatio,
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
