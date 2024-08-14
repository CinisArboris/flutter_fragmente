import 'package:firebase_mix/screens/view_default_test.dart';
import 'package:firebase_mix/screens/view_home/part_body.dart';
import 'package:firebase_mix/screens/view_update_apk.dart';
import 'package:firebase_mix/services/handler_view.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'part_dialog.dart';

class MyHomePage extends StatefulWidget {
  final FirebaseAnalytics analytics;

  const MyHomePage({
    super.key,
    required this.analytics,
  });

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  final HandlerView _updateHandler = HandlerView();
  final UpdateDialogHandler _dialogHandler = UpdateDialogHandler();
  bool _isDialogShown = false;

  @override
  void initState() {
    super.initState();
    _isDialogShown = false;
    _checkForUpdates();
  }

  Future<void> _checkForUpdates() async {
    await _updateHandler.checkForUpdates();

    if (!mounted)
      return; // Verifica si el widget sigue montado antes de usar el context
    setState(() {});

    if (!_updateHandler.isUpdateAvailable) {
      await _updateHandler.cleanUp();
    } else if (_updateHandler.isUpdateAvailable && !_isDialogShown) {
      if (!mounted) return; // Verifica nuevamente antes de mostrar el diálogo
      _dialogHandler.handleUpdateDialog(
        context: context,
        updateHandler: _updateHandler,
        onUpdate: _onUpdate,
        onCancel: _onCancel,
      );
      _isDialogShown = true;
    }
  }

  void _onUpdate() {
    if (mounted) {
      Navigator.of(context).pop();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ViewUpdateApk(apkUrl: _updateHandler.remoteApkUrl),
        ),
      );
    }
  }

  void _onCancel() {
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  void _recheckVersionAndNavigate() async {
    await _updateHandler.checkForUpdates();

    if (!mounted) return;
    if (_updateHandler.isUpdateAvailable) {
      _dialogHandler.showUpdateDialog(
        context: context,
        updateHandler: _updateHandler,
        onUpdate: _onUpdate,
        onCancel: _onCancel,
      );
    } else {
      _navigateToDefaultTestPage();
    }
  }

  void _navigateToDefaultTestPage() {
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ViewDefaultTest()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Remote Config Example'),
      ),
      body: UpdateBody(
        updateHandler: _updateHandler,
        dialogHandler: _dialogHandler,
      ),
    );
  }
}
