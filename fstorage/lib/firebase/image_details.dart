import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ImageDetails extends StatelessWidget {
  final File image;

  const ImageDetails({
    super.key,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print('Path: ${image.path}');
    }
    if (kDebugMode) {
      print('Nombre: ${image.path.split('/').last}');
    }

    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text('Path: ${image.path}'),
          ),
          ListTile(
            title: Text('Nombre: ${image.path.split('/').last}'),
          ),
          FutureBuilder<int>(
            future: image.length(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (kDebugMode) {
                  print('Tamaño: ${snapshot.data} bytes');
                }
                return ListTile(
                  title: Text('Tamaño: ${snapshot.data} bytes'),
                );
              } else {
                return const SizedBox();
              }
            },
          ),
        ],
      ),
    );
  }
}
