import 'package:flutter/material.dart';
import 'package:screenme/widgets/capture_button.dart';
import 'package:screenme/widgets/widget_form.dart';

class HomeScreen extends StatelessWidget {
  final GlobalKey _repaintBoundaryKey = GlobalKey();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ScreenMe"),
        actions: [
          CaptureButton(repaintBoundaryKey: _repaintBoundaryKey),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: RepaintBoundary(
            key: _repaintBoundaryKey,
            child: WidgetForms(),
          ),
        ),
      ),
    );
  }
}
