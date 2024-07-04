import 'package:flutter/material.dart';

class WidgetForms extends StatelessWidget {
  final List<TextEditingController> _controllers = List.generate(
    20,
    (index) => TextEditingController(),
  );

  WidgetForms({super.key});

  void _saveForm() {
    for (var i = 0; i < _controllers.length; i++) {
      debugPrint(
          "Test ${String.fromCharCode(65 + i)}: ${_controllers[i].text}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          _controllers.length,
          (index) => TextFormField(
            controller: _controllers[index],
            decoration: InputDecoration(
              labelText: 'Test ${String.fromCharCode(65 + index)}',
            ),
          ),
        )
          ..add(
            const SizedBox(height: 20),
          )
          ..add(
            Center(
              child: ElevatedButton(
                onPressed: _saveForm,
                child: const Text('Save'),
              ),
            ),
          ),
      ),
    );
  }
}
