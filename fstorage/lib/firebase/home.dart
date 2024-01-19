import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fstorage/firebase/image_details.dart';
import 'package:fstorage/firebase/image_uploader.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.title});
  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isImageUploaded = false;
  File? _selectedImage;
  final ImageUploader _imageUploader = ImageUploader();
  String _uploadMessage = '';

  Future<void> _uploadImageFromGallery() async {
    setState(() {
      _isImageUploaded = false;
      _uploadMessage = '';
    });

    // Mostrar spinner durante 3 segundos
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // Esperar 3 segundos antes de continuar
    await Future.delayed(const Duration(seconds: 3));

    // Realizar la llamada asincrónica
    if (_selectedImage != null) {
      try {
        final folderName = await _imageUploader.uploadImage("gallery_images");
        if (folderName != null) {
          setState(() {
            _isImageUploaded = true;
            _uploadMessage = 'La imagen se cargó con éxito.';
          });
          Navigator.of(context).pop(); // Cerrar el spinner
          _showSuccessDialog(); // Mostrar el AlertDialog de éxito
        } else {
          setState(() {
            _uploadMessage = 'Error al cargar la imagen.';
          });
          Navigator.of(context).pop(); // Cerrar el spinner en caso de error
        }
      } catch (error) {
        setState(() {
          _uploadMessage = 'Error al cargar la imagen: $error';
        });
        Navigator.of(context).pop(); // Cerrar el spinner en caso de error
      }
    }
  }

  void _showSuccessDialog() {
    // Mostrar un AlertDialog informativo
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.orange, // Color de fondo naranja
          title: const Text('Archivo enviado'),
          content: const Text('La solicitud se ha enviado con éxito.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Aceptar'),
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
          children: [
            if (_selectedImage != null) ImageDetails(image: _selectedImage!),
            if (_isImageUploaded)
              const Icon(Icons.check_circle, color: Colors.green, size: 48),
            Text(
              _uploadMessage,
              style: TextStyle(
                color: _isImageUploaded ? Colors.green : Colors.red,
                fontSize: 16,
              ),
            ),
            ElevatedButton(
              onPressed: _uploadImageFromGallery,
              child: const Text('Subir Imagen desde Galería'),
            ),
          ],
        ),
      ),
    );
  }
}
