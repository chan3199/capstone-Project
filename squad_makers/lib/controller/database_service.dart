import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;

  DatabaseService({required this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference clubCollection =
      FirebaseFirestore.instance.collection('clubs');

  Future setUserData(
    DateTime date,
    String email,
    String password,
    String name,
    String nickname,
  ) async {
    await userCollection.doc(uid).set({
      'date': date,
      'image': '',
      'email': email,
      'password': password,
      'name': name,
      'nickname': nickname,
      'myclubs': [],
      'invitions': [],
      'uid': uid,
    });
  }

  Future updateUserData(
    String email,
    String password,
    String name,
    String nickname,
  ) async {
    await userCollection.doc(uid).update({
      'name': name,
      'password': password,
      'nickname': nickname,
    });
  }

  Future setClubData(String _name, String _image, String _info) async {
    await clubCollection.doc(_name).set({
      'date': DateTime.now(),
      'name': _name,
      'image': _image,
      'info': _info,
      'clubmaster': uid,
      'clubuserlist': [uid],
      'clubuser': 1,
      'squadlist': []
    });
  }
}
