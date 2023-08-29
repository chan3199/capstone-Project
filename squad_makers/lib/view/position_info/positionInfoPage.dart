import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squad_makers/view/main_view/myinfoPage.dart';
import 'package:squad_makers/view_model/app_view_model.dart';
import 'forwordInfo.dart';
import 'midfielderInfo.dart';
import 'defenderInfo.dart';

positionBox(height, width, image, text, onTap) {
  return InkWell(
      onTap: onTap,
      child: Column(children: [
        Container(
            width: width * 0.7,
            height: height * 0.2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(image: AssetImage(image)),
              border: Border.all(color: const Color(0xff5EA152)),
            )),
        SizedBox(
          height: height * 0.01,
        ),
        Text(
          text,
          style: TextStyle(
              fontFamily: 'Garton',
              fontSize: width * 0.04,
              fontWeight: FontWeight.bold),
        )
      ]));
}

class PositionInfoPage extends StatelessWidget {
  const PositionInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    AppViewModel appdata = Get.find();
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1,
        automaticallyImplyLeading: false,
        toolbarHeight: height * 0.08,
        backgroundColor: Colors.white,
        actions: [
          Row(
            children: [
              GestureDetector(
                //user 정보에서 user가 설정한 image로 변경하기
                child: Row(
                  children: [
                    appdata.myInfo.image == ""
                        ? SizedBox(
                            width: width * 0.07,
                            height: height * 0.08,
                            child: const CircleAvatar(
                                backgroundImage:
                                    AssetImage('assets/basic.png')),
                          )
                        : SizedBox(
                            width: width * 0.08,
                            height: height * 0.08,
                            child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 30,
                                backgroundImage:
                                    NetworkImage(appdata.myInfo.image)),
                          ),
                    SizedBox(
                      width: width * 0.02,
                    ),
                    Text(
                      appdata.myInfo.name, // username 또한 user 정보에서 불러와서 넣기
                      style: TextStyle(
                          fontSize: width * 0.04, color: Colors.black),
                    ),
                  ],
                ),
                onTap: () {
                  Get.to(() => const MyInfoPage());
                },
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
        title: Text('Position Info',
            style: TextStyle(
                color: Colors.black,
                fontFamily: 'Garton',
                fontSize: width * 0.08)),
      ),
      body: SingleChildScrollView(
          child: SafeArea(
              child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          SizedBox(
            height: height * 0.07,
          ),
          positionBox(height, width, 'assets/squad1.png', 'Forward',
              () => Get.to(() => ForwordInfoPage())),
          positionBox(height, width, 'assets/squad1.png', 'Midfielder',
              () => Get.to(() => MidfielderInfoPage())),
          positionBox(height, width, 'assets/squad1.png', 'Defender',
              () => Get.to(() => DefenderInfoPage()))
        ]),
      ))),
    );
  }
}
