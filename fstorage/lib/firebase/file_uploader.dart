import 'dart:io';
import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:fstorage/firebase/databasehelper.dart';

class FileUploader {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final Random _random = Random();

  String _generateFolderName() {
    final randomLetters =
        String.fromCharCodes(List.generate(3, (_) => 65 + _random.nextInt(26)));
    final now = DateTime.now();
    final formattedDate =
        '${now.day}_${now.month}_${now.year}_${now.hour}_${now.minute}_${now.second}';
    return '$randomLetters::$formattedDate';
  }

  Future<File?> obtenerImagenPortada() async {
    const imagenPath =
        '/data/user/0/com.cinisarboris.example.u03.fstorage/app_flutter.png';
    return File(imagenPath);
  }

  Future<File?> obtenerDatabase() async {
    // Obtener la ruta de la base de datos de forma dinámica
    String databasePath = await DatabaseHelper.getDatabasePath();
    File dbFile = File(databasePath);

    if (await dbFile.exists()) {
      // Si el archivo de la base de datos ya existe, simplemente lo devuelve.
      return dbFile;
    } else {
      // Si el archivo no existe, usa DatabaseHelper para crear la base de datos.
      DatabaseHelper helper = DatabaseHelper();
      // Esto inicializará y creará la base de datos si no existe.
      await helper.database;
      // Después de inicializar o crear la base de datos, devuelve el archivo.
      return dbFile;
    }
  }

  Future<File?> obtenerAudioPrincipal() async {
    const audioPath =
        '/data/user/0/com.cinisarboris.example.u03.fstorage/app_flutter.mp3';
    return File(audioPath);
  }

  Future<String?> uploadFiles() async {
    final folderName = _generateFolderName();

    final List<File> filesToUpload = [];

    // final imagenPortada = await obtenerImagenPortada();
    // if (imagenPortada != null) {
    // filesToUpload.add(imagenPortada);
    // }

    // final audioPrincipal = await obtenerAudioPrincipal();
    // if (audioPrincipal != null) {
    // filesToUpload.add(audioPrincipal);
    // }

    final database = await obtenerDatabase();
    if (database != null) {
      filesToUpload.add(database);
    }

    if (filesToUpload.isEmpty) {
      print('No se encontraron archivos para subir.');
      return null;
    }

    try {
      final List<String> downloadUrls = [];

      for (final file in filesToUpload) {
        final fileName = file.path.split('/').last;
        final ref = _storage.ref().child('$folderName/$fileName');
        await ref.putFile(file);
        final downloadUrl = await ref.getDownloadURL();
        downloadUrls.add(downloadUrl);
      }

      // Devolver la lista de URL de descarga de los archivos subidos
      return downloadUrls.join('\n');
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print('Error de Firebase: ${e.code}, ${e.message}');
      }
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print('Exception: ${e.toString()}');
      }
      throw 'Error al subir archivos: ${e.toString()}';
    }
  }
}
