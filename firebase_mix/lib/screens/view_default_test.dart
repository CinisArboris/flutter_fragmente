import 'package:flutter/material.dart';

class ViewDefaultTest extends StatelessWidget {
  const ViewDefaultTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Ruta'),
      ),
      body: const Center(
        child: Text('Esta es la nueva ruta'),
      ),
    );
  }
}
