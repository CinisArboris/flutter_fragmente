import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import '../utils/screenshot_helper.dart';

class CaptureButton extends StatelessWidget {
  final ScreenshotController screenshotController;

  CaptureButton({required this.screenshotController});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.camera_alt),
      onPressed: () =>
          ScreenshotHelper.captureAndSave(context, screenshotController),
    );
  }
}
