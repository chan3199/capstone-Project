import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:squad_makers/utils/toast_massage.dart';
import 'package:squad_makers/model/invition_model.dart';
import 'package:squad_makers/model/user_model.dart';

InvitionsController invitionsController = InvitionsController();

class InvitionsController {
  final CollectionReference inviCollection =
      FirebaseFirestore.instance.collection('invitions');
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
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

  Future<void> deleteinvition(String docid) async {
    inviCollection.doc(docid).delete();
  }
}
