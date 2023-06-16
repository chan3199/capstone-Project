import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:squad_makers/controller/user_controller.dart';
import 'package:squad_makers/model/moveableitem_model.dart';
import 'package:squad_makers/model/myinfo.dart';
import 'package:squad_makers/model/squadApp_model.dart';
import '../model/club_model.dart';
import '../view_model/app_view_model.dart';

ClubController clubController = ClubController();

class ClubController {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference clubCollection =
      FirebaseFirestore.instance.collection('clubs');
  final CollectionReference squadCollection =
      FirebaseFirestore.instance.collection('squads');

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

  Future<void> addclubs(String uid, List<dynamic> myclubs) async {
    await userCollection.doc(uid).update({'myclubs': myclubs});
  }

  Future<List<dynamic>> getclublist(List<dynamic> clublist) async {
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

  Future<void> joinclub(String uid, List<dynamic> clublist) async {
    await userCollection.doc(uid).update({'myclubs': clublist});
  }

  Future<void> addAdmin(String clubname, String uid) async {
    QuerySnapshot querySnapshot =
        await clubCollection.where('name', isEqualTo: clubname).get();
    if (querySnapshot.docs.isEmpty) {
      print('오류');
    } else {
      ClubModel clubModel = ClubModel.fromJson(
          querySnapshot.docs.first.data() as Map<String, dynamic>);
      clubModel.adminlist.add(uid);
      await clubCollection
          .doc(clubname)
          .update({'adminlist': clubModel.adminlist});
    }
  }

  Future<void> removeAdmin(String clubname, String uid) async {
    QuerySnapshot querySnapshot =
        await clubCollection.where('name', isEqualTo: clubname).get();
    if (querySnapshot.docs.isEmpty) {
      print('오류');
    } else {
      ClubModel clubModel = ClubModel.fromJson(
          querySnapshot.docs.first.data() as Map<String, dynamic>);
      clubModel.adminlist.remove(uid);
      await clubCollection
          .doc(clubname)
          .update({'adminlist': clubModel.adminlist});
    }
  }

  Future addclubuser(String clubname, String uid) async {
    QuerySnapshot querySnapshot =
        await clubCollection.where('name', isEqualTo: clubname).get();

    if (querySnapshot.docs.isEmpty) {
      print('오류');
    } else {
      ClubModel clubModel = ClubModel.fromJson(
          querySnapshot.docs.first.data() as Map<String, dynamic>);
      clubModel.clubuserlist.add(uid);
      await clubCollection.doc(clubname).update({
        'clubuser': clubModel.clubuser + 1,
        'clubuserlist': clubModel.clubuserlist
      });
    }
  }

  Future<void> clubDelete(ClubModel clubmodel) async {
    for (String user in clubmodel.clubuserlist) {
      MyInfo? usermodel = await userController.getuserdataTouid(user);
      usermodel!.myclubs.remove(clubmodel.name);
      await userCollection.doc(user).update({'myclubs': usermodel.myclubs});
    }
    await clubCollection.doc(clubmodel.name).delete();
    if (clubmodel.squadlist.isNotEmpty) {
      for (String squad in clubmodel.squadlist) {
        CollectionReference cr =
            squadCollection.doc(squad).collection('players');
        cr.get().then((querySnapshot) {
          querySnapshot.docs.forEach((element) {
            element.reference.delete();
          });
        });
        await squadCollection.doc(squad).delete();
      }
    }
  }

  Future<void> clubExit(String uid, ClubModel clubmodel) async {
    MyInfo? usermodel = await userController.getuserdataTouid(uid);
    usermodel!.myclubs.remove(clubmodel.name);
    await userCollection.doc(uid).update({'myclubs': usermodel.myclubs});
    if (clubmodel.squadlist.isNotEmpty) {
      for (String squad in clubmodel.squadlist) {
        DocumentSnapshot documentsnapshot =
            await squadCollection.doc(squad).get();
        SquadAppModel squadmodel = SquadAppModel.fromJson(
            documentsnapshot.data() as Map<String, dynamic>);
        if (squadmodel.userlist.contains(uid)) {
          squadmodel.userlist.remove(uid);
        }
        if (squadmodel.subplayers.contains(uid)) {
          squadmodel.subplayers.remove(uid);
        }
        CollectionReference cr =
            squadCollection.doc(squad).collection('players');
        cr.get().then((querySnapshot) {
          querySnapshot.docs.forEach((element) async {
            MoveableItem moveableitem =
                MoveableItem.fromJson(element.data() as Map<String, dynamic>);
            if (usermodel.email == moveableitem.userEmail) {
              await element.reference.update(
                  {'movement': '', 'number': 0, 'role': '', 'userEmail': ''});
            }
          });
        });
        await squadCollection.doc(squad).delete();
      }
    }
    clubmodel.clubuserlist.remove(uid);
    clubmodel.clubuser -= 1;
    await clubCollection.doc(clubmodel.name).update({
      'clubuserlist': clubmodel.clubuserlist,
      'clubuser': clubmodel.clubuser
    });
  }
}