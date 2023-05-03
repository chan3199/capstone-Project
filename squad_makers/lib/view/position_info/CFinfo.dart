import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squad_makers/model/position_model.dart';

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
                child: Image.asset(
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

class CFInfoPage extends StatefulWidget {
  CFInfoPage({Key? key}) : super(key: key);

  @override
  State<CFInfoPage> createState() => _CFInfoPageState();
}

class _CFInfoPageState extends State<CFInfoPage> {
  late String category;
  List<String> imageList_CF = [
    'assets/forword/CF/giroud.jpg',
    'assets/forword/CF/ronaldo.jpg'
  ];

  @override
  Widget build(BuildContext context) {
    category = Get.arguments;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    // final CollectionReference mainColleciton =
    //     FirebaseFirestore.instance.collection('PositionInfo/Forword/CF');
    // final DocumentReference cfinfo = mainColleciton.doc(category);
    final Stream<QuerySnapshot> _cfStream = firestore
        .collection('PositionInfo')
        .doc('Forword')
        .collection('CF')
        .snapshots();
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
          title: Text('CenterForword Info',
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
              Text(
                category,
                style: TextStyle(fontFamily: 'Simple', fontSize: width * 0.05),
              ),
              SizedBox(
                height: height * 0.03,
              ),
              StreamBuilder(
                  stream: _cfStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      print(snapshot.error);
                      return Center(
                        child: Text('오류가 발생했습니다.'),
                      );
                    }
                    if (snapshot.data == null) {
                      return Text('데이터가 없습니다.');
                    }

                    List<PositionInfo> cfInfoList = [];
                    for (var element in snapshot.data!.docs) {
                      PositionInfo positionInfo = PositionInfo.fromJson(
                          element.data() as Map<String, dynamic>);
                      cfInfoList.add(positionInfo);
                      //print(cfInfoList[0].name);
                    }
                    late PositionInfo rightInfo;
                    for (var cfInfo in cfInfoList) {
                      if (cfInfo.docId == category) {
                        rightInfo = cfInfo;
                      }
                    }
                    return Column(
                      children: [
                        Text(
                          rightInfo.name,
                          style: TextStyle(
                              fontFamily: 'Simple', fontSize: width * 0.07),
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
                          child: Text(
                            rightInfo.Information,
                            style: TextStyle(
                                fontFamily: 'Simple', fontSize: width * 0.04),
                          ),
                        ),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        sliderWidget(imageList_CF, width, height, () {}),
                      ],
                    );
                  }),
            ],
          )),
        ));
  }
}
