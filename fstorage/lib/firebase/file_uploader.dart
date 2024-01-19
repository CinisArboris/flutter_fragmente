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

  Future<File?> obtenerDatabase() async {
    String databasePath = await DatabaseHelper.getDatabasePath();
    File dbFile = File(databasePath);

    if (await dbFile.exists()) {
      return dbFile;
    } else {
      DatabaseHelper helper = DatabaseHelper();
      await helper.database;
      return dbFile;
    }
  }

  Future<String?> uploadFiles() async {
    final folderName = _generateFolderName();

    final List<File> filesToUpload = [];

    final database = await obtenerDatabase();
    if (database != null) {
      filesToUpload.add(database);
    }

    if (filesToUpload.isEmpty) {
      if (kDebugMode) {
        print('No se encontraron archivos para subir.');
      }
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
