import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:squad_makers/controller/set_database.dart';
import 'package:squad_makers/model/moveableitem_model.dart';
import 'package:squad_makers/model/squadApp_model.dart';
import 'package:squad_makers/model/squad_model.dart';
import '../view_model/app_view_model.dart';

SquadController squadController = SquadController();

class SquadController {
  final CollectionReference squadCollection =
      FirebaseFirestore.instance.collection('squads');
  final CollectionReference clubCollection =
      FirebaseFirestore.instance.collection('clubs');

  AppViewModel appdata = Get.find();

  Future<String?> createSquad(String clubname, String squadname,
      String formation, List<dynamic> userlist) async {
    String? docid = await SetDatabase(uid: '')
        .setSquadData(clubname, squadname, formation, userlist);
    return docid;
  }

  Future<void> addSquad(String? clubname, List<dynamic> squadlist) async {
    print(squadlist);
    await clubCollection.doc(clubname).update({'squadlist': squadlist});
  }

  Future<List<dynamic>?> getSquadlist(List<dynamic> squadlist) async {
    List<dynamic> resultlist = [];
    if (squadlist != [] || squadlist.isNotEmpty) {
      for (var squad in squadlist) {
        DocumentSnapshot docuSnapshot = await squadCollection.doc(squad).get();
        if (docuSnapshot.data() != null) {
          SquadModel squadmodel =
              SquadModel.fromJson(docuSnapshot.data() as Map<String, dynamic>);
          resultlist.add(squadmodel);
        }
      }
      return resultlist;
    } else {
      return null;
    }
  }

  Future<void> getsquadinfo(String clubname, String squadname) async {
    List<dynamic> MsiList = [];
    AppViewModel appdata = Get.find();
    QuerySnapshot querySnapshot = await squadCollection
        .where('clubname', isEqualTo: clubname)
        .where('squadname', isEqualTo: squadname)
        .get();

    QuerySnapshot playerSnapshot =
        await querySnapshot.docs.first.reference.collection('players').get();

    for (QueryDocumentSnapshot item in playerSnapshot.docs) {
      MoveableItem msiModel =
          MoveableItem.fromJson(item.data() as Map<String, dynamic>);
      MsiList.add(msiModel);
    }
    Map<String, dynamic> temp =
        querySnapshot.docs.first.data() as Map<String, dynamic>;
    temp['playerlist'] = MsiList;

    appdata.squadmodel = SquadAppModel.fromJson(temp);
  }

  Future<void> fetchsquad(
      SquadAppModel squadmodel, var width, var height) async {
    QuerySnapshot query = await squadCollection
        .where('clubname', isEqualTo: squadmodel.clubname)
        .where('squadname', isEqualTo: squadmodel.squadname)
        .get();

    DocumentReference documentReference = query.docs.first.reference;

    documentReference.update({
      'subplayers': squadmodel.subplayers,
      'userlist': squadmodel.userlist,
      'tacticsinfo': squadmodel.tacticsinfo
    });

    QuerySnapshot querySnapshot =
        await documentReference.collection('players').get();

    int i = 0;
    for (var item in querySnapshot.docs) {
      MoveableItem moveableitem = appdata.squadmodel.playerlist[i];
      await item.reference.update({
        'userEmail': moveableitem.userEmail,
        'xposition': moveableitem.xPosition,
        'yposition': moveableitem.yPosition,
        'number': moveableitem.number,
        'movement': moveableitem.movement,
        'role': moveableitem.role,
        'memo': moveableitem.memo,
        'position': moveableitem.position,
      });
      i += 1;
    }
  }

  Future<String> getSquadDocid(String clubname, String sqaudname) async {
    String docid = '';
    QuerySnapshot querySnapshot = await squadCollection
        .where('clubname', isEqualTo: clubname)
        .where('squadname', isEqualTo: sqaudname)
        .get();
    docid = querySnapshot.docs.first.id;
    return docid;
  }

  Future<List<dynamic>?> squadDelete(
      String clubname, String squadname, List<dynamic> squadlist) async {
    String docid = await getSquadDocid(clubname, squadname);
    List<dynamic> temp =
        squadlist.where((element) => element != docid).toList();
    await clubCollection.doc(clubname).update({'squadlist': temp});
    CollectionReference cr = squadCollection.doc(docid).collection('players');
    cr.get().then((querySnapshot) {
      querySnapshot.docs.forEach((element) {
        element.reference.delete();
      });
    });
    await squadCollection.doc(docid).delete();
    return temp;
  }
}
