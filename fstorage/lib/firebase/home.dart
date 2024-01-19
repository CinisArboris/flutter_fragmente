import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fstorage/firebase/image_uploader.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.title});
  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isUploading = false;

  final ImageUploader _imageUploader = ImageUploader();

  void _uploadImageFromGallery() {
    _imageUploader.pickImage().then((file) {
      setState(() {
        _isUploading = true;
      });
      return _imageUploader.uploadImage(file, "gallery_images");
    }).then((_) {
      setState(() {
        _isUploading = false;
      });
    });
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
            if (_isUploading)
              const CircularProgressIndicator()
            else
              const Icon(Icons.check_circle, color: Colors.green, size: 48),
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
