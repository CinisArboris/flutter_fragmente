import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:ui' as ui;

class CaptureButton extends StatefulWidget {
  final GlobalKey repaintBoundaryKey;

  const CaptureButton({
    super.key,
    required this.repaintBoundaryKey,
  });

  @override
  CaptureButtonState createState() => CaptureButtonState();
}

class CaptureButtonState extends State<CaptureButton> {
  Future<void> _captureAndSaveScreenshot() async {
    try {
      RenderRepaintBoundary boundary = widget.repaintBoundaryKey.currentContext!
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
        SnackBar(content: Text('Screenshot saved to gallery')),
      );
      debugPrint('Screenshot saved to gallery: $path');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to capture screenshot: $e')),
      );
      debugPrint('Failed to capture screenshot: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.camera),
      onPressed: _captureAndSaveScreenshot,
    );
  }
}
