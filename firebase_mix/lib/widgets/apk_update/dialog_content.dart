import 'package:flutter/material.dart';

Widget buildDialogContent(String versionDetail, String mobileVersion) {
  debugPrint(':::: UpdateDialog - Construyendo contenido del diálogo');
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Separación entre título y descripción
      const SizedBox(height: 10),
      _buildNewVersionInfo(mobileVersion),
      const SizedBox(height: 10),
      _buildVersionDetails(versionDetail),
    ],
  );
}

Widget _buildNewVersionInfo(String mobileVersion) {
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

Widget _buildVersionDetails(String versionDetail) {
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
