import 'package:flutter/material.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:screen_recorder/screen_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class CaptureButton extends StatefulWidget {
  const CaptureButton({super.key});

  @override
  CaptureButtonState createState() => CaptureButtonState();
}

class CaptureButtonState extends State<CaptureButton> {
  bool isRecording = false;
  int _remainingTime = 5;
  final ScreenRecorderController _controller = ScreenRecorderController();

  Future<void> startRecording() async {
    final directory = (await getApplicationDocumentsDirectory()).path;
    final path = '$directory/screen_recording.mp4';
    _controller.start();
    debugPrint('Recording started. Saving to: $path');
    setState(() {
      isRecording = true;
      _remainingTime = 5;
    });
    _startTimer(path);
  }

  Future<void> stopRecording(String path) async {
    _controller.stop();
    await Future.delayed(const Duration(seconds: 1));
    final file = File(path);
    if (await file.exists()) {
      await GallerySaver.saveVideo(file.path, albumName: 'ScreenMe');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Recording saved to gallery')),
      );
      debugPrint('Recording saved to gallery: $path');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Recording failed to save')),
      );
      debugPrint('Recording failed to save: $path');
    }
    setState(() {
      isRecording = false;
    });
  }

  void _startTimer(String path) {
    Future.delayed(const Duration(seconds: 1), () {
      if (isRecording && _remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
        _startTimer(path);
      } else if (_remainingTime == 0) {
        stopRecording(path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(isRecording ? Icons.stop : Icons.fiber_manual_record),
          onPressed: () async {
            if (isRecording) {
              final directory = (await getApplicationDocumentsDirectory()).path;
              final path = '$directory/screen_recording.mp4';
              await stopRecording(path);
            } else {
              await startRecording();
            }
          },
        ),
        if (isRecording)
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              '$_remainingTime',
              style: const TextStyle(fontSize: 20, color: Colors.red),
            ),
          ),
      ],
    );
  }
}
