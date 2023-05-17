import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:squad_makers/controller/database_controller.dart';
import 'package:squad_makers/view/position_info/infoPage.dart';

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
  final _AM = ['AM', 'Advanced PlayMaker', 'Trequartista'];
  final _CM = [
    'CM',
    'Mezzala',
    'Boxtobox',
    'RoamingPlaymaker',
    'BallWinning',
    'Wide Midfielder'
  ];

  final _DM = ['DM', 'Deep Lying PlayMaker', 'Regista', 'Anchor', 'Half Back'];

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

  String? _selectedAF;
  String? _selectedCS;
  String? _selectedDF;

  final CarouselController _controller = CarouselController();

  @override
  void initState() {
    super.initState();
    setState(() {});
  }

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
