import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;

  DatabaseService({required this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
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
      'uid': uid,
    });
  }
}
