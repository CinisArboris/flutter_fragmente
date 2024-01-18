import 'dart:io';

import 'package:fstorage/firebase/image_handler.dart';

class FirebaseStorageService {
  final ImageHandler _imageHandler = ImageHandler();

  Future<File?> uploadImageFromGallery() async {
    File? selectedImage = await _imageHandler.pickImageFromGallery();
    return await _uploadImage(selectedImage);
  }

  Future<File?> uploadRandomImage() async {
    File? randomImage = await _imageHandler.pickRandomImage();
    return await _uploadImage(randomImage);
  }

  Future<File?> _uploadImage(File? image) async {
    if (image == null) {
      return null; // No se seleccionó ninguna imagen
    }
    try {
      String alias = _imageHandler.generateRandomAlias();
      File savedImage = await _imageHandler.saveImage(image);
      await _imageHandler.uploadImageToFirebase(savedImage, alias);
      return savedImage;
    } catch (e) {
      // Rethrow the exception
      rethrow;
    }
  }
}
