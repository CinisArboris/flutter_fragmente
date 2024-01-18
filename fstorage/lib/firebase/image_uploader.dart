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

  Future<File?> uploadImage(File? image, String folderName) async {
    if (image == null) return null;

    final directory = await getApplicationDocumentsDirectory();
    final fileName = image.path.split('/').last;
    final localImage = await image.copy('${directory.path}/$fileName');

    try {
      final ref = _storage.ref().child(folderName).child(fileName);
      UploadTask uploadTask = ref.putFile(localImage);

      TaskSnapshot snapshot = await uploadTask;

      if (snapshot.state == TaskState.success) {
        // Aquí puedes agregar cualquier procesamiento adicional después de una subida exitosa
        final downloadUrl = await snapshot.ref.getDownloadURL();
        if (kDebugMode) {
          print('Carga exitosa. URL: $downloadUrl');
        }
        // Por ejemplo, podrías devolver la URL de descarga en lugar del archivo local
        return localImage; // o return downloadUrl;
      } else {
        if (kDebugMode) {
          print('Error en la subida. Estado: ${snapshot.state}');
        }
        return null;
      }
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
