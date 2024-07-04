import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

class ScreenshotHelper {
  static Future<void> captureAndSave(
      BuildContext context, ScreenshotController screenshotController) async {
    try {
      final directory = (await getApplicationDocumentsDirectory()).path;
      final String timestamp =
          DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final fileName = 'screenshot_$timestamp.png';
      final path = '$directory/$fileName';

      final Uint8List? image = await screenshotController.capture(
        delay: const Duration(milliseconds: 200),
      );

      if (image != null) {
        final File imageFile = File(path);
        imageFile.writeAsBytesSync(image);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Screenshot saved: $path')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error capturing screenshot: $error')),
      );
    }
  }
}
