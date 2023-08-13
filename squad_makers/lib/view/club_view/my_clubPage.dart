import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squad_makers/controller/club_controller.dart';
import 'package:squad_makers/model/club_model.dart';
import 'package:squad_makers/utils/loding.dart';
import 'package:squad_makers/view/club_view/club_info.dart';
import 'package:squad_makers/view/main_view/myinfoPage.dart';
import 'package:squad_makers/view_model/app_view_model.dart';

class MyClubPage extends StatefulWidget {
  const MyClubPage({Key? key}) : super(key: key);

  @override
  State<MyClubPage> createState() => _MyClubPageState();
}

class _MyClubPageState extends State<MyClubPage> {
  AppViewModel appdata = Get.find();
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
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
                        width: width * 0.06,
                        height: height * 0.07,
                        child: CircleAvatar(
                            backgroundImage:
                                const AssetImage('assets/basic.png')),
                      )
                    : SizedBox(
                        width: width * 0.07,
                        height: height * 0.07,
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
                SizedBox(
                  width: width * 0.03,
                ),
              ],
            ),
            onTap: () {
              Get.to(() => MyInfoPage());
            },
          ),
          // SizedBox(
          //   width: width * 0.03,
          // )
        ],
        centerTitle: true,
        title: Text('Club',
            style: TextStyle(
                color: Colors.black,
                fontFamily: 'Garton',
                fontSize: width * 0.08)),
      ),
      body: Column(
        children: [
          Container(
              height: height * 0.05,
              alignment: Alignment.center,
              child: Text('클럽 리스트')),
          Container(
            height: height * 0.004,
            color: Colors.grey,
          ),
          Container(
            width: width,
            height: height * 0.05,
            child: Row(
              children: [
                SizedBox(
                  width: width * 0.27,
                ),
                Container(
                  width: width * 0.15,
                  child: Text(
                    "클럽 이름",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: Colors.black),
                  ),
                ),
                SizedBox(
                  width: width * 0.03,
                ),
                Container(
                  width: width * 0.35,
                  child: Text(
                    "클럽 소개",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: Colors.black),
                  ),
                ),
                SizedBox(
                  width: width * 0.03,
                ),
                Container(
                  width: width * 0.15,
                  child: Text(
                    "클럽원 수",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: height * 0.004,
            color: Colors.grey,
          ),
          SingleChildScrollView(
            child: SizedBox(
              height: height * 0.775,
              child: FutureBuilder(
                  future: clubController.getclublist(appdata.myInfo.myclubs),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('오류가 발생했습니다.'));
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return StaticLoading();
                    }
                    List<dynamic> clublist = snapshot.data!;
                    return ListView.builder(
                      itemCount: clublist.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        ClubModel clubmodel = clublist.elementAt(index);
                        return Column(
                          children: [
                            SizedBox(
                              height: height * 0.01,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0x805EA152),
                                padding: EdgeInsets.all(5),
                              ),
                              onPressed: () async {
                                await clubController
                                    .loadClubInfo(clubmodel.name);
                                Get.to(() => ClubInfoPage());
                              },
                              child: Row(
                                children: [
                                  CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: width * 0.12,
                                      backgroundImage:
                                          NetworkImage(clubmodel.image)),
                                  SizedBox(width: width * 0.03),
                                  Container(
                                    width: width * 0.15,
                                    height: height * 0.05,
                                    alignment: Alignment.center,
                                    child: Text(clubmodel.name,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.black,
                                        )),
                                  ),
                                  SizedBox(width: width * 0.03),
                                  Container(
                                    width: width * 0.35,
                                    height: height * 0.08,
                                    alignment: Alignment.center,
                                    child: Text(clubmodel.info,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 13, color: Colors.black)),
                                  ),
                                  SizedBox(width: width * 0.03),
                                  Container(
                                    width: width * 0.12,
                                    height: height * 0.05,
                                    alignment: Alignment.center,
                                    child: Text(clubmodel.clubuser.toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 13, color: Colors.black)),
                                  )
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }),
            ),
          )
        ],
      ),
    );
  }
}
