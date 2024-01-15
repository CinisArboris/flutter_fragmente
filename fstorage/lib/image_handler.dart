import 'dart:io';
import 'dart:math';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ImageHandler {
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
    final path = directory.path;
    const String fileName = 'test.jpg';
    final File localImage = await image.copy('$path/$fileName');
    return localImage;
  }

  Future<void> uploadImageToFirebase(File image, String alias) async {
    DateTime now = DateTime.now();
    String formattedDate =
        "${now.day}_${now.month}_${now.year}_${now.hour}_${now.minute}_${now.second}";
    String folderName = '$alias\_$formattedDate';
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child(folderName).child('test.jpg');
    await ref.putFile(image);
  }
}
