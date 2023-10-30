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
          elevation: 1,
          automaticallyImplyLeading: false,
          toolbarHeight: height * 0.08,
          backgroundColor: Colors.white,
          actions: [
            GestureDetector(
              child: Row(
                children: [
                  appdata.myInfo.image == ""
                      ? SizedBox(
                          width: width * 0.05,
                          height: height * 0.06,
                          child: const CircleAvatar(
                              backgroundImage: AssetImage('assets/basic.png')),
                        )
                      : SizedBox(
                          width: width * 0.05,
                          height: height * 0.06,
                          child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 30,
                              backgroundImage:
                                  NetworkImage(appdata.myInfo.image)),
                        ),
                  SizedBox(
                    width: width * 0.01,
                  ),
                  Text(
                    appdata.myInfo.name,
                    style:
                        TextStyle(fontSize: width * 0.03, color: Colors.black),
                  ),
                  SizedBox(
                    width: width * 0.03,
                  ),
                ],
              ),
              onTap: () {
                Get.to(() => const MyInfoPage());
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
                height * 0.3,
                width * 0.6,
                'assets/myClub.png',
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
              mainBox(height * 0.3, width * 0.7, 'assets/clubEdit.png',
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
