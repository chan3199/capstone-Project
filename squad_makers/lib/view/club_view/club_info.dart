import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squad_makers/controller/checkValidation.dart';
import 'package:squad_makers/utils/toast_massage.dart';
import 'package:squad_makers/controller/club_controller.dart';
import 'package:squad_makers/controller/database_controller.dart';
import 'package:squad_makers/controller/invitions_controller.dart';
import 'package:squad_makers/controller/squad_controller.dart';
import 'package:squad_makers/model/myinfo.dart';
import 'package:squad_makers/model/squad_model.dart';
import 'package:squad_makers/utils/loding.dart';
import 'package:squad_makers/view/club_view/club_mainPage.dart';
import 'package:squad_makers/view/club_view/my_clubPage.dart';
import 'package:squad_makers/view/myinfo.dart';
import 'package:squad_makers/view/squad_view/squad_editPage.dart';
import 'package:squad_makers/view_model/app_view_model.dart';

class ClubInfoPage extends StatefulWidget {
  ClubInfoPage({Key? key}) : super(key: key);

  @override
  State<ClubInfoPage> createState() => _ClubInfoPageState();
}

class _ClubInfoPageState extends State<ClubInfoPage> {
  TextEditingController invitionusercontroller = TextEditingController();
  TextEditingController squadnamecontroller = TextEditingController();
  List<String> formationlist = ['4-2-3-1', '4-2-2', '4-3-3'];
  AppViewModel appdata = Get.find();

