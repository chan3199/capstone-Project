import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../view_model/app_view_model.dart';
import '../main_view/myinfoPage.dart';

sliderWidget(imageList, width, height, onTap) {
  return CarouselSlider.builder(
      itemCount: imageList.length,
      itemBuilder: (context, i, id) {
        return GestureDetector(
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: Color(0xff5EA152),
                )),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  imageList[i],
                  width: width * 0.6,
                  fit: BoxFit.cover,
                )),
          ),
          onTap: onTap,
        );
      },
      options: CarouselOptions(
          enlargeCenterPage: true, height: height * 0.25, autoPlay: false));
}

class InfoPage extends StatefulWidget {
  InfoPage({Key? key}) : super(key: key);

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  List<String> imageList_CF = [
    'assets/forword/CF/giroud.jpg',
    'assets/forword/CF/ronaldo.jpg'
  ];
  String categoryName = Get.arguments;
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
                    style:
                        TextStyle(fontSize: width * 0.04, color: Colors.black),
                  ),
                ],
              ),
              onTap: () {
                Get.to(() => MyInfoPage());
              },
            ),
          ],
          centerTitle: true,
          title: Text(categoryName + ' Info',
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Garton',
                  fontSize: width * 0.07)),
        ),
        body: SingleChildScrollView(
          child: Center(
              child: Column(
            children: [
              SizedBox(
                height: height * 0.03,
              ),
              SizedBox(
                height: height * 0.03,
              ),
              Column(
                children: [
                  Text(
                    appdata.positionInfo.name,
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontFamily: 'Simple', fontSize: width * 0.07),
                  ),
                  SizedBox(
                    height: height * 0.03,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Color(0xff5EA152)),
                    ),
                    width: width * 0.7,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        appdata.positionInfo.Information,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Simple',
                          fontSize: width * 0.04,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.03,
                  ),
                  sliderWidget(
                      appdata.positionInfo.image, width, height, () {}),
                ],
              ),
              // StreamBuilder(
              //     stream: pStream,
              //     builder: (context, snapshot) {
              //       if (snapshot.hasError) {
              //         print(snapshot.error);
              //         return Center(
              //           child: Text('오류가 발생했습니다.'),
              //         );
              //       }
              //       if (snapshot.data == null) {
              //         return Text('데이터가 없습니다.');
              //       }

              //       List<PositionInfo> cfInfoList = [];
              //       for (var element in snapshot.data!.docs) {
              //         PositionInfo positionInfo = PositionInfo.fromJson(
              //             element.data() as Map<String, dynamic>);
              //         cfInfoList.add(positionInfo);
              //         //print(cfInfoList[0].name);
              //       }
              //       PositionInfo rightInfo;
              //       for (var cfInfo in cfInfoList) {
              //         if (cfInfo.docId == category) {
              //           rightInfo = cfInfo;
              //         }
              //       }
              //       return Column(
              //         children: [
              //           Text(
              //             rightInfo.name,
              //             style: TextStyle(
              //                 fontFamily: 'Simple', fontSize: width * 0.07),
              //           ),
              //           SizedBox(
              //             height: height * 0.03,
              //           ),
              //           Container(
              //             decoration: BoxDecoration(
              //               borderRadius: BorderRadius.circular(15),
              //               border: Border.all(color: Color(0xff5EA152)),
              //             ),
              //             width: width * 0.7,
              //             child: Text(
              //               rightInfo.Information,
              //               style: TextStyle(
              //                   fontFamily: 'Simple', fontSize: width * 0.04),
              //             ),
              //           ),
              //           SizedBox(
              //             height: height * 0.03,
              //           ),
              //           sliderWidget(imageList_CF, width, height, () {}),
              //         ],
              //       );
              //     }),
            ],
          )),
        ));
  }
}
