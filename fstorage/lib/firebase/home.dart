import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fstorage/firebase/f_s_s.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.title});
  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<File?>? _imageFuture;
  final FirebaseStorageService _firebaseStorageService =
      FirebaseStorageService();

  void _uploadImageFromGallery() {
    setState(() {
      _imageFuture = _firebaseStorageService.uploadImageFromGallery();
    });
  }

  void _uploadRandomImage() {
    setState(() {
      _imageFuture = _firebaseStorageService.uploadRandomImage();
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
            ElevatedButton(
              onPressed: _uploadRandomImage,
              child: const Text('Subir Imagen Aleatoria de Galería'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _uploadRandomImage,
        tooltip: 'Subir Imagen',
        child: const Icon(Icons.cloud_upload),
      ),
    );
  }
}
