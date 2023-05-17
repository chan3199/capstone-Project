import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:squad_makers/classes/toast_massage.dart';

class DatabaseService {
  final String uid;

  DatabaseService({required this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference clubCollection =
      FirebaseFirestore.instance.collection('clubs');

  Future setUserData(
    DateTime date,
    String _email,
    String _password,
    String _name,
    String _nickname,
  ) async {
    await userCollection.doc(uid).set({
      'date': date,
      'image': '',
      'email': _email,
      'password': _password,
      'name': _name,
      'nickname': _nickname,
      'myclubs': [],
      'invitions': [],
      'uid': uid,
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
