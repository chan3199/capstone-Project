import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squad_makers/model/position_model.dart';

class CFInfoPage extends StatefulWidget {
  CFInfoPage({Key? key}) : super(key: key);

  @override
  State<CFInfoPage> createState() => _CFInfoPageState();
}

class _CFInfoPageState extends State<CFInfoPage> {
  late String category;

  @override
  Widget build(BuildContext context) {
    category = Get.arguments;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.2,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.black,
            ),
            onPressed: () {},
          ),
          toolbarHeight: height * 0.08,
          backgroundColor: Color(0x805EA152),
          actions: [
            Row(
              children: [
                TextButton.icon(
                  //user 정보에서 user가 설정한 image로 변경하기
                  icon: Icon(
                    size: width * 0.05,
                    Icons.circle,
                    color: Colors.black,
                  ),
                  label: Text(
                    'username', // username 또한 user 정보에서 불러와서 넣기
                    style: TextStyle(
                        fontFamily: 'Garton',
                        fontSize: width * 0.04,
                        color: Colors.black),
                  ),
                  onPressed: () {},
                ),
                SizedBox(
                  width: width * 0.03,
                )
              ],
            ),
            // SizedBox(
            //   width: width * 0.03,
            // )
          ],
          centerTitle: true,
          title: Text('CenterForword Info',
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Garton',
                  fontSize: width * 0.07)),
        ),
        body: SingleChildScrollView(
          child: Center(
              child: Column(
            children: [Text(category), Text('')],
          )),
        ));
  }
}
