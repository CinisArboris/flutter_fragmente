import 'dart:ui' as ui show Image;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:screen_recorder/screen_recorder.dart';

class ScreenRecorderController {
  ScreenRecorderController({
    Exporter? exporter,
    this.pixelRatio = 0.5,
    this.skipFramesBetweenCaptures = 2,
    SchedulerBinding? binding,
  })  : _containerKey = GlobalKey(),
        _binding = binding ?? SchedulerBinding.instance,
        _exporter = exporter ?? Exporter();

  final GlobalKey _containerKey;
  final SchedulerBinding _binding;
  final Exporter _exporter;

  Exporter get exporter => _exporter;

  final double pixelRatio;
  final int skipFramesBetweenCaptures;

  int skipped = 0;
  bool _record = false;

  void start() {
    if (_record == true) {
      return;
    }
    _record = true;
    _binding.addPostFrameCallback(postFrameCallback);
  }

  void stop() {
    _record = false;
  }

  void postFrameCallback(Duration timestamp) async {
    if (_record == false) {
      return;
    }
    if (skipped > 0) {
      skipped = skipped - 1;
      _binding.addPostFrameCallback(postFrameCallback);
      return;
    }
    if (skipped == 0) {
      skipped = skipped + skipFramesBetweenCaptures;
    }
    try {
      final image = capture();
      if (image == null) {
        print('capture returned null');
        return;
      }
      _exporter.onNewFrame(Frame(timestamp, image));
    } catch (e) {
      print(e.toString());
    }
    _binding.addPostFrameCallback(postFrameCallback);
  }

  ui.Image? capture() {
    final renderObject = _containerKey.currentContext!.findRenderObject()
        as RenderRepaintBoundary;
    return renderObject.toImageSync(pixelRatio: pixelRatio);
  }
}

class ScreenRecorder extends StatelessWidget {
  ScreenRecorder({
    Key? key,
    required this.child,
    required this.controller,
    required this.width,
    required this.height,
    this.background = Colors.white,
  })  : assert(background.alpha == 255,
            'background color is not allowed to be transparent'),
        super(key: key);

  final Widget child;
  final ScreenRecorderController controller;
  final double width;
  final double height;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: controller._containerKey,
      child: Container(
        width: width,
        height: height,
        color: background,
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}
