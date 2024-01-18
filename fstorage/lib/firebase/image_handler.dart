import 'dart:io';
import 'dart:math';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ImageHandler {
  Future<File?> pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    return pickedFile != null ? File(pickedFile.path) : null;
  }

  Future<File?> pickRandomImage() async {
    final picker = ImagePicker();
    final pickedFileList = await picker.pickMultiImage();

    if (pickedFileList.isNotEmpty) {
      final random = Random();
      var randomImage = pickedFileList[random.nextInt(pickedFileList.length)];
      return File(randomImage.path);
    }
    return null;
  }

  Future<File> saveImage(File image) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName = image.path.split('/').last;
    final File localImage = await image.copy('${directory.path}/$fileName');
    return localImage;
  }

  Future<void> uploadImageToFirebase(File image, String alias) async {
    DateTime now = DateTime.now();
    String formattedDate =
        "${now.day}_${now.month}_${now.year}_${now.hour}_${now.minute}_${now.second}";
    String folderName = '${alias}_$formattedDate';
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref =
        storage.ref().child(folderName).child(image.path.split('/').last);
    await ref.putFile(image);
  }

  String generateRandomAlias() {
    const alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    final random = Random();
    return String.fromCharCodes(
      Iterable.generate(
        3,
        (_) => alphabet.codeUnitAt(
          random.nextInt(alphabet.length),
        ),
      ),
    );
  }
}
