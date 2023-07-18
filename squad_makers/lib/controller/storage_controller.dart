import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:squad_makers/utils/toast_massage.dart';
import 'package:squad_makers/utils/image_helper.dart';

StorageController storageController = StorageController();

class StorageController {
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  Future<String?> uploadFile(
      {required String filePath, required String uploadPath}) async {
    File file = File(filePath);

    try {
      var task = await FirebaseStorage.instance.ref(uploadPath).putFile(file);

      return await task.ref.getDownloadURL();
    } on FirebaseException catch (e) {
      toastMessage(e.code);
    }
    return null;
  }

  void deleteFile(String url) async {
    try {
      await FirebaseStorage.instance.refFromURL(url).delete();
    } on FirebaseException catch (e) {
      toastMessage(e.code);
    }
  }

  Future<String> uploadClubImageToStorage(String name, XFile result) async {
    File image = File(result.path);
    Reference storageReference = firebaseStorage.ref().child("club/$name");

    final File resultImage = await compute(getResizedProfileImage, image);

    final UploadTask uploadTask = storageReference.putFile(resultImage);

    String downloadURL = await (await uploadTask).ref.getDownloadURL();

    return downloadURL;
  }
}
