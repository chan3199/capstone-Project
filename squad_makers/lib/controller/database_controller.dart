import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:squad_makers/model/position_model.dart';
import 'package:squad_makers/view_model/app_view_model.dart';

Databasecontroller databasecontroller = Databasecontroller();

class Databasecontroller {
  Future<bool> isDuplicatedNickname(String nickname) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('nickname', isEqualTo: nickname)
        .get();
    if (querySnapshot.docs.isEmpty) {
      return false;
    } else {
      return true;
    }
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
}
