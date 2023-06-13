import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:squad_makers/classes/toast_massage.dart';
import 'package:squad_makers/controller/database_service.dart';
import 'package:squad_makers/model/invition_model.dart';
import 'package:squad_makers/model/moveableitem_model.dart';
import 'package:squad_makers/model/myinfo.dart';
import 'package:squad_makers/model/position_model.dart';
import 'package:squad_makers/model/squadApp_model.dart';
import 'package:squad_makers/model/squad_model.dart';
import '../model/club_model.dart';
import '../utils/hash_password.dart';
import '../view_model/app_view_model.dart';

Databasecontroller databasecontroller = Databasecontroller();

class Databasecontroller {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference inviCollection =
      FirebaseFirestore.instance.collection('invitions');
  final CollectionReference clubCollection =
      FirebaseFirestore.instance.collection('clubs');
  final CollectionReference squadCollection =
      FirebaseFirestore.instance.collection('squads');

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

  void updataMyPassword(String uid, String password) {
    DocumentReference users =
        FirebaseFirestore.instance.collection('users').doc(uid);
    users
        .update({'password': password})
        .then((value) => print("User password Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  void updataMyName(String uid, String name) {
    DocumentReference users =
        FirebaseFirestore.instance.collection('users').doc(uid);
    users
        .update({'name': name})
        .then((value) => print("User name Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  void updataMynickname(String uid, String nickname) {
    DocumentReference users =
        FirebaseFirestore.instance.collection('users').doc(uid);
    users
        .update({'nickname': nickname})
        .then((value) => print("User nickname Updated"))
        .catchError((error) => print("Failed to update user: $error"));
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

  Future<String?> getdocidtouser(String user) async {
    QuerySnapshot querySnapshot =
        await userCollection.where('email', isEqualTo: user).get();
    if (querySnapshot.docs.isEmpty) {
      return null;
    } else {
      MyInfo usermodel = MyInfo.fromJson(
          querySnapshot.docs.first.data() as Map<String, dynamic>);
      return usermodel.uid;
    }
  }

  Future<MyInfo?> getuserdataToemail(String useremail) async {
    QuerySnapshot querySnapshot =
        await userCollection.where('email', isEqualTo: useremail).get();

    if (querySnapshot.docs.isEmpty) {
      return null;
    } else {
      MyInfo usermodel = MyInfo.fromJson(
          querySnapshot.docs.first.data() as Map<String, dynamic>);
      return usermodel;
    }
  }

  Future<MyInfo?> getuserdataTouid(String uid) async {
    QuerySnapshot querySnapshot =
        await userCollection.where('uid', isEqualTo: uid).get();

    if (querySnapshot.docs.isEmpty) {
      return null;
    } else {
      MyInfo usermodel = MyInfo.fromJson(
          querySnapshot.docs.first.data() as Map<String, dynamic>);
      return usermodel;
    }
  }

  Future<String?> setInvition(
      String user, String clubname, String image) async {
    String docid = '';
    await inviCollection.add({
      'user': user,
      'clubname': clubname,
      'image': image,
    }).then((DocumentReference documentRef) {
      docid = documentRef.id;
    });
    if (docid != '') {
      return docid;
    } else {
      return null;
    }
  }

  Future<List<dynamic>?> getinvitions(String user) async {
    QuerySnapshot querySnapshot =
        await userCollection.where('email', isEqualTo: user).get();
    if (querySnapshot.docs.isEmpty) {
      return null;
    } else {
      MyInfo usermodel = MyInfo.fromJson(
          querySnapshot.docs.first.data() as Map<String, dynamic>);
      return usermodel.invitions;
    }
  }

  Future<void> addinvition(String user, String clubname, String image) async {
    String? docid = await getdocidtouser(user);
    if (docid != null) {
      List<dynamic>? invitions = await getinvitions(user);
      String? invidocid = await setInvition(user, clubname, image);
      invitions?.add(invidocid);
      await userCollection.doc(docid).update({'invitions': invitions});
    } else {
      toastMessage('존재하지 않는 이름입니다.');
    }
  }

  Future<List<dynamic>?> getinvitionlist(List<dynamic> invitionlist) async {
    List<dynamic> resultclublist = [];
    for (var element in invitionlist) {
      await inviCollection
          .doc(element)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          InvitionModel invimodel = InvitionModel.fromJson(
              documentSnapshot.data() as Map<String, dynamic>);
          resultclublist.add(invimodel);
        }
      });
    }
    return resultclublist;
  }

  Future<String> getdocIdtoinvition(String clubname, String user) async {
    String? docid;
    await inviCollection
        .where('clubname', isEqualTo: clubname)
        .where('user', isEqualTo: user)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((DocumentSnapshot docSnapshot) {
        docid = docSnapshot.id;
      });
    });
    return docid!;
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
      clubCollection.doc(clubname).update({'adminlist': clubModel.adminlist});
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
      clubCollection.doc(clubname).update({'adminlist': clubModel.adminlist});
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
      clubCollection.doc(clubname).update({
        'clubuser': clubModel.clubuser + 1,
        'clubuserlist': clubModel.clubuserlist
      });
    }
  }

  Future<void> deleteinvition(String docid) async {
    inviCollection.doc(docid).delete();
  }

  Future<String?> createSquad(String clubname, String squadname,
      String formation, List<dynamic> userlist) async {
    String? docid = await DatabaseService(uid: '')
        .setSquadData(clubname, squadname, formation, userlist);
    return docid;
  }

  Future<void> addSquad(String? clubname, List<dynamic> squadlist) async {
    await clubCollection.doc(clubname).update({'squadlist': squadlist});
  }

  Future<List<dynamic>?> getSquadlist(List<dynamic> squadlist) async {
    List<dynamic> resultlist = [];
    if (squadlist == []) {
      return null;
    } else {
      for (var squad in squadlist) {
        DocumentSnapshot docuSnapshot = await squadCollection.doc(squad).get();
        SquadModel squadmodel =
            SquadModel.fromJson(docuSnapshot.data() as Map<String, dynamic>);
        resultlist.add(squadmodel);
      }
      return resultlist;
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
    appdata.squadTemp = appdata.squadmodel;
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
        'role': moveableitem.role
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

  Future<void> squadDelete(
      String clubname, String squadname, List squadlist) async {
    String docid = await getSquadDocid(clubname, squadname);
    await clubCollection.doc(clubname).update({'squadlist': squadlist});
    CollectionReference cr = squadCollection.doc(docid).collection('players');
    cr.get().then((querySnapshot) {
      querySnapshot.docs.forEach((element) {
        element.reference.delete();
      });
    });
    await squadCollection.doc(docid).delete();
  }

  Future<void> clubDelete(ClubModel clubmodel) async {
    for (String user in clubmodel.clubuserlist) {
      MyInfo? usermodel = await getuserdataTouid(user);
      usermodel!.myclubs.remove(clubmodel.name);
      userCollection.doc(user).update({'myclubs': usermodel.myclubs});
    }
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
    await clubCollection.doc(clubmodel.name).delete();
  }

  Future<void> clubExit(String uid, ClubModel clubmodel) async {
    MyInfo? usermodel = await getuserdataTouid(uid);
    usermodel!.myclubs.remove(clubmodel.name);
    userCollection.doc(uid).update({'myclubs': usermodel.myclubs});
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
          querySnapshot.docs.forEach((element) {
            MoveableItem moveableitem =
                MoveableItem.fromJson(element.data() as Map<String, dynamic>);
            if (usermodel.email == moveableitem.userEmail) {
              element.reference.update(
                  {'movement': '', 'number': 0, 'role': '', 'userEmail': ''});
            }
          });
        });
        await squadCollection.doc(squad).delete();
      }
    }
    clubmodel.clubuserlist.remove(uid);
    clubmodel.clubuser -= 1;
    clubCollection.doc(clubmodel.name).update({
      'clubuserlist': clubmodel.clubuserlist,
      'clubuser': clubmodel.clubuser
    });
  }
}
