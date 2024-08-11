import 'package:flutter/material.dart';

class DioErrorWidget extends StatelessWidget {
  final Object? error;

  const DioErrorWidget({
    super.key,
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.error, color: Colors.red, size: 80),
        const SizedBox(height: 20),
        Text('Error: $error'),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Volver'),
        ),
      ],
    );
  }
}
