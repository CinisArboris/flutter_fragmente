import 'package:flutter/material.dart';

class UpdateAlertDialog extends StatelessWidget {
  final VoidCallback onUpdate;
  final VoidCallback onCancel;
  final String versionDetail;
  final String mobileVersion;

  const UpdateAlertDialog({
    super.key,
    required this.onUpdate,
    required this.onCancel,
    required this.versionDetail,
    required this.mobileVersion,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint(':::: UpdateDialog - Renderizando diálogo de actualización');
    return AlertDialog(
      backgroundColor: Colors.red[600], // Fondo rojo
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: _buildTitle(),
      content: _buildContent(),
      actions: _buildActions(context),
    );
  }

  Widget _buildTitle() {
    debugPrint(':::: UpdateDialog - Construyendo título del diálogo');
    return const Row(
      children: [
        Icon(Icons.system_update, color: Colors.white),
        SizedBox(width: 10),
        Text(
          'Actualización disponible',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  Widget _buildContent() {
    debugPrint(':::: UpdateDialog - Construyendo contenido del diálogo');
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10), // Separación entre título y descripción
        _buildNewVersionInfo(),
        const SizedBox(height: 10),
        _buildVersionDetails(),
      ],
    );
  }

  Widget _buildNewVersionInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.new_releases, color: Colors.white),
            SizedBox(width: 5),
            Text(
              'Nueva versión:',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        Text(
          mobileVersion,
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildVersionDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.info_outline, color: Colors.white),
            SizedBox(width: 5),
            Text(
              'Detalles de la versión:',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        Text(
          versionDetail,
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    debugPrint(':::: UpdateDialog - Construyendo botones de acción');
    return [
      TextButton(
        onPressed: () {
          debugPrint(':::: UpdateDialog - Botón "Cancelar" presionado');
          onCancel();
        },
        child: const Text(
          'Cancelar',
          style: TextStyle(color: Colors.white),
        ),
      ),
      ElevatedButton(
        onPressed: () {
          debugPrint(':::: UpdateDialog - Botón "Actualizar" presionado');
          onUpdate();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
        ),
        child: const Text(
          'Actualizar',
          style: TextStyle(color: Colors.red),
        ),
      ),
    ];
  }
}
