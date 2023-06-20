import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squad_makers/view/club_view/club_creative.dart';
import 'package:squad_makers/view/club_view/my_clubPage.dart';
import 'package:squad_makers/view/main_view/myinfoPage.dart';
import 'package:squad_makers/view_model/app_view_model.dart';

mainBox(height, width, image, onTap) {
  return InkWell(
      onTap: onTap,
      child: Column(children: [
        Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              image:
                  DecorationImage(image: AssetImage(image), fit: BoxFit.cover),
            )),
        SizedBox(
          height: height * 0.03,
        ),
      ]));
}

class ClubMainPage extends StatefulWidget {
  const ClubMainPage({super.key});

  @override
  State<ClubMainPage> createState() => _ClubMainPageState();
}

class _ClubMainPageState extends State<ClubMainPage> {
  AppViewModel appdata = Get.find();

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.2,
          automaticallyImplyLeading: false,
          toolbarHeight: height * 0.08,
          backgroundColor: Color(0x805EA152),
          actions: [
            GestureDetector(
              //user 정보에서 user가 설정한 image로 변경하기
              child: Row(
                children: [
                  appdata.myInfo.image == ""
                      ? SizedBox(
                          width: width * 0.06,
                          height: height * 0.07,
                          child: CircleAvatar(
                              backgroundImage:
                                  const AssetImage('assets/basic.png')),
                        )
                      : SizedBox(
                          width: width * 0.07,
                          height: height * 0.07,
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
                    style:
                        TextStyle(fontSize: width * 0.04, color: Colors.black),
                  ),
                  SizedBox(
                    width: width * 0.03,
                  ),
                ],
              ),
              onTap: () {
                Get.to(() => MyInfoPage());
              },
            ),
          ],
          centerTitle: true,
          title: Text('Club',
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Garton',
                  fontSize: width * 0.08)),
        ),
        // drawer: Drawer(),
        body: SingleChildScrollView(
            child: SafeArea(
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: height * 0.08,
              ),
              mainBox(
                height * 0.25,
                width * 0.9,
                'assets/clubEdit.png',
                () => Get.to(() => ClubEditPage()),
              ),
              Text(
                '클럽 생성',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Simple',
                    fontSize: width * 0.04,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: height * 0.03,
              ),
              mainBox(height * 0.3, width * 0.6, 'assets/myClub.png',
                  () => Get.to(() => MyClubPage())),
              Text(
                '내 클럽',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Simple',
                    fontSize: width * 0.04,
                    fontWeight: FontWeight.bold),
              ),
            ],
          )),
        )));
  }
}
