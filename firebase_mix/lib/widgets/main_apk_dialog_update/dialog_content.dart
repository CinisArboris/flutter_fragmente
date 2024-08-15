import 'package:flutter/material.dart';

Widget buildDialogContent(String versionDetail, String mobileVersion) {
  _logWithSeparator('Construyendo contenido del diálogo');
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 10),
      _buildNewVersionInfo(mobileVersion),
      const SizedBox(height: 10),
      _buildVersionDetails(versionDetail),
    ],
  );
}

Widget _buildNewVersionInfo(String mobileVersion) {
  _logWithSeparator('Construyendo información de la nueva versión');
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
  _logWithSeparator('Construyendo detalles de la versión');
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

void _logWithSeparator(String message) {
  // debugPrint(':::: UpdateDialog - $message');
}
