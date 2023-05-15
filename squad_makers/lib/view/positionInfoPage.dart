import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'position_info/forwordInfo.dart';
import 'position_info/midfielderInfo.dart';
import 'position_info/defenderInfo.dart';

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

class PositionInfoPage extends StatelessWidget {
  const PositionInfoPage({super.key});

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
