import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;

  DatabaseService({required this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference clubCollection =
      FirebaseFirestore.instance.collection('clubs');
  final CollectionReference squadCollection =
      FirebaseFirestore.instance.collection('squads');

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

  Future setClubData(String name, String image, String info) async {
    await clubCollection.doc(name).set({
      'date': DateTime.now(),
      'name': name,
      'image': image,
      'info': info,
      'clubmaster': uid,
      'clubuserlist': [uid],
      'clubuser': 1,
      'squadlist': []
    });
  }

  Future setSquadData(
      String clubname, String squadname, List<String> userlist) async {
    await squadCollection.doc().set({
      'date': DateTime.now(),
      'squadname': squadname,
      'clubname': clubname,
      'tacticsinfo': '',
      'userlist': userlist,
      'subplayers': []
    });
  }
}
