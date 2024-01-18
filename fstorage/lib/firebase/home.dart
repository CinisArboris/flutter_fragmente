import 'dart:io';
import 'package:flutter/material.dart';
import 'image_uploader.dart';

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FutureBuilder<File?>(
              future: _imageFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (snapshot.hasData) {
                  return Image.file(snapshot.data!);
                }
                return const Text('No se ha seleccionado ninguna imagen.');
              },
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
