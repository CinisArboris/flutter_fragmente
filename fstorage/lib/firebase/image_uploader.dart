import 'dart:io';
import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ImageUploader {
  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final _random = Random();

  String _generateFolderName() {
    final randomLetters =
        String.fromCharCodes(List.generate(3, (_) => 65 + _random.nextInt(26)));
    final now = DateTime.now();
    final formattedDate =
        '${now.day}_${now.month}_${now.year}_${now.hour}_${now.minute}_${now.second}';
    return '$randomLetters::$formattedDate';
  }

  Future<File?> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    return pickedFile != null ? File(pickedFile.path) : null;
  }

  Future<String?> uploadImage(String folderName) async {
    final directory = await getApplicationDocumentsDirectory();
    final appImageCachePath = directory.path;

    final imageFileName = '1705203386.png';

    final image = File('$appImageCachePath/$imageFileName');

    if (!image.existsSync()) {
      print(
          'La imagen no se encuentra en la ubicación esperada: $appImageCachePath');
      return null;
    }

    try {
      final folderName = _generateFolderName();
      final ref = _storage.ref().child(folderName);
      await ref.putFile(image);

      return await ref.getDownloadURL();
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print('Error de Firebase: ${e.code}, ${e.message}');
      }
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print('Exception: ${e.toString()}');
      }
      throw 'Error al subir imagen: ${e.toString()}';
    }
  }
}
