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
  final _CF = ['Target', 'Poacher'];
  final _WF = ['Classic', 'Inverted'];
  List<String> imageList_CF = [
    'assets/forword/CF/giroud.jpg',
    'assets/forword/CF/ronaldo.jpg'
  ];

  String? _selectedCF;
  String? _selectedSS;
  String? _selectedWF;

  final CarouselController _controller = CarouselController();

  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    int _index = 0;
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
        title: Text('Forword Info',
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
                            'Forword', 'CF', _CF[i]);
                        Get.to(() => InfoPage(), arguments: 'CenterForword');
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
              sliderWidget(imageList_CF, _CF, width, height, 'Forword', 'CF',
                  'Wing Forword'),
            ],
          ),
        )),
      ),
    );
  }
}