  @override
  void dispose() {
    super.dispose();
    invitionusercontroller.dispose();
    squadnamecontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return GetBuilder(builder: (AppViewModel appdata) {
      return Loading(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0.2,
            automaticallyImplyLeading: false,
            toolbarHeight: height * 0.08,
            backgroundColor: const Color(0x805EA152),
            actions: [
              GestureDetector(
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
                      style: TextStyle(
                          fontSize: width * 0.04, color: Colors.black),
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
            ],
            centerTitle: true,
            title: Text(appdata.clubModel.name,
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Garton',
                    fontSize: width * 0.07)),
          ),
          body: SingleChildScrollView(
            child: Center(
                child: Column(children: [
              SizedBox(
                height: height * 0.1,
              ),
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: width * 0.15,
                backgroundImage: NetworkImage(appdata.clubModel.image),
              ),
              SizedBox(
                height: height * 0.03,
              ),
              Text(appdata.clubModel.info, style: const TextStyle()),
              SizedBox(
                height: height * 0.03,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                if (appdata.clubModel.clubmaster == appdata.myInfo.uid)
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0x805EA152),
                        padding: const EdgeInsets.all(5),
                      ),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              var width = MediaQuery.of(context).size.width;
                              var height = MediaQuery.of(context).size.height;
                              return AlertDialog(
                                title: Text('선수 초대',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: width * 0.05,
                                      fontFamily: 'Simple',
                                      color: Colors.black,
                                    )),
                                content: SingleChildScrollView(
                                  child: SizedBox(
                                      width: width,
                                      height: height * 0.1,
                                      child: TextField(
                                        controller: invitionusercontroller,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0)),
                                              borderSide: BorderSide(
                                                width: 1,
                                                color: Color(0xff5EA152),
                                              )),
                                          hintText: '이메일 입력',
                                        ),
                                      )),
                                ),
                                actions: [
                                  Center(
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0x805EA152),
                                          padding: const EdgeInsets.all(5),
                                        ),
                                        onPressed: () async {
                                          appdata.isLoadingScreen = true;
                                          if (await databasecontroller
                                                  .isDuplicatedEmail(
                                                      invitionusercontroller
                                                          .text
                                                          .trim()) ==
                                              true) {
                                            invitionsController.addinvition(
                                              invitionusercontroller.text,
                                              appdata.clubModel.name,
                                              appdata.clubModel.image,
                                            );
                                            appdata.isLoadingScreen = false;
                                            invitionusercontroller.text = '';
                                            Navigator.of(context).pop();
                                          } else {
                                            toastMessage('존재하지 않는 유저 이름입니다.');
                                            appdata.isLoadingScreen = false;
                                            invitionusercontroller.text = '';
                                            Navigator.of(context).pop();
                                          }
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
                      },
                      child: Text('초대하기',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: width * 0.05,
                            fontFamily: 'Simple',
                            color: Colors.black,
                          ))),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0x805EA152),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 0),
                    ),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            var width = MediaQuery.of(context).size.width;
                            var height = MediaQuery.of(context).size.height;
                            return StatefulBuilder(builder:
                                (BuildContext context, StateSetter setState) {
                              return AlertDialog(
                                title: Text('선수 명단',
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
                                        future: clubController.getclubuserlist(
                                            appdata.clubModel.clubuserlist),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasError) {
                                            return const Center(
                                                child: Text('오류가 발생했습니다.'));
                                          } else if (snapshot.data == null) {
                                            return Container();
                                          }
                                          List<dynamic> clubuserlist =
                                              snapshot.data!;
                                          return ListView.builder(
                                            scrollDirection: Axis.vertical,
                                            itemCount: clubuserlist.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              MyInfo clubuser =
                                                  clubuserlist.elementAt(index);
                                              return Container(
                                                width: width,
                                                height: height * 0.05,
                                                color: const Color(0x805EA152),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width: width * 0.15,
                                                      child: Text(
                                                        "이름 : " + clubuser.name,
                                                        style: TextStyle(
                                                            fontSize:
                                                                width * 0.03),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: width * 0.02,
                                                    ),
                                                    Container(
                                                      width: width * 0.18,
                                                      child: Text(
                                                        "닉네임 : " +
                                                            clubuser.nickname,
                                                        style: TextStyle(
                                                            fontSize:
                                                                width * 0.03),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: width * 0.02,
                                                    ),
                                                    if (appdata.clubModel
                                                            .clubmaster ==
                                                        clubuser.uid)
                                                      Row(
                                                        children: [
                                                          Container(
                                                              width:
                                                                  width * 0.2,
                                                              child: Text(
                                                                '클럽 관리자',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        width *
                                                                            0.03),
                                                              )),
                                                        ],
                                                      )
                                                    else if (appdata
                                                        .clubModel.adminlist
                                                        .contains(clubuser.uid))
                                                      Container(
                                                          width: width * 0.16,
                                                          child: Text(
                                                            '생성 권한 O',
                                                            style: TextStyle(
                                                                fontSize:
                                                                    width *
                                                                        0.03),
                                                          ))
                                                    else
                                                      Container(
                                                        width: width * 0.16,
                                                        child: Text(
                                                          '일반 유저',
                                                          style: TextStyle(
                                                              fontSize:
                                                                  width * 0.03),
                                                        ),
                                                      ),
                                                    SizedBox(
                                                        width: width * 0.02),
                                                    if (clubuser.uid !=
                                                        appdata.clubModel
                                                            .clubmaster)
                                                      if (appdata.clubModel
                                                                  .clubmaster ==
                                                              appdata
                                                                  .myInfo.uid &&
                                                          !appdata.clubModel
                                                              .adminlist
                                                              .contains(
                                                                  clubuser.uid))
                                                        Container(
                                                          width: width * 0.1,
                                                          height: height * 0.1,
                                                          child: TextButton(
                                                            child: Text(
                                                              '등록',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      width *
                                                                          0.03,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                            onPressed:
                                                                () async {
                                                              setState(
                                                                () {
                                                                  appdata
                                                                      .clubModel
                                                                      .adminlist
                                                                      .add(clubuser
                                                                          .uid);
                                                                },
                                                              );
                                                              await clubController
                                                                  .addAdmin(
                                                                      appdata
                                                                          .clubModel
                                                                          .name,
                                                                      clubuser
                                                                          .uid);
                                                            },
                                                          ),
                                                        )
                                                      else if (appdata.clubModel
                                                                  .clubmaster ==
                                                              appdata
                                                                  .myInfo.uid &&
                                                          appdata.clubModel
                                                              .adminlist
                                                              .contains(
                                                                  clubuser.uid))
                                                        Container(
                                                          width: width * 0.1,
                                                          height: height * 0.1,
                                                          child: TextButton(
                                                            child: Text(
                                                              '해제',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      width *
                                                                          0.03,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                            onPressed:
                                                                () async {
                                                              setState(
                                                                () {
                                                                  appdata
                                                                      .clubModel
                                                                      .adminlist
                                                                      .remove(clubuser
                                                                          .uid);
                                                                },
                                                              );
                                                              await clubController
                                                                  .removeAdmin(
                                                                      appdata
                                                                          .clubModel
                                                                          .name,
                                                                      clubuser
                                                                          .uid);
                                                            },
                                                          ),
                                                        )
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        }),
                                  ),
                                ),
                                actions: [
                                  Center(
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0x805EA152),
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
                    child: Text('선수명단',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: width * 0.05,
                          fontFamily: 'Simple',
                          color: Colors.black,
                        ))),
              ]),
              SizedBox(
                height: height * 0.05,
              ),
              Text('Squad 목록',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: width * 0.05,
                    fontFamily: 'Simple',
                    color: Colors.black,
                  )),
              Container(
                width: width * 0.7,
                height: height * 0.5,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: const Color(0xff5EA152),
                    )),
                child: Column(children: [
                  if (appdata.clubModel.adminlist.contains(appdata.myInfo.uid))
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0x805EA152),
                          padding: const EdgeInsets.all(5),
                        ),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                var width = MediaQuery.of(context).size.width;
                                var height = MediaQuery.of(context).size.height;
                                String selectedOption = '4-2-3-1';
                                return StatefulBuilder(builder:
                                    (BuildContext context,
                                        StateSetter setState) {
                                  return AlertDialog(
                                    title: Text('스쿼드 생성'),
                                    content: SizedBox(
                                      height: height * 0.4,
                                      child: SingleChildScrollView(
                                        child: Column(children: [
                                          SizedBox(height: height * 0.03),
                                          Text('이름'),
                                          SizedBox(height: height * 0.02),
                                          SizedBox(
                                              height: height * 0.08,
                                              child: TextField(
                                                controller: squadnamecontroller,
                                                decoration:
                                                    const InputDecoration(
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10.0)),
                                                      borderSide: BorderSide(
                                                        width: 1,
                                                        color:
                                                            Color(0xff5EA152),
                                                      )),
                                                  hintText: '스쿼드 이름 입력',
                                                ),
                                              )),
                                          SizedBox(height: height * 0.03),
                                          Text('포메이션 선택'),
                                          SizedBox(height: height * 0.02),
                                          DropdownButton(
                                            value: selectedOption,
                                            onChanged: (String? newvalue) {
                                              setState(() {
                                                selectedOption = newvalue!;
                                              });
                                            },
                                            items: formationlist
                                                .map<DropdownMenuItem<String>>(
                                                    (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                          )
                                        ]),
                                      ),
                                    ),
                                    actions: [
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color(0x805EA152),
                                            padding: const EdgeInsets.all(5),
                                          ),
                                          onPressed: () async {
                                            if (!(squadnamecontroller.text ==
                                                    '') &&
                                                validateClubname(
                                                    squadnamecontroller.text)) {
                                              Navigator.of(context).pop();
                                              appdata.isLoadingScreen = true;
                                              String? docid =
                                                  await squadController
                                                      .createSquad(
                                                          appdata
                                                              .clubModel.name,
                                                          squadnamecontroller
                                                              .text,
                                                          selectedOption,
                                                          appdata.clubModel
                                                              .clubuserlist);
                                              appdata.clubModel.squadlist
                                                  .add(docid);
                                              await squadController.addSquad(
                                                  appdata.clubModel.name,
                                                  appdata.clubModel.squadlist);
                                              await squadController
                                                  .getsquadinfo(
                                                      appdata.clubModel.name,
                                                      squadnamecontroller.text);
                                              appdata.isLoadingScreen = false;

                                              squadnamecontroller.text = '';
                                              selectedOption = '4-2-3-1';
                                              Get.to(() => SquadEditPage());
                                            } else {
                                              toastMessage(
                                                  '스쿼드 이름이 비어있거나 유효하지 않습니다.');
                                            }
                                          },
                                          child: Text('스쿼드 생성하기',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: width * 0.05,
                                                fontFamily: 'Simple',
                                                color: Colors.black,
                                              )))
                                    ],
                                  );
                                });
                              });
                        },
                        child: Text('새 스쿼드',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: width * 0.05,
                              fontFamily: 'Simple',
                              color: Colors.black,
                            ))),
                  SizedBox(
                    width: width * 0.7,
                    child: FutureBuilder(
                        future: squadController
                            .getSquadlist(appdata.clubModel.squadlist),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text('에러발생');
                          } else if (snapshot.data == [] ||
                              snapshot.data == null) {
                            return Container();
                          } else {
                            List<dynamic> squadlist = snapshot.data!;
                            return ListView.builder(
                              itemCount: squadlist.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                SquadModel squadmodel =
                                    squadlist.elementAt(index);

                                return ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0x805EA152),
                                    padding: EdgeInsets.all(5),
                                  ),
                                  onPressed: () async {
                                    appdata.isLoadingScreen = true;
                                    await squadController.getsquadinfo(
                                        appdata.clubModel.name,
                                        squadmodel.squadname);
                                    appdata.isLoadingScreen = false;
                                    Get.to(SquadEditPage());
                                  },
                                  child: Container(
                                    width: width * 0.7,
                                    height: height * 0.1,
                                    color: Colors.green[100],
                                    child: Row(
                                      children: [
                                        Container(
                                          width: width * 0.3,
                                          height: height * 0.08,
                                          alignment: Alignment.center,
                                          child: Text(
                                            squadmodel.squadname,
                                            style: TextStyle(
                                                fontFamily: 'Simple',
                                                color: Colors.black,
                                                fontSize: width * 0.06),
                                          ),
                                        ),
                                        SizedBox(
                                          width: width * 0.2,
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title:
                                                          Text('정말 삭제하시겠습니까?'),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: Text('취소'),
                                                        ),
                                                        TextButton(
                                                          onPressed: () async {
                                                            appdata.isLoadingScreen =
                                                                true;
                                                            List<dynamic>?
                                                                temp =
                                                                await squadController.squadDelete(
                                                                    appdata
                                                                        .clubModel
                                                                        .name,
                                                                    squadmodel
                                                                        .squadname,
                                                                    appdata
                                                                        .clubModel
                                                                        .squadlist);
                                                            appdata.clubModel
                                                                    .squadlist =
                                                                temp!;
                                                            print(appdata
                                                                .clubModel
                                                                .squadlist);
                                                            appdata.isLoadingScreen =
                                                                false;
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            setState(() {});
                                                          },
                                                          child: Text('확인'),
                                                        ),
                                                      ],
                                                    );
                                                  });
                                            },
                                            icon: Icon(Icons.delete))
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        }),
                  )
                ]),
              ),
              SizedBox(
                height: height * 0.05,
              ),
              appdata.clubModel.clubmaster != appdata.myInfo.uid
                  ? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0x805EA152),
                        padding: const EdgeInsets.all(5),
                      ),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('정말 탈퇴하시겠습니까?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('취소'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      Navigator.of(context).pop();
                                      appdata.isLoadingScreen = true;
                                      await clubController.clubExit(
                                          appdata.myInfo.uid,
                                          appdata.clubModel);
                                      appdata.myInfo.myclubs
                                          .remove(appdata.clubModel.name);
                                      appdata.isLoadingScreen = false;
                                      Get.off(ClubMainPage());
                                    },
                                    child: Text('확인'),
                                  ),
                                ],
                              );
                            });
                      },
                      child: Text('탈퇴하기',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: width * 0.05,
                            fontFamily: 'Simple',
                            color: Colors.black,
                          )))
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0x805EA152),
                        padding: const EdgeInsets.all(5),
                      ),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('정말 해체하시겠습니까?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('취소'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      Navigator.of(context).pop();
                                      appdata.isLoadingScreen = true;
                                      await clubController
                                          .clubDelete(appdata.clubModel);
                                      appdata.clubModel.squadlist = [];
                                      appdata.myInfo.myclubs
                                          .remove(appdata.clubModel.name);
                                      appdata.isLoadingScreen = false;

                                      Get.off(ClubMainPage());
                                    },
                                    child: Text('확인'),
                                  ),
                                ],
                              );
                            });
                      },
                      child: Text('해체하기',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: width * 0.05,
                            fontFamily: 'Simple',
                            color: Colors.black,
                          ))),
              SizedBox(
                height: height * 0.05,
              ),
            ])),
          ),
        ),
      );
    });
  }
}
