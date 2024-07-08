import 'package:flutter/material.dart';
import 'package:screenme/utils/screenshot_helper.dart';

class CaptureButton extends StatefulWidget {
  const CaptureButton({super.key, required this.repaintBoundaryKey});

  final GlobalKey repaintBoundaryKey;

  @override
  CaptureButtonState createState() => CaptureButtonState();
}

class CaptureButtonState extends State<CaptureButton> {
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.camera),
      onPressed: () async {
        await ScreenshotHelper.captureAndSave(
          context,
          widget.repaintBoundaryKey,
          _messageController,
        );
      },
    );
  }
}
