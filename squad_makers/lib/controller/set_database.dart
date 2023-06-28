import 'package:cloud_firestore/cloud_firestore.dart';

class SetDatabase {
  final String uid;
  static const int listlen = 11;
  static const formationlist = {
    '4-2-3-1': [
      {'x': 0.45, 'y': 0.05},
      {'x': 0.45, 'y': 0.51},
      {'x': 0.2, 'y': 0.15},
      {'x': 0.7, 'y': 0.15},
      {'x': 0.35, 'y': 0.3},
      {'x': 0.55, 'y': 0.3},
      {'x': 0.45, 'y': 0.15},
      {'x': 0.15, 'y': 0.37},
      {'x': 0.75, 'y': 0.37},
      {'x': 0.35, 'y': 0.42},
      {'x': 0.55, 'y': 0.42},
    ],
    '4-2-2-2': [
      {'x': 0.35, 'y': 0.08},
      {'x': 0.55, 'y': 0.08},
      {'x': 0.35, 'y': 0.26},
      {'x': 0.55, 'y': 0.26},
      {'x': 0.15, 'y': 0.26},
      {'x': 0.75, 'y': 0.26},
      {'x': 0.15, 'y': 0.4},
      {'x': 0.75, 'y': 0.4},
      {'x': 0.35, 'y': 0.42},
      {'x': 0.55, 'y': 0.42},
      {'x': 0.45, 'y': 0.51},
    ],
  };

  String setPosition(double xPosition, double yPosition) {
    String position = '';
    if ((xPosition >= 0.23 && xPosition <= 0.65) &&
        (yPosition >= 0.38 && yPosition <= 0.52)) {
      position = 'CB';
    }
    if (((xPosition > 0.03 && xPosition < 0.23) &&
            (yPosition > 0.31 && yPosition < 0.52)) ||
        (xPosition > 0.65 && xPosition <= 0.85) &&
            (yPosition > 0.31 && yPosition <= 0.52)) {
      position = 'FB';
    }
    if ((xPosition >= 0.23 && xPosition <= 0.65) &&
        (yPosition >= 0.31 && yPosition <= 0.38)) {
      position = 'DM';
    }
    if ((xPosition >= 0.03 && xPosition <= 0.85) &&
        (yPosition >= 0.2 && yPosition <= 0.31)) {
      position = 'CM';
    }
    if ((xPosition >= 0.28 && xPosition <= 0.6) &&
        (yPosition >= 0.12 && yPosition <= 0.21)) {
      position = 'AM';
    }
    if (((xPosition > 0.03 && xPosition < 0.28) &&
            (yPosition >= 0.01 && yPosition < 0.2)) ||
        (xPosition > 0.6 && xPosition <= 0.85) &&
            (yPosition >= 0.01 && yPosition < 0.2)) {
      position = 'WF';
    }
    if ((xPosition >= 0.28 && xPosition <= 0.6) &&
        (yPosition >= 0.01 && yPosition < 0.12)) {
      position = 'CF';
    }
    if ((xPosition == 0.45 && xPosition == 0.51)) {
      position = 'GK';
    }
    return position;
  }

  SetDatabase({required this.uid});

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

  Map<String, dynamic> defaulttactics() {
    Map<String, dynamic> tacticsdata = {
      'name': '',
      'simpleInfo': '',
      'defenceline': '높게',
      'spacing': '넓게',
      'pressure': '강하게',
      'shotfrequency': '신중하게',
      'attackdirection': '중앙',
      'passdistance': '짧은 패스'
    };
    return tacticsdata;
  }

  Future<String?> setSquadData(String clubname, String squadname,
      String formation, List<dynamic> userlist) async {
    String docid = '';
    await squadCollection.add({
      'date': DateTime.now(),
      'squadname': squadname,
      'clubname': clubname,
      'tacticsinfo': defaulttactics(),
      'userlist': userlist,
      'subplayers': []
    }).then((DocumentReference squadDocument) async {
      docid = squadDocument.id;
      CollectionReference playersCollection =
          squadDocument.collection('players');
      for (int i = 0; i < listlen; i++) {
        double? xposition = formationlist[formation]?[i]['x'];
        double? yposition = formationlist[formation]?[i]['y'];
        String position = setPosition(xposition!, yposition!);
        await playersCollection.add({
          'userEmail': '',
          'xposition': xposition,
          'yposition': yposition,
          'number': 0,
          'movement': '없음',
          'role': '없음',
          'memo': '',
          'position': position
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
