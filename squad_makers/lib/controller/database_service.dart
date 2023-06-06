import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  static const int listlen = 11;
  static const formationlist = {
    '4-2-3-1': [
      {'x': 0.45, 'y': 0.05},
      {'x': 0.45, 'y': 0.5},
      {'x': 0.2, 'y': 0.15},
      {'x': 0.7, 'y': 0.15},
      {'x': 0.35, 'y': 0.3},
      {'x': 0.55, 'y': 0.3},
      {'x': 0.45, 'y': 0.15},
      {'x': 0.15, 'y': 0.37},
      {'x': 0.75, 'y': 0.37},
      {'x': 0.35, 'y': 0.42},
      {'x': 0.55, 'y': 0.42},
    ]
  };

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

  Future setClubData(String name, String image, String info) async {
    await clubCollection.doc(name).set({
      'date': DateTime.now(),
      'name': name,
      'image': image,
      'info': info,
      'clubmaster': uid,
      'clubuserlist': [uid],
      'clubuser': 1,
      'squadlist': [],
      'adminlist': [uid],
    });
  }

  Future<String?> setSquadData(String clubname, String squadname,
      String formation, List<dynamic> userlist) async {
    String docid = '';
    await squadCollection.add({
      'date': DateTime.now(),
      'squadname': squadname,
      'clubname': clubname,
      'tacticsinfo': '',
      'userlist': userlist,
      'subplayers': []
    }).then((DocumentReference squadDocument) async {
      docid = squadDocument.id;
      CollectionReference playersCollection =
          squadDocument.collection('players');
      for (int i = 0; i < listlen; i++) {
        await playersCollection.add({
          'userEmail': '',
          'xposition': formationlist[formation]?[i]['x'],
          'yposition': formationlist[formation]?[i]['y'],
          'number': '',
          'movement': '',
          'role': ''
        });
      }
    });
    if (docid != '') {
      return docid;
    } else {
      return null;
    }
  }
}
