import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fstorage/firebase/image_details.dart';
import 'package:fstorage/firebase/file_uploader.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.title});
  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isImageUploaded = false;
  File? _selectedImage;
  final FileUploader _imageUploader = FileUploader();
  String _uploadMessage = '';
  bool _isUploading = false;
  bool _showSpinner = false;

  Future<void> _uploadImageFromGallery() async {
    setState(() {
      _isImageUploaded = false;
      _uploadMessage = '';
      _isUploading = true;
      _showSpinner = true;
    });

    _imageUploader.uploadFiles().then((_) {
      if (kDebugMode) {
        print("Subida iniciada");
      }
    }).catchError((error) {
      if (kDebugMode) {
        print("Error al subir: $error");
      }
    });

    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      _isUploading = false;
      _isImageUploaded = true;
      _uploadMessage = 'La imagen se cargó con éxito.';
      _showSpinner = false;
    });

    _showSuccessDialog();
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.orange,
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
              onPressed: _isUploading ? null : _uploadImageFromGallery,
              child: Text(
                  _isUploading ? 'Cargando...' : 'Subir Imagen desde Galería'),
            ),
            if (_showSpinner) const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
