import 'package:flutter/material.dart';
import 'package:screenme/widgets/capture_button.dart';
import 'package:screenme/widgets/widget_form.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ScreenMe"),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: CaptureButton(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: WidgetForms(),
        ),
      ),
    );
  }
}
