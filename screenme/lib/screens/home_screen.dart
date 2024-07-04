import 'package:flutter/material.dart';
import 'package:screenme/widgets/button_capture.dart';
import 'package:screenme/widgets/form_simple.dart';
import 'package:screenshot/screenshot.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final ScreenshotController _screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ScreenMe"),
        actions: [
          CaptureButton(
            screenshotController: _screenshotController,
          ),
        ],
      ),
      body: Screenshot(
        controller: _screenshotController,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: FormWidget(),
          ),
        ),
      ),
    );
  }
}
