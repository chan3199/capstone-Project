import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squad_makers/controller/club_controller.dart';
import 'package:squad_makers/controller/invitions_controller.dart';
import 'package:squad_makers/model/invition_model.dart';
import 'package:squad_makers/utils/loding.dart';
import 'package:squad_makers/view/club_view/club_mainPage.dart';
import 'package:squad_makers/view/main_view/myinfoPage.dart';
import 'package:squad_makers/view/position_info/positionInfoPage.dart';
import 'package:squad_makers/view_model/app_view_model.dart';

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
              border: Border.all(color: const Color(0xff5EA152)),
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

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return GetBuilder(builder: (AppViewModel appdata) {
      return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 1,
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: const Icon(
                Icons.email,
                color: Colors.black,
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      var width = MediaQuery.of(context).size.width;
                      var height = MediaQuery.of(context).size.height;
                      return StatefulBuilder(builder:
                          (BuildContext context, StateSetter setState) {
                        return AlertDialog(
                          title: Text('초대 메세지',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: width * 0.05,
                                fontFamily: 'Simple',
                                color: Colors.black,
                              )),
                          content: SingleChildScrollView(
                            child: SizedBox(
                              width: width,
                              height: height * 0.3,
                              child: FutureBuilder(
                                  future: invitionsController.getinvitionlist(
                                      appdata.myInfo.invitions),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return const Center(
                                          child: Text('오류가 발생했습니다.'));
                                    }
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const StaticLoading();
                                    } else {
                                      List<dynamic>? invilist = snapshot.data;

                                      return ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        itemCount: invilist!.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          InvitionModel invition =
                                              invilist.elementAt(index);
                                          return Container(
                                            width: width * 0.8,
                                            height: height * 0.06,
                                            color: const Color(0x805EA152),
                                            child: Row(
                                              children: [
                                                CircleAvatar(
                                                  backgroundColor: Colors.white,
                                                  radius: width * 0.07,
                                                  backgroundImage: NetworkImage(
                                                      invition.image),
                                                ),
                                                Container(
                                                  width: width * 0.25,
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    invition.clubname,
                                                    style: TextStyle(
                                                        fontFamily: 'Garton',
                                                        fontSize: width * 0.05),
                                                  ),
                                                ),
                                                Flexible(
                                                  flex: 1,
                                                  child: SizedBox(
                                                    height: height * 0.06,
                                                    child: ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          shape:
                                                              const RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            0)),
                                                          ),
                                                          elevation: 0,
                                                          backgroundColor:
                                                              const Color(
                                                                  0x805EA152),
                                                        ),
                                                        onPressed: () async {
                                                          appdata.myInfo.myclubs
                                                              .add(invition
                                                                  .clubname);
                                                          await clubController
                                                              .joinclub(
                                                                  appdata.myInfo
                                                                      .uid,
                                                                  appdata.myInfo
                                                                      .myclubs);
                                                          await clubController
                                                              .addclubuser(
                                                                  invition
                                                                      .clubname,
                                                                  appdata.myInfo
                                                                      .uid);
                                                          String invidoc =
                                                              await invitionsController
                                                                  .getdocIdtoinvition(
                                                                      invition
                                                                          .clubname,
                                                                      invition
                                                                          .user);

                                                          await invitionsController
                                                              .deleteinvition(
                                                                  invidoc);
                                                          setState(() {
                                                            appdata.myInfo
                                                                .invitions
                                                                .remove(
                                                                    invidoc);
                                                          });
                                                        },
                                                        child: Text('가입',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              fontSize:
                                                                  width * 0.03,
                                                              fontFamily:
                                                                  'Simple',
                                                              color:
                                                                  Colors.black,
                                                            ))),
                                                  ),
                                                ),
                                                Flexible(
                                                  flex: 1,
                                                  child: SizedBox(
                                                    height: height * 0.06,
                                                    child: ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          shape:
                                                              const RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            0)),
                                                          ),
                                                          elevation: 0,
                                                          backgroundColor:
                                                              const Color
                                                                  .fromARGB(
                                                                  255,
                                                                  211,
                                                                  108,
                                                                  101),
                                                        ),
                                                        onPressed: () async {
                                                          String invidoc =
                                                              await invitionsController
                                                                  .getdocIdtoinvition(
                                                                      invition
                                                                          .clubname,
                                                                      invition
                                                                          .user);
                                                          await invitionsController
                                                              .deleteinvition(
                                                                  invidoc);

                                                          setState(() {
                                                            appdata.myInfo
                                                                .invitions
                                                                .remove(
                                                                    invidoc);
                                                          });
                                                        },
                                                        child: Text('거절',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              fontSize:
                                                                  width * 0.03,
                                                              fontFamily:
                                                                  'Simple',
                                                              color:
                                                                  Colors.black,
                                                            ))),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    }
                                  }),
                            ),
                          ),
                          actions: [
                            Center(
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0x805EA152),
                                    padding: const EdgeInsets.all(5),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('확인',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontFamily: 'Simple',
                                        color: Colors.black,
                                      ))),
                            ),
                          ],
                        );
                      });
                    });
              },
            ),
            toolbarHeight: height * 0.08,
            backgroundColor: Colors.white,
            actions: [
              SizedBox(
                width: width * 0.01,
              ),
              GestureDetector(
                child: Row(
                  children: [
                    appdata.myInfo.image == ""
                        ? SizedBox(
                            width: width * 0.05,
                            height: height * 0.06,
                            child: const CircleAvatar(
                                backgroundImage:
                                    AssetImage('assets/basic.png')),
                          )
                        : SizedBox(
                            width: width * 0.05,
                            height: height * 0.06,
                            child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 30,
                                backgroundImage:
                                    NetworkImage(appdata.myInfo.image)),
                          ),
                    SizedBox(
                      width: width * 0.01,
                    ),
                    Text(
                      appdata.myInfo.name,
                      style: TextStyle(
                          fontSize: width * 0.03, color: Colors.black),
                    ),
                    SizedBox(
                      width: width * 0.03,
                    ),
                  ],
                ),
                onTap: () {
                  Get.to(() => const MyInfoPage());
                },
              ),
            ],
            centerTitle: true,
            title: Text('SquadMakers',
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Garton',
                    fontSize: width * 0.08)),
          ),
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
                  () => Get.to(() => const PositionInfoPage()),
                ),
                SizedBox(
                  height: height * 0.03,
                ),
                mainBox(height, width, 'assets/squad1.png', 'Squad Maker',
                    () => Get.to(() => const ClubMainPage()))
              ],
            )),
          )));
    });
  }
}
