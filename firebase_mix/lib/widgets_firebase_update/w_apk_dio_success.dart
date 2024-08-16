import 'package:flutter/material.dart';

class DioSuccessWidget extends StatelessWidget {
  const DioSuccessWidget({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint(':::: DioSuccess - Renderizando widget de éxito');
    return Center(
      child: _buildSuccessCard(context),
    );
  }

  Widget _buildSuccessCard(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSuccessIcon(),
            const SizedBox(height: 20),
            _buildSuccessMessage(),
            const SizedBox(height: 20),
            _buildBackButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessIcon() {
    return const Icon(Icons.check_circle, color: Colors.green, size: 80);
  }

  Widget _buildSuccessMessage() {
    return const Text(
      'Descarga completada.',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 16),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        debugPrint(':::: DioSuccess - Botón "Volver" presionado');
        Navigator.of(context).pop();
      },
      child: const Text('Volver'),
    );
  }
}
