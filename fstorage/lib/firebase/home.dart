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
  Future<File?>? _imageFuture;
  final ImageUploader _imageUploader = ImageUploader();

  void _uploadImageFromGallery() {
    setState(() {
      _imageFuture = _imageUploader
          .pickImage()
          .then((file) => _imageUploader.uploadImage(file, "gallery_images"));
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
        child: FutureBuilder<File?>(
          future: _imageFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return const Icon(Icons.error, color: Colors.red, size: 48);
            } else if (snapshot.hasData) {
              return const Icon(Icons.check_circle,
                  color: Colors.green, size: 48);
            } else {
              return ElevatedButton(
                onPressed: _uploadImageFromGallery,
                child: const Text('Subir Imagen desde Galería'),
              );
            }
          },
        ),
      ),
    );
  }
}
