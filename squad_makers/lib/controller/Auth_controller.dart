import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:squad_makers/controller/set_database.dart';
import 'package:squad_makers/controller/user_controller.dart';
import 'package:squad_makers/model/login_model.dart';
import 'package:squad_makers/utils/toast_massage.dart';
import 'package:squad_makers/view/login_view/start_page.dart';
import 'package:squad_makers/view/main_view/mainPage.dart';

import 'checkValidation.dart';

AuthController authController = AuthController();

class AuthController {
  Future authUser(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          //password:hashPassword(password),
          password: password);
      await userController.fetchMyInfo(email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return '잘못된 이메일 입니다.';
      } else if (e.code == 'wrong-password') {
        return '비밀번호를 다시 한번 확인해주세요..';
      } else {
        return e.code.toString();
      }
    }
    return null;
  }

  Future<void> signUpUserCredential(
      {required email,
      required password,
      required nickname,
      required name}) async {
    UserCredential? result = await userController.createUser(email, password);
    User? user = result!.user;

    try {
      await SetDatabase(uid: user!.uid).setUserData(
          //DateTime.now(), email, hashPassword(password), name, nickname);
          DateTime.now(),
          email,
          password,
          name,
          nickname);
    } catch (e) {
      toastMessage(e.toString());
    }
  }

  Future<bool> login(email, password, FlutterSecureStorage storage) async {
    try {
      authUser(email, password);
      if (await authUser(email, password) == null) {
        final jsonBody = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: email)
            .get();
        final jsonvalue = jsonBody.docs[0].get('uid');

        var val = jsonEncode(Login('$email', '$password', '$jsonvalue'));

        await storage.write(
          key: 'login',
          value: val,
        );
        print('접속 성공 !!!');
        return true;
      } else {
        print('error');
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  void logout(storage) async {
    await storage.delete(key: 'login');
    Get.offAll(startPage());
  }

  void checkUserState(storage) async {
    dynamic userInfo = await storage.read(key: 'login');
    if (userInfo == null) {
      print('로그인 페이지로 이동');
      Get.offAll(startPage());
    } else {
      print('로그인 중');
    }
  }

  Future<void> asyncMethod(userInfo, FlutterSecureStorage storage) async {
    userInfo = await storage.read(key: 'login');

    if (userInfo != null) {
      final temp = Login.fromJson(json.decode(userInfo));
      await userController.fetchMyInfo(temp.accountName);
      Get.off(MainPage());
    }
  }

  Future<void> resetPassword(String email) async {
    final firebaseAuth = FirebaseAuth.instance;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
    {
      if (email.isEmpty) {
        return toastMessage('이메일을 입력해주세요.');
      } else if (!validateEmail(email)) {
        return toastMessage('유효한 이메일을 입력해주세요.');
      } else {
        if (querySnapshot.docs.isEmpty) {
          return toastMessage('존재하지 않는 이메일입니다.');
        } else {
          toastMessage('이메일 인증 메일을 보냈습니다!');
          firebaseAuth.sendPasswordResetEmail(email: email);
        }
      }
    }
  }

  Future<void> deleteUser(String docId, String password) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    users.doc(docId).delete();
    User? user = FirebaseAuth.instance.currentUser;
    await user!.delete();
  }
}
