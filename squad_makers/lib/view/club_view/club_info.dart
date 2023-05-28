import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squad_makers/classes/toast_massage.dart';
import 'package:squad_makers/controller/database_controller.dart';
import 'package:squad_makers/model/myinfo.dart';
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
  @override
  Widget build(BuildContext context) {
    AppViewModel appdata = Get.find();
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.2,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(
            Icons.settings,
            color: Colors.black,
          ),
          onPressed: () {},
        ),
        toolbarHeight: height * 0.08,
        backgroundColor: const Color(0x805EA152),
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
                  appdata.myInfo.name, // username 또한 user 정보에서 불러와서 넣기
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
        ],
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(appdata.clubModel.name,
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Garton',
                    fontSize: width * 0.07)),
          ],
        ),
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
                                      backgroundColor: const Color(0x805EA152),
                                      padding: const EdgeInsets.all(5),
                                    ),
                                    onPressed: () async {
                                      if (await databasecontroller
                                              .isDuplicatedEmail(
                                                  invitionusercontroller.text
                                                      .trim()) ==
                                          true) {
                                        databasecontroller.addinvition(
                                          invitionusercontroller.text,
                                          appdata.clubModel.name,
                                          appdata.clubModel.image,
                                        );
                                        Navigator.of(context).pop();
                                      } else {
                                        toastMessage('존재하지 않는 유저 이름입니다.');
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                ),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        var width = MediaQuery.of(context).size.width;
                        var height = MediaQuery.of(context).size.height;
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
                                  future: databasecontroller.getclubuserlist(
                                      appdata.clubModel.clubuserlist),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return const Center(
                                          child: Text('오류가 발생했습니다.'));
                                    } else if (snapshot.data == null) {
                                      return Container();
                                    }
                                    List<dynamic> clubuserlist = snapshot.data!;
                                    return ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemCount: clubuserlist.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        MyInfo clubuser =
                                            clubuserlist.elementAt(index);
                                        return Container(
                                          width: width * 0.8,
                                          height: height * 0.05,
                                          color: const Color(0x805EA152),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: width * 0.3,
                                                height: height * 0.1,
                                                child: Text(
                                                  "이름 : " + clubuser.name,
                                                ),
                                              ),
                                              SizedBox(
                                                width: width * 0.05,
                                              ),
                                              Container(
                                                width: width * 0.3,
                                                height: height * 0.1,
                                                child: Text(
                                                  "닉네임 : " + clubuser.nickname,
                                                ),
                                              ),
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
                              (BuildContext context, StateSetter setState) {
                            return AlertDialog(
                              title: Text('스쿼드 생성'),
                              content: SizedBox(
                                height: height * 0.3,
                                child: Column(children: [
                                  SizedBox(height: height * 0.03),
                                  Text('이름'),
                                  SizedBox(height: height * 0.02),
                                  SizedBox(
                                      height: height * 0.08,
                                      child: TextField(
                                        controller: squadnamecontroller,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0)),
                                              borderSide: BorderSide(
                                                width: 1,
                                                color: Color(0xff5EA152),
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
                              actions: [
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0x805EA152),
                                      padding: const EdgeInsets.all(5),
                                    ),
                                    onPressed: () {
                                      databasecontroller.createSquad(
                                          appdata.clubModel.name,
                                          squadnamecontroller.text,
                                          selectedOption,
                                          appdata.clubModel.clubuserlist);
                                      // Get.to(() => SquadEditPage());
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
                      )))
            ]),
          ),
          SizedBox(
            height: height * 0.1,
          )
        ])),
      ),
    );
  }
}
