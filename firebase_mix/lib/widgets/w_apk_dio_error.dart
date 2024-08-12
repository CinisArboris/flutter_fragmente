import 'package:flutter/material.dart';

class DioErrorWidget extends StatelessWidget {
  final Object? error;

  const DioErrorWidget({
    super.key,
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint(
        ':::: DioError - Renderizando widget de error con mensaje: $error');
    return Center(
      child: _buildErrorContent(context),
    );
  }

  Widget _buildErrorContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildErrorIcon(),
        const SizedBox(height: 20),
        _buildErrorMessage(),
        const SizedBox(height: 20),
        _buildBackButton(context),
      ],
    );
  }

  Widget _buildErrorIcon() {
    return const Icon(Icons.error, color: Colors.red, size: 80);
  }

  Widget _buildErrorMessage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        'Error: $error',
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 16, color: Colors.black),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        debugPrint(':::: DioError - Botón "Volver" presionado');
        Navigator.of(context).pop();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: const Text('Volver', style: TextStyle(color: Colors.white)),
    );
  }
}
