import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ImageUploader {
  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<File?> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    return pickedFile != null ? File(pickedFile.path) : null;
  }

  Future<void> uploadImage(File? image, String folderName) async {
    if (image == null) return;

    final directory = await getApplicationDocumentsDirectory();
    final fileName = image.path.split('/').last;
    final localImage = await image.copy('${directory.path}/$fileName');

    try {
      final ref = _storage.ref().child(folderName).child(fileName);
      await ref.putFile(localImage);

      // Aquí ya no necesitas procesar ni imprimir la URL, solo completa la subida.
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
