import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squad_makers/view/positionInfoPage.dart';

import 'squadMainPage.dart';

mainBox(height, width, image, text, onTap) {
  return InkWell(
      onTap: onTap,
      child: Column(children: [
        Container(
            width: width * 0.7,
            height: height * 0.3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(image: AssetImage(image)),
              border: Border.all(color: Color(0xff5EA152)),
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

class SquadPage extends StatelessWidget {
  const SquadPage({super.key});

  @override
  Widget build(BuildContext context) {
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
          title: Text('SquadMakers',
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
                height,
                width,
                'assets/player1.png',
                'Position Info',
                () => Get.to(() => PositionInfoPage()),
              ),
              SizedBox(
                height: height * 0.03,
              ),
              mainBox(height, width, 'assets/squad1.png', 'Squad Maker',
                  () => Get.to(() => SquadMainPage()))
            ],
          )),
        )));
  }
}
