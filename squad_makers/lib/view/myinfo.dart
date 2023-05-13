import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../view_model/app_view_model.dart';

class MyInfoPage extends StatefulWidget {
  const MyInfoPage({super.key});

  @override
  State<MyInfoPage> createState() => _MyInfoPageState();
}

class _MyInfoPageState extends State<MyInfoPage> {
  AppViewModel appdata = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        SizedBox(
          height: 50,
        ),
        Container(
            width: 150,
            height: 50,
            color: Colors.blue,
            child: appdata.myInfo.name.isEmpty
                ? Text('없음')
                : Text(appdata.myInfo.name))
      ]),
    );
  }
}
