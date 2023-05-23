import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:squad_makers/controller/image_helper.dart';
import 'package:squad_makers/controller/storage_controller.dart';

ImagePickUploader imagePickUploader = ImagePickUploader();

class ImagePickUploader {
  final _picker = ImagePicker();
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  final CollectionReference clubCollection =
      FirebaseFirestore.instance.collection('clubs');
  Future<String?> pickAndUpload(
    String uploadPath,
  ) async {
    try {
      XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      print(image?.path ?? 'null');
      if (image != null) {
        var result = await storageController.uploadFile(
          filePath: image.path,
          uploadPath: uploadPath,
        );

        return result;
      }
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<XFile?> getImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      return image;
    } else {
      return null;
    }
  }

  Future<String> uploadProfileImageToStorage(XFile result) async {
    User? _user = _firebaseAuth.currentUser;

    File image = File(result.path);
    Reference storageReference =
        firebaseStorage.ref().child("profile/${_user?.uid}");

    final File resultImage = await compute(getResizedProfileImage, image);

    final UploadTask uploadTask = storageReference.putFile(resultImage);

    String downloadURL = await (await uploadTask).ref.getDownloadURL();

    await userCollection.doc(_user?.uid).update({'image': downloadURL});

    return downloadURL;
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
