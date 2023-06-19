import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:squad_makers/controller/database_controller.dart';
import 'package:squad_makers/view/position_info/infoPage.dart';
import 'package:squad_makers/view_model/app_view_model.dart';

import '../main_view/myinfo.dart';

sliderWidget(
    imageList, nameList, width, height, position, categoryName, argument) {
  return CarouselSlider.builder(
    options: CarouselOptions(
      enlargeCenterPage: true,
      height: height * 0.37,
      autoPlay: false,
    ),
    itemCount: imageList.length,
    itemBuilder: (context, i, id) {
      return GestureDetector(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Color(0xff5EA152),
                    )),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      imageList[i],
                      height: height * 0.3,
                      width: width * 0.7,
                      fit: BoxFit.cover,
                    )),
              ),
              Flexible(
                child: Text(
                  nameList[i],
                  style: TextStyle(
                      fontFamily: 'Garton',
                      fontSize: width * 0.03,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
          onTap: () async {
            await databasecontroller.positionInfoLoad(
                position, categoryName, nameList[i]);
            Get.to(() => InfoPage(), arguments: argument);
          });
    },
  );
}

class MidfielderInfoPage extends StatefulWidget {
  MidfielderInfoPage({Key? key}) : super(key: key);

  @override
  State<MidfielderInfoPage> createState() => _MidfielderInfoPageState();
}

class _MidfielderInfoPageState extends State<MidfielderInfoPage> {
  final _AM = ['Attacking Midfielder', 'Advanced PlayMaker', 'Trequartista'];
  final _CM = [
    'Central Midfielder',
    'Mezzala',
    'Boxtobox',
    'RoamingPlaymaker',
    'BallWinning',
    'Wide Midfielder'
  ];

  final _DM = [
    'Defensive Midfielder',
    'Deep Lying PlayMaker',
    'Regista',
    'Anchor',
    'Half Back'
  ];

  List<String> imageList_AM = [
    'assets/midfielder/AM/AM.jpg',
    'assets/midfielder/AM/ADP.jpg',
    'assets/midfielder/AM/Trequa.jpg'
  ];
  List<String> imageList_CM = [
    'assets/midfielder/CM/CM.jpg',
    'assets/midfielder/CM/Mezzala.jpg',
    'assets/midfielder/CM/BoxtoBox.jpg',
    'assets/midfielder/CM/Roaming.jpg',
    'assets/midfielder/CM/BallWinning.jpg',
    'assets/midfielder/CM/WideMid.jpg'
  ];
  List<String> imageList_DM = [
    'assets/midfielder/DM/DM.jpg',
    'assets/midfielder/DM/DLP.jpg',
    'assets/midfielder/DM/Regista.jpg',
    'assets/midfielder/DM/Anchor.jpg',
    'assets/midfielder/DM/HalfBack.jpg'
  ];

  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    AppViewModel appdata = Get.find();
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
                        width: width * 0.07,
                        height: height * 0.08,
                        child: CircleAvatar(
                            backgroundImage:
                                const AssetImage('assets/basic.png')),
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
                  style: TextStyle(fontSize: width * 0.04, color: Colors.black),
                ),
              ],
            ),
            onTap: () {
              Get.to(() => MyInfoPage());
            },
          ),
        ],
        centerTitle: true,
        title: Text('Midfielder Info',
            style: TextStyle(
                color: Colors.black,
                fontFamily: 'Garton',
                fontSize: width * 0.08)),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
            child: Center(
          child: Column(
            children: [
              SizedBox(
                height: height * 0.05,
              ),
              CarouselSlider.builder(
                  itemCount: imageList_AM.length,
                  itemBuilder: (context, i, id) {
                    return GestureDetector(
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: Color(0xff5EA152),
                                )),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.asset(
                                  imageList_AM[i],
                                  height: height * 0.3,
                                  width: width * 0.7,
                                  fit: BoxFit.cover,
                                )),
                          ),
                          Flexible(
                            child: Text(
                              _AM[i],
                              style: TextStyle(
                                  fontFamily: 'Garton',
                                  fontSize: width * 0.03,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      onTap: () async {
                        await databasecontroller.positionInfoLoad(
                            'Midfielder', 'AM', _AM[i]);
                        Get.to(() => InfoPage(),
                            arguments: 'Attacking Midfielder');
                      },
                    );
                  },
                  options: CarouselOptions(
                      height: height * 0.37,
                      enlargeCenterPage: true,
                      autoPlay: false)),
              SizedBox(
                height: height * 0.02,
              ),
              sliderWidget(imageList_CM, _CM, width, height, 'Midfielder', 'CM',
                  'Central Midfielder'),
              SizedBox(
                height: height * 0.02,
              ),
              sliderWidget(imageList_DM, _DM, width, height, 'Midfielder', 'DM',
                  'Defensive Midfielder'),
            ],
          ),
        )),
      ),
    );
  }
}
