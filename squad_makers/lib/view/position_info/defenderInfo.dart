import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:squad_makers/controller/database_controller.dart';
import 'package:squad_makers/view_model/app_view_model.dart';
import 'package:squad_makers/view/position_info/infoPage.dart';

import '../main_view/myinfoPage.dart';

sliderWidget(
    imageList, nameList, width, height, position, categoryName, argument) {
  return CarouselSlider.builder(
    options: CarouselOptions(
      enlargeCenterPage: true,
      height: height * 0.32,
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
                      height: height * 0.25,
                      width: width * 0.65,
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

class DefenderInfoPage extends StatefulWidget {
  DefenderInfoPage({Key? key}) : super(key: key);

  @override
  State<DefenderInfoPage> createState() => _DefenderInfoPageState();
}

class _DefenderInfoPageState extends State<DefenderInfoPage> {
  final _CD = [
    'Central Defender',
    'Libero',
    'BallPlaying Defender',
    'No-Nonsense Centre-Back'
  ];
  final _SD = [
    'Wing Back',
    'Full Back',
    'No-Nonsense Full-Back',
    'Complete Wing-Back',
    'Inverted Wing-Back'
  ];

  List<String> imageList_CD = [
    'assets/Defender/CD/kim.jpg',
    'assets/Defender/CD/franz.jpg',
    'assets/Defender/CD/BPD.jpg',
    'assets/Defender/CD/NCB.jpg'
  ];
  List<String> imageList_SD = [
    'assets/Defender/SD/WB.jpg',
    'assets/Defender/SD/FB.jpg',
    'assets/Defender/SD/NFB.jpg',
    'assets/Defender/SD/CWB.jpg',
    'assets/Defender/SD/IWB.jpg'
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
        elevation: 1,
        automaticallyImplyLeading: false,
        toolbarHeight: height * 0.08,
        backgroundColor: Colors.white,
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
        title: Text('Defender Info',
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
                height: height * 0.07,
              ),
              CarouselSlider.builder(
                  itemCount: imageList_CD.length,
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
                                  imageList_CD[i],
                                  height: height * 0.25,
                                  width: width * 0.65,
                                  fit: BoxFit.cover,
                                )),
                          ),
                          Flexible(
                            child: Text(
                              _CD[i],
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
                            'Defender', 'CD', _CD[i]);
                        Get.to(() => InfoPage(), arguments: 'Central Defender');
                      },
                    );
                  },
                  options: CarouselOptions(
                      height: height * 0.32,
                      enlargeCenterPage: true,
                      autoPlay: false)),
              SizedBox(
                height: height * 0.02,
              ),
              sliderWidget(imageList_SD, _SD, width, height, 'Defender', 'SD',
                  'Side Defender'),
              SizedBox(
                height: height * 0.02,
              ),
            ],
          ),
        )),
      ),
    );
  }
}
