import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:squad_makers/classes/toast_massage.dart';

StorageController storageController = StorageController();

class StorageController {
  Future<String?> uploadFile(
      {required String filePath, required String uploadPath}) async {
    File file = File(filePath);

    try {
      var task = await FirebaseStorage.instance.ref(uploadPath).putFile(file);

      return await task.ref.getDownloadURL();
    } on FirebaseException catch (e) {
      print(e.code);
      toastMessage(e.code);
    }
    return null;
  }

  deleteFile(String url) async {
    try {
      print(url);
      await FirebaseStorage.instance.refFromURL(url).delete();
    } on FirebaseException catch (e) {
      print(e.code);
      toastMessage(e.code);
    }
  }
}
