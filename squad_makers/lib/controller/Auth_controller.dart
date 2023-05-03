import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:squad_makers/classes/toast_massage.dart';
import 'package:squad_makers/controller/Database_controller.dart';
import 'package:squad_makers/controller/hash_password.dart';
import 'package:squad_makers/model/app_view_model.dart';
import 'package:squad_makers/model/login_model.dart';
import 'package:squad_makers/view/login_view/start_page.dart';
import 'package:squad_makers/view/squadPage.dart';

AuthController authController = AuthController();

class AuthController {
  Future authUser(String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: hashPassword(password),
      );
      AppViewModel appData = Get.find();
      await databasecontroller.fetchMyInfo(appData.myInfo.email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        return '잘못된 이메일 입니다.';
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        return '비밀번호를 다시 한번 확인해주세요..';
      } else {
        print(e.code.toString());
        return null;
      }
    }
    return null;
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

  void asyncMethod(userInfo, FlutterSecureStorage storage) async {
    userInfo = await storage.read(key: 'login');

    if (userInfo != null) {
      Get.off(SquadPage());
    } else {
      toastMessage('로그인이 필요합니다');
    }
  }
}
