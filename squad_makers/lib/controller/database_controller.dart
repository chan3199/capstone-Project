import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:squad_makers/classes/toast_massage.dart';
import 'package:squad_makers/controller/database_service.dart';
import 'package:squad_makers/model/myinfo.dart';
import 'package:squad_makers/model/position_model.dart';
import '../model/club_model.dart';
import '../utils/hash_password.dart';
import '../view_model/app_view_model.dart';

Databasecontroller databasecontroller = Databasecontroller();

class Databasecontroller {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  AppViewModel appdata = Get.find();

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

  // Future<void> positionInfoLoad(String docId) async {
  //   AppViewModel appData = Get.find();
  //   FirebaseFirestore firestore = FirebaseFirestore.instance;
  //   QuerySnapshot querySnapshot = await firestore
  //       .collection('test')
  //       .where('docId', isEqualTo: docId)
  //       .get();
  //   if (querySnapshot.docs.isEmpty) {
  //   } else {
  //     appData.positionInfo = PositionInfo.fromJson(
  //         querySnapshot.docs.first.data() as Map<String, dynamic>);
  //   }
  // }

  Future<void> positionInfoLoad(
      String position, String catecory, String docId) async {
    AppViewModel appData = Get.find();
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot documentSnapshot = await firestore
        .collection('PositionInfo')
        .doc(position)
        .collection(catecory)
        .doc(docId)
        .get();
    if (documentSnapshot.data() == null) {
    } else {
      appData.positionInfo = PositionInfo.fromJson(
          documentSnapshot.data() as Map<String, dynamic>);
    }
  }

  Future<List<dynamic>> getclubuserlist(List<dynamic> clubuserlist) async {
    List<dynamic> resultclublist = [];
    for (var element in clubuserlist) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: element)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        MyInfo usermodel = MyInfo.fromJson(
            querySnapshot.docs.first.data() as Map<String, dynamic>);
        resultclublist.add(usermodel);
      }
    }
    return resultclublist;
  }

  Future<void> loadClubInfo(String name) async {
    AppViewModel appData = Get.find();
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('clubs')
        .where('name', isEqualTo: name)
        .get();

    if (querySnapshot.docs.isEmpty) {
    } else {
      appData.clubModel = ClubModel.fromJson(
          querySnapshot.docs.first.data() as Map<String, dynamic>);
    }
  }

  void addclubs(String uid, List<dynamic> myclubs) {
    userCollection.doc(uid).update({'myclubs': myclubs});
  }

  Future<List<dynamic>> getclublist() async {
    List<dynamic> clublist = appdata.myInfo.myclubs;
    List<dynamic> resultclublist = [];
    for (var element in clublist) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('clubs')
          .where('name', isEqualTo: element)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        ClubModel clubmodel = ClubModel.fromJson(
            querySnapshot.docs.first.data() as Map<String, dynamic>);
        resultclublist.add(clubmodel);
      }
    }
    return resultclublist;
  }

  Future<bool> isDuplicatedEmail(String email) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
    if (querySnapshot.docs.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  Future<bool> isDuplicatedclubname(String clubname) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('clubs')
        .where('name', isEqualTo: clubname)
        .get();
    if (querySnapshot.docs.isEmpty) {
      return false;
    } else {
      return true;
    }
  }
}
