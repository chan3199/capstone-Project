import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:squad_makers/controller/database_controller.dart';
import 'package:squad_makers/view/position_info/infoPage.dart';
import 'package:squad_makers/view_model/app_view_model.dart';

import '../myinfo.dart';

sliderWidget(
    imageList, nameList, width, height, position, categoryName, argument) {
  return CarouselSlider.builder(
    options: CarouselOptions(
      enlargeCenterPage: true,
      height: height * 0.4,
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
              Text(
                nameList[i],
                style: TextStyle(
                    fontFamily: 'Garton',
                    fontSize: width * 0.04,
                    fontWeight: FontWeight.bold),
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

class ForwordInfoPage extends StatefulWidget {
  ForwordInfoPage({Key? key}) : super(key: key);

  @override
  State<ForwordInfoPage> createState() => _ForwordInfoPageState();
}

class _ForwordInfoPageState extends State<ForwordInfoPage> {
  final _CF = [
    'Target',
    'Poacher',
    'Deep lying Forward',
    'Shadow Striker',
    'Pressing Forward',
    'Complete Forward',
    'Advanced Forward',
    'False Nine'
  ];
  final _WF = [
    'Winger',
    'Inverted Winger',
    'Defensive Winger',
    'Inside Forward'
  ];
  List<String> imageList_CF = [
    'assets/forward/CF/giroud.jpg',
    'assets/forward/CF/ronaldo.jpg',
    'assets/forward/CF/DLP.jpg',
    'assets/forward/CF/SS.jpg',
    'assets/forward/CF/PF.jpg',
    'assets/forward/CF/CF.jpg',
    'assets/forward/CF/AF.jpg',
    'assets/forward/CF/F9.jpg'
  ];
  List<String> imageList_WF = [
    'assets/forward/WF/W.jpg',
    'assets/forward/WF/IW.jpg',
    'assets/forward/WF/DW.jpg',
    'assets/forward/WF/IF.jpg'
  ];

  final CarouselController _controller = CarouselController();

  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    AppViewModel appdata = Get.find();
    int _index = 0;
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
                  style: TextStyle(
                      fontFamily: 'Garton',
                      fontSize: width * 0.04,
                      color: Colors.black),
                ),
              ],
            ),
            onTap: () {
              Get.to(() => MyInfoPage());
            },
          ),
        ],
        centerTitle: true,
        title: Text('Forward Info',
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
                  itemCount: imageList_CF.length,
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
                                  imageList_CF[i],
                                  height: height * 0.3,
                                  width: width * 0.7,
                                  fit: BoxFit.cover,
                                )),
                          ),
                          Text(
                            _CF[i],
                            style: TextStyle(
                                fontFamily: 'Garton',
                                fontSize: width * 0.04,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      onTap: () async {
                        await databasecontroller.positionInfoLoad(
                            'Forward', 'CF', _CF[i]);
                        Get.to(() => InfoPage(), arguments: 'CenterForward');
                      },
                    );
                  },
                  options: CarouselOptions(
                      enlargeCenterPage: true,
                      height: height * 0.4,
                      autoPlay: false)),
              SizedBox(
                height: height * 0.03,
              ),
              sliderWidget(imageList_WF, _WF, width, height, 'Forward', 'WF',
                  'Wing Forward'),
            ],
          ),
        )),
      ),
    );
  }
}
