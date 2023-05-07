import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:squad_makers/classes/toast_massage.dart';
import 'package:squad_makers/controller/database_service.dart';
import 'package:squad_makers/controller/hash_password.dart';
import 'package:squad_makers/model/app_view_model.dart';
import 'package:squad_makers/model/myinfo.dart';
import 'package:squad_makers/model/position_model.dart';

Databasecontroller databasecontroller = Databasecontroller();

class Databasecontroller {
  Future<UserCredential?> createUser(String email, String pw) async {
    try {
      UserCredential credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: hashPassword(pw),
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

  void signUpUserCredential(
      {required email,
      required password,
      required nickname,
      required name}) async {
    UserCredential? result = await createUser(email, password);
    User? user = result!.user;

    try {
      await DatabaseService(uid: user!.uid).setUserData(
          DateTime.now(), email, hashPassword(password), name, nickname);
    } catch (e) {
      toastMessage(e.toString());
    }
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

  Future<void> positionInfoLoad(
      String position, String category, String docId) async {
    AppViewModel appData = Get.find();
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await firestore
        .collection('PositionInfo')
        .doc(position)
        .collection(category)
        .where(docId)
        .get();
    if (querySnapshot.docs.isEmpty) {
    } else {
      appData.positionInfo = PositionInfo.fromJson(
          querySnapshot.docs.first.data() as Map<String, dynamic>);
    }
  }
}
