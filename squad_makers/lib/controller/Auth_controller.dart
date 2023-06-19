import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:squad_makers/controller/set_database.dart';
import 'package:squad_makers/controller/user_controller.dart';
import 'package:squad_makers/model/club_model.dart';
import 'package:squad_makers/model/login_model.dart';
import 'package:squad_makers/utils/toast_massage.dart';
import 'package:squad_makers/view/login_view/start_page.dart';
import 'package:squad_makers/view/main_view/mainPage.dart';
import 'package:squad_makers/view_model/app_view_model.dart';

import '../model/moveableitem_model.dart';
import '../model/user_model.dart';
import '../model/squadApp_model.dart';
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
      await SetDatabase(uid: user!.uid)
          .setUserData(DateTime.now(), email, password, name, nickname);
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
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  void logout(storage) async {
    await storage.delete(key: 'login');
    Get.offAll(const startPage());
  }

  void checkUserState(storage) async {
    dynamic userInfo = await storage.read(key: 'login');
    if (userInfo == null) {
      print('로그인 페이지로 이동');
      Get.offAll(const startPage());
    } else {
      print('로그인 중');
    }
  }

  Future<void> asyncMethod(userInfo, FlutterSecureStorage storage) async {
    userInfo = await storage.read(key: 'login');

    if (userInfo != null) {
      final temp = Login.fromJson(json.decode(userInfo));
      await userController.fetchMyInfo(temp.accountName);
      Get.off(const MainPage());
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

  Future<void> deleteUser(
      String uid, String password, FlutterSecureStorage storage) async {
    CollectionReference userCollection =
        FirebaseFirestore.instance.collection('users');
    CollectionReference clubCollection =
        FirebaseFirestore.instance.collection('clubs');
    final CollectionReference squadCollection =
        FirebaseFirestore.instance.collection('squads');
    AppViewModel appData = Get.find();

    User? user = FirebaseAuth.instance.currentUser;

    MyInfo? usermodel = await userController.getuserdataTouid(uid);
    await user!.reauthenticateWithCredential(EmailAuthProvider.credential(
        email: appData.myInfo.email, password: password));
    List<dynamic> clubs = appData.myInfo.myclubs;
    for (var clubname in clubs) {
      DocumentSnapshot documentSnapshot =
          await clubCollection.doc(clubname).get();
      ClubModel clubModel =
          ClubModel.fromJson(documentSnapshot.data() as Map<String, dynamic>);
      clubModel.clubuserlist.remove(uid);
      usermodel!.myclubs.remove(clubModel.name);
      await userCollection.doc(uid).update({'myclubs': usermodel.myclubs});
      if (clubModel.squadlist.isNotEmpty) {
        for (String squad in clubModel.squadlist) {
          DocumentSnapshot documentsnapshot =
              await squadCollection.doc(squad).get();
          SquadAppModel squadmodel = SquadAppModel.fromJson(
              documentsnapshot.data() as Map<String, dynamic>);
          if (squadmodel.userlist.contains(uid)) {
            squadmodel.userlist.remove(uid);
          }
          if (squadmodel.subplayers.contains(uid)) {
            squadmodel.subplayers.remove(uid);
          }
          CollectionReference cr =
              squadCollection.doc(squad).collection('players');
          cr.get().then((querySnapshot) {
            querySnapshot.docs.forEach((element) async {
              if (element.data() != null) {
                MoveableItem moveableitem = MoveableItem.fromJson(
                    element.data() as Map<String, dynamic>);
                if (usermodel.email == moveableitem.userEmail) {
                  await element.reference.update({
                    'movement': '',
                    'number': 0,
                    'role': '',
                    'userEmail': '',
                    'memo': '',
                    'position': ''
                  });
                }
              }
            });
          });
        }
      }
      clubModel.clubuserlist.remove(uid);
      clubModel.clubuser -= 1;
      await clubCollection.doc(clubModel.name).update({
        'clubuserlist': clubModel.clubuserlist,
        'clubuser': clubModel.clubuser
      });
    }

    userCollection.doc(uid).delete();
    await user.delete();
    authController.logout(storage);
    print('회원 탈퇴 성공');
    toastMessage('회원 탈퇴가 되었습니다!');
    // } catch (e) {
    //   print('회원 탈퇴 실패: $e');
    //   toastMessage('회원 탈퇴에 실패하였습니다! 비밀번호를 다시 확인해주세요!');
    // }
  }
  //}
}
