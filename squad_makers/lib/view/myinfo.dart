import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:squad_makers/controller/Auth_controller.dart';

import '../view_model/app_view_model.dart';

class MyInfoPage extends StatefulWidget {
  const MyInfoPage({super.key});

  @override
  State<MyInfoPage> createState() => _MyInfoPageState();
}

class _MyInfoPageState extends State<MyInfoPage> {
  static final storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      authController.checkUserState(storage);
    });
  }

  AppViewModel appdata = Get.find();
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(children: [
        SizedBox(
          height: height * 0.1,
        ),
        Container(
            width: width,
            height: height * 0.1,
            color: Colors.blue,
            child: appdata.myInfo.name.isEmpty
                ? Text('없음')
                : Text(appdata.myInfo.name)),
        TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Color(0x805EA152),
            ),
            onPressed: () => {authController.logout(storage)},
            child: Text(
              '로그아웃',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: width * 0.04,
                  fontFamily: 'Garton',
                  fontWeight: FontWeight.bold),
            ))
      ]),
    );
  }
}
