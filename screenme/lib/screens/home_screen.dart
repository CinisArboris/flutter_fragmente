import 'package:flutter/material.dart';
import 'package:screenme/widgets/capture_button.dart';
import 'package:screenme/widgets/widget_form.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey repaintBoundaryKey = GlobalKey();

    return Scaffold(
      appBar: AppBar(
        title: const Text("ScreenMe"),
        actions: [
          CaptureButton(repaintBoundaryKey: repaintBoundaryKey),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: RepaintBoundary(
            key: repaintBoundaryKey,
            child: Container(
              color: Colors.white,
              child: WidgetForms(),
            ),
          ),
        ),
      ),
    );
  }
}
