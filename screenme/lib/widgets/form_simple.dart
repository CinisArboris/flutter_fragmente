import 'package:flutter/material.dart';

class FormWidget extends StatelessWidget {
  final List<TextEditingController> _controllers = List.generate(
    20,
    (index) => TextEditingController(),
  );

  FormWidget({super.key});

  void _saveForm() {
    for (int i = 0; i < _controllers.length; i++) {
      debugPrint(
          "Test ${String.fromCharCode(65 + i)}: ${_controllers[i].text}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          for (int i = 0; i < _controllers.length; i++)
            TextFormField(
              controller: _controllers[i],
              decoration: InputDecoration(
                  labelText: 'Test ${String.fromCharCode(65 + i)}'),
            ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: _saveForm,
              child: const Text('Save'),
            ),
          ),
        ],
      ),
    );
  }
}
