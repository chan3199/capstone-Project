import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:squad_makers/utils/toast_massage.dart';
import 'package:squad_makers/controller/database_service.dart';
import 'package:squad_makers/model/myinfo.dart';
import '../utils/hash_password.dart';
import '../view_model/app_view_model.dart';

UserController userController = UserController();

class UserController {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  Future<UserCredential?> createUser(String email, String pw) async {
    try {
      UserCredential credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: pw,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        toastMessage('비밀번호가 너무 약하다');
      } else if (e.code == 'email-already-in-use') {
        toastMessage('사용 중인 이메일이다.');
      }
    } catch (e) {
      toastMessage(e.toString());
    }
    return null;
  }

  Future<void> fetchMyInfo(String email) async {
    AppViewModel appData = Get.find();
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    if (querySnapshot.docs.isEmpty) {
    } else {
      appData.myInfo = MyInfo.fromJson(
          querySnapshot.docs.first.data() as Map<String, dynamic>);
    }
  }

  void updataMyPassword(String uid, String password) {
    DocumentReference users =
        FirebaseFirestore.instance.collection('users').doc(uid);
    users
        .update({'password': password})
        .then((value) => print("User password Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  void updataMyName(String uid, String name) {
    DocumentReference users =
        FirebaseFirestore.instance.collection('users').doc(uid);
    users
        .update({'name': name})
        .then((value) => print("User name Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  void updataMynickname(String uid, String nickname) {
    DocumentReference users =
        FirebaseFirestore.instance.collection('users').doc(uid);
    users
        .update({'nickname': nickname})
        .then((value) => print("User nickname Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<String?> getdocidtouser(String user) async {
    QuerySnapshot querySnapshot =
        await userCollection.where('email', isEqualTo: user).get();
    if (querySnapshot.docs.isEmpty) {
      return null;
    } else {
      MyInfo usermodel = MyInfo.fromJson(
          querySnapshot.docs.first.data() as Map<String, dynamic>);
      return usermodel.uid;
    }
  }

  Future<MyInfo?> getuserdataToemail(String useremail) async {
    QuerySnapshot querySnapshot =
        await userCollection.where('email', isEqualTo: useremail).get();

    if (querySnapshot.docs.isEmpty) {
      return null;
    } else {
      MyInfo usermodel = MyInfo.fromJson(
          querySnapshot.docs.first.data() as Map<String, dynamic>);
      return usermodel;
    }
  }

  Future<MyInfo?> getuserdataTouid(String uid) async {
    QuerySnapshot querySnapshot =
        await userCollection.where('uid', isEqualTo: uid).get();

    if (querySnapshot.docs.isEmpty) {
      return null;
    } else {
      MyInfo usermodel = MyInfo.fromJson(
          querySnapshot.docs.first.data() as Map<String, dynamic>);
      return usermodel;
    }
  }
}
