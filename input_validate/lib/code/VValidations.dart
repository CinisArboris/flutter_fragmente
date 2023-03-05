import 'package:flutter/material.dart';

class VValidations extends StatefulWidget {
  const VValidations({super.key, required this.title});
  final String title;

  @override
  State<VValidations> createState() => _VValidationsState();
}

class _VValidationsState extends State<VValidations> {
  final _alicia = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            getForms(),
            buttons(),
          ],
        ),
      ),
    );
  }

  Widget getForms() {
    return Form(
      key: _alicia,
      child: Column(
        children: [
          alfa(),
          bravo(),
          charlie(),
          delta(),
          echo(),
        ],
      ),
    );
  }

  Widget alfa() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Campo requerido.";
          }
          return null;
        },
      ),
    );
  }

  Widget bravo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Campo requerido.";
          }
          return null;
        },
      ),
    );
  }

  Widget charlie() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Campo requerido.";
          }
          return null;
        },
      ),
    );
  }

  Widget delta() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Campo requerido.";
          }
          return null;
        },
      ),
    );
  }

  Widget echo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Campo requerido.";
          }
          return null;
        },
      ),
    );
  }

  Widget buttons() {
    return ElevatedButton(
      onPressed: () {
        if (_alicia.currentState!.validate()) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Processing Data')),
          );
        }
      },
      child: const Text('Siguiente'),
    );
  }
}
