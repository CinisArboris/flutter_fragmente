import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import '../utils/screenshot_helper.dart';

class CaptureButton extends StatelessWidget {
  final ScreenshotController screenshotController;

  const CaptureButton({
    super.key,
    required this.screenshotController,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.camera_alt),
      onPressed: () =>
          ScreenshotHelper.captureAndSave(context, screenshotController),
    );
  }
}
