import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fstorage/image_handler.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
    required this.title,
  });
  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  File? _image;
  final ImageHandler _imageHandler = ImageHandler();
  final String _alias = "XYZ";

  void _uploadImage() async {
    File? randomImage = await _imageHandler.pickRandomImage();
    if (randomImage != null) {
      File savedImage = await _imageHandler.saveImage(randomImage);
      await _imageHandler.uploadImageToFirebase(savedImage, _alias);
      setState(() {
        _image = savedImage;
      });
      _showUploadSuccessDialog();
    }
  }

  void _showUploadSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Subida Exitosa'),
          content:
              const Text('La imagen se ha subido correctamente a Firebase.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image == null
                ? const Text('No se ha seleccionado ninguna imagen.')
                : Image.file(_image!),
            ElevatedButton(
              onPressed: _uploadImage,
              child: const Text('Subir Imagen al Azar a Firebase'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _uploadImage,
        tooltip: 'Subir Imagen',
        child: const Icon(Icons.cloud_upload),
      ),
    );
  }
}
