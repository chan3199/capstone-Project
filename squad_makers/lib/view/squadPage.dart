import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squad_makers/controller/database_controller.dart';
import 'package:squad_makers/model/invition_model.dart';
import 'package:squad_makers/utils/loding.dart';
import 'package:squad_makers/view/club_view/club_mainPage.dart';
import 'package:squad_makers/view/myinfo.dart';
import 'package:squad_makers/view/positionInfoPage.dart';
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

class SquadPage extends StatefulWidget {
  const SquadPage({super.key});

  @override
  State<SquadPage> createState() => _SquadPageState();
}

class _SquadPageState extends State<SquadPage> {
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
            elevation: 0.2,
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: const Icon(
                Icons.email,
                color: Colors.white,
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
                                  future: databasecontroller.getinvitionlist(
                                      appdata.myInfo.invitions),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return const Center(
                                          child: Text('오류가 발생했습니다.'));
                                    }
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return StaticLoading();
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
                                                          await databasecontroller
                                                              .joinclub(
                                                                  appdata.myInfo
                                                                      .uid,
                                                                  appdata.myInfo
                                                                      .myclubs);
                                                          await databasecontroller
                                                              .addclubuser(
                                                                  invition
                                                                      .clubname,
                                                                  appdata.myInfo
                                                                      .uid);
                                                          String invidoc =
                                                              await databasecontroller
                                                                  .getdocIdtoinvition(
                                                                      invition
                                                                          .clubname,
                                                                      invition
                                                                          .user);
                                                          await databasecontroller
                                                              .deleteinvition(
                                                                  invidoc);
                                                          setState(() {
                                                            print('새로고침');
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
                                                              await databasecontroller
                                                                  .getdocIdtoinvition(
                                                                      invition
                                                                          .clubname,
                                                                      invition
                                                                          .user);
                                                          await databasecontroller
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
            backgroundColor: const Color(0x805EA152),
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
            title: Text('SquadMakers',
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Garton',
                    fontSize: width * 0.08)),
          ),
          // drawer: Drawer(),
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
