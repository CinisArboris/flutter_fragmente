import 'package:flutter/material.dart';

class NewRoute extends StatelessWidget {
  const NewRoute({super.key});

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
