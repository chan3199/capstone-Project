import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squad_makers/controller/club_controller.dart';
import 'package:squad_makers/controller/squad_controller.dart';
import 'package:squad_makers/controller/user_controller.dart';
import 'package:squad_makers/model/moveableitem_model.dart';
import 'package:squad_makers/model/user_model.dart';
import 'package:squad_makers/model/tactic_model.dart';
import 'package:squad_makers/utils/loding.dart';
import 'package:squad_makers/utils/toast_massage.dart';
import 'package:squad_makers/view_model/app_view_model.dart';

Widget dropdownmenu(value, List<String> list, func) {
  return DropdownButton(
      value: value,
      items: list.map((value) {
        return DropdownMenuItem(
          value: value,
          child: Text(value,
              style: const TextStyle(
                fontFamily: 'Simple',
                color: Colors.black,
              )),
        );
      }).toList(),
      onChanged: func);
}

class SquadEditPage extends StatefulWidget {
  const SquadEditPage({super.key});

  @override
  State<SquadEditPage> createState() => _SquadEditState();
}

class _SquadEditState extends State<SquadEditPage> {
  String? flag;
  final tacticNameController = TextEditingController();
  final tacticInfoController = TextEditingController();
  final linelist = ['높게', '낮게'];
  final spacelist = ['넓게', '좁게'];
  final shotlist = ['신중하게', '빈번하게'];
  final pressurelist = ['강하게', '약하게'];
  final directionlist = ['중앙', '측면'];
  final passlist = ['짧은 패스', '긴 패스'];

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      theme: const CupertinoThemeData(brightness: Brightness.dark),
      home: MaterialApp(
        home: Scaffold(
          body: Center(child: _buildStack(context)),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    flag = 'player';
  }

  void savetactic(AppViewModel appdata, TacticInfo tacticinfo) {
    appdata.squadmodel.tacticsinfo = tacticinfo.toJson();
  }

  void refresh() {
    setState(() {});
  }

  Widget _buildStack(BuildContext context) {
    return GetBuilder(builder: (AppViewModel appdata) {
      return Loading(
        child: LayoutBuilder(builder: (context, constraints) {
          var width = MediaQuery.of(context).size.width;
          var height = MediaQuery.of(context).size.height;
          TacticInfo tacticinfo =
              TacticInfo.fromJson(appdata.squadmodel.tacticsinfo);
          List<Widget> moveableitemWidgets = [];
          for (int i = 0; i < appdata.squadmodel.playerlist.length; i++) {
            MoveableItem msimodel = appdata.squadmodel.playerlist[i];
            moveableitemWidgets
                .add(MoveableStackItem(msimodel, i, width, height, refresh));
          }
          return Scaffold(
            appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 1,
                centerTitle: true,
                title: Text(
                  appdata.squadmodel.squadname,
                  style: const TextStyle(
                      color: Colors.black, fontFamily: 'Simple'),
                )),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Stack(
                    children: [
                      Image.asset(
                        "assets/field.png",
                        fit: BoxFit.fill,
                        width: width,
                        height: height * 0.6,
                      ),
                      Positioned(
                        top: height * 0.015,
                        left: width * 0.8,
                        child: SizedBox(
                          width: width * 0.15,
                          height: height * 0.04,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green[400]),
                            child: const Text(
                              '저장',
                              style: TextStyle(fontFamily: 'Simple'),
                            ),
                            onPressed: () async {
                              appdata.isLoadingScreen = true;
                              await squadController.fetchsquad(
                                  appdata.squadmodel, width, height);

                              appdata.isLoadingScreen = false;
                              setState(() {});
                            },
                          ),
                        ),
                      ),
                      Positioned(
                          top: height * 0.015,
                          left: width * 0.05,
                          child: SizedBox(
                            width: width * 0.15,
                            height: height * 0.04,
                            child: CupertinoSwitch(
                              trackColor: Colors.grey[400],
                              activeColor: CupertinoColors.activeGreen,
                              value: appdata.istacticSwitch,
                              onChanged: (value) {
                                setState(() {
                                  appdata.istacticSwitch = value;
                                });
                              },
                            ),
                          )),
                      ...moveableitemWidgets,
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: height * 0.045,
                        width: width * 0.5,
                        child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: const Color(0x805EA152),
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(0)),
                              ),
                              side: const BorderSide(
                                color: Colors.black,
                                width: 1,
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                flag = 'player';
                              });
                            },
                            child: Text(
                              '선수 목록',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: width * 0.03,
                                  fontFamily: 'Simple',
                                  fontWeight: FontWeight.bold),
                            )),
                      ),
                      SizedBox(
                        height: height * 0.045,
                        width: width * 0.5,
                        child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: const Color(0x805EA152),
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(0)),
                              ),
                              side: const BorderSide(
                                color: Colors.black,
                                width: 1,
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                flag = 'tatics';
                              });
                            },
                            child: Text(
                              '전술',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: width * 0.03,
                                  fontFamily: 'Simple',
                                  fontWeight: FontWeight.bold),
                            )),
                      )
                    ],
                  ),
                  SizedBox(
                      height: height * 0.25,
                      child: flag == 'player'
                          ? FutureBuilder(
                              future: clubController
                                  .getclubuserlist(appdata.squadmodel.userlist),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return const Text('오류가 발생했습니다.');
                                } else if (snapshot.data == [] ||
                                    snapshot.data == null) {
                                  return Container();
                                } else {
                                  List<dynamic> clubuserlist = snapshot.data!;
                                  return GridView.builder(
                                    padding: EdgeInsets.all(width * 0.005),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: clubuserlist.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      var GridWidth =
                                          MediaQuery.of(context).size.width;
                                      var GridHeith =
                                          MediaQuery.of(context).size.height;
                                      MyInfo clubuser =
                                          clubuserlist.elementAt(index);
                                      return GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text('선수 정보'),
                                                content: SizedBox(
                                                  height: height * 0.3,
                                                  child: Column(
                                                    children: [
                                                      Text("이름 : " +
                                                          clubuser.name),
                                                      SizedBox(
                                                          height:
                                                              height * 0.05),
                                                      Text("닉네임 : " +
                                                          clubuser.nickname),
                                                    ],
                                                  ),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text('닫기'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child: SizedBox(
                                          child: Draggable<MyInfo>(
                                            data: clubuser,
                                            feedback: SizedBox(
                                              width: width * 0.1,
                                              height: height * 0.06,
                                              child: Image.asset(
                                                "assets/uniform.png",
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  width: GridWidth,
                                                  height: GridHeith * 0.01,
                                                ),
                                                CircleAvatar(
                                                  radius: width * 0.055,
                                                  backgroundImage: NetworkImage(
                                                      clubuser.image),
                                                ),
                                                SizedBox(
                                                  width: GridWidth,
                                                  height: GridHeith * 0.01,
                                                ),
                                                Container(
                                                    child: Text(
                                                  clubuser.name,
                                                  style: TextStyle(
                                                      fontSize: width * 0.025),
                                                )),
                                              ],
                                            ),
                                            onDragEnd: (details) {
                                              setState(() {});
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2),
                                  );
                                }
                              })
                          : SingleChildScrollView(
                              child: Column(
                              children: [
                                SizedBox(
                                  height: height * 0.02,
                                ),
                                Text("팀 전술",
                                    style: TextStyle(
                                      fontSize: width * 0.045,
                                      fontFamily: 'Simple',
                                      color: Colors.black,
                                    )),
                                SizedBox(
                                  height: height * 0.03,
                                ),
                                Row(
                                  children: [
                                    SizedBox(width: width * 0.14),
                                    SizedBox(
                                      width: width * 0.3,
                                      child: Text(
                                          '수비 라인 : ' + tacticinfo.defenseline,
                                          style: TextStyle(
                                            fontSize: width * 0.045,
                                            fontFamily: 'Simple',
                                            color: Colors.black,
                                          )),
                                    ),
                                    SizedBox(width: width * 0.14),
                                    SizedBox(
                                      width: width * 0.35,
                                      child:
                                          Text('선수 간격 : ' + tacticinfo.spacing,
                                              style: TextStyle(
                                                fontSize: width * 0.045,
                                                fontFamily: 'Simple',
                                                color: Colors.black,
                                              )),
                                    ),
                                  ],
                                ),
                                SizedBox(height: height * 0.01),
                                Row(
                                  children: [
                                    SizedBox(width: width * 0.14),
                                    SizedBox(
                                      width: width * 0.4,
                                      child: Text(
                                          '슈팅 빈도 : ' + tacticinfo.shotfrequency,
                                          style: TextStyle(
                                            fontSize: width * 0.045,
                                            fontFamily: 'Simple',
                                            color: Colors.black,
                                          )),
                                    ),
                                    SizedBox(width: width * 0.04),
                                    SizedBox(
                                      width: width * 0.35,
                                      child:
                                          Text('압박 강도 : ' + tacticinfo.pressure,
                                              style: TextStyle(
                                                fontSize: width * 0.045,
                                                fontFamily: 'Simple',
                                                color: Colors.black,
                                              )),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: height * 0.01,
                                ),
                                Row(
                                  children: [
                                    SizedBox(width: width * 0.14),
                                    SizedBox(
                                      width: width * 0.3,
                                      child: Text(
                                          '공격 방향 : ' +
                                              tacticinfo.attackdirection,
                                          style: TextStyle(
                                            fontSize: width * 0.045,
                                            fontFamily: 'Simple',
                                            color: Colors.black,
                                          )),
                                    ),
                                    SizedBox(width: width * 0.14),
                                    SizedBox(
                                      width: width * 0.4,
                                      child: Text(
                                          '패스 길이 : ' + tacticinfo.passdistance,
                                          style: TextStyle(
                                            fontSize: width * 0.045,
                                            fontFamily: 'Simple',
                                            color: Colors.black,
                                          )),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: height * 0.03,
                                ),
                                TextButton(
                                    child: Text('편집',
                                        style: TextStyle(
                                          fontSize: width * 0.04,
                                          fontFamily: 'Simple',
                                          color: Colors.black,
                                        )),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return StatefulBuilder(
                                            builder: (BuildContext context,
                                                StateSetter setState1) {
                                              return AlertDialog(
                                                title: const Text('전술 편집',
                                                    style: TextStyle(
                                                      fontFamily: 'Simple',
                                                      color: Colors.black,
                                                    )),
                                                content: SingleChildScrollView(
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          const Text('수비 라인',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Simple',
                                                                color: Colors
                                                                    .black,
                                                              )),
                                                          SizedBox(
                                                            width: width * 0.2,
                                                          ),
                                                          DropdownButton(
                                                              value: tacticinfo
                                                                  .defenseline,
                                                              items: linelist
                                                                  .map((value) {
                                                                return DropdownMenuItem(
                                                                  value: value,
                                                                  child: Text(
                                                                      value,
                                                                      style:
                                                                          const TextStyle(
                                                                        fontFamily:
                                                                            'Simple',
                                                                        color: Colors
                                                                            .black,
                                                                      )),
                                                                );
                                                              }).toList(),
                                                              onChanged:
                                                                  (value) {
                                                                setState1(() {
                                                                  tacticinfo
                                                                          .defenseline =
                                                                      value!;
                                                                  savetactic(
                                                                      appdata,
                                                                      tacticinfo);
                                                                });
                                                              })
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          const Text('선수 간격',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Simple',
                                                                color: Colors
                                                                    .black,
                                                              )),
                                                          SizedBox(
                                                            width: width * 0.2,
                                                          ),
                                                          DropdownButton(
                                                              value: tacticinfo
                                                                  .spacing,
                                                              items: spacelist
                                                                  .map((value) {
                                                                return DropdownMenuItem(
                                                                  value: value,
                                                                  child: Text(
                                                                      value,
                                                                      style:
                                                                          const TextStyle(
                                                                        fontFamily:
                                                                            'Simple',
                                                                        color: Colors
                                                                            .black,
                                                                      )),
                                                                );
                                                              }).toList(),
                                                              onChanged:
                                                                  (value) {
                                                                setState1(() {
                                                                  tacticinfo
                                                                          .spacing =
                                                                      value!;
                                                                  savetactic(
                                                                      appdata,
                                                                      tacticinfo);
                                                                });
                                                              })
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          const Text('슛 빈도',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Simple',
                                                                color: Colors
                                                                    .black,
                                                              )),
                                                          SizedBox(
                                                            width: width * 0.15,
                                                          ),
                                                          dropdownmenu(
                                                              tacticinfo
                                                                  .shotfrequency,
                                                              shotlist,
                                                              (value) {
                                                            setState1(() {
                                                              tacticinfo
                                                                      .shotfrequency =
                                                                  value!;
                                                              savetactic(
                                                                  appdata,
                                                                  tacticinfo);
                                                            });
                                                          })
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          const Text('압박 강도',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Simple',
                                                                color: Colors
                                                                    .black,
                                                              )),
                                                          SizedBox(
                                                            width: width * 0.15,
                                                          ),
                                                          dropdownmenu(
                                                              tacticinfo
                                                                  .pressure,
                                                              pressurelist,
                                                              (value) {
                                                            setState1(() {
                                                              tacticinfo
                                                                      .pressure =
                                                                  value!;
                                                              savetactic(
                                                                  appdata,
                                                                  tacticinfo);
                                                            });
                                                          })
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          const Text('공격 방향',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Simple',
                                                                color: Colors
                                                                    .black,
                                                              )),
                                                          SizedBox(
                                                            width: width * 0.2,
                                                          ),
                                                          dropdownmenu(
                                                              tacticinfo
                                                                  .attackdirection,
                                                              directionlist,
                                                              (value) {
                                                            setState1(() {
                                                              tacticinfo
                                                                      .attackdirection =
                                                                  value!;
                                                              savetactic(
                                                                  appdata,
                                                                  tacticinfo);
                                                            });
                                                          })
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          const Text('패스 길이',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Simple',
                                                                color: Colors
                                                                    .black,
                                                              )),
                                                          SizedBox(
                                                            width: width * 0.12,
                                                          ),
                                                          dropdownmenu(
                                                              tacticinfo
                                                                  .passdistance,
                                                              passlist,
                                                              (value) {
                                                            setState1(() {
                                                              tacticinfo
                                                                      .passdistance =
                                                                  value!;
                                                              savetactic(
                                                                  appdata,
                                                                  tacticinfo);
                                                            });
                                                          })
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        tacticinfo.name =
                                                            tacticNameController
                                                                .text;
                                                        tacticinfo.simpleInfo =
                                                            tacticInfoController
                                                                .text;
                                                        savetactic(appdata,
                                                            tacticinfo);
                                                      });
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text('확인',
                                                        style: TextStyle(
                                                          fontFamily: 'Simple',
                                                          color: Colors.black,
                                                        )),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                      );
                                    })
                              ],
                            ))),
                ],
              ),
            ),
          );
        }),
      );
    });
  }
}

// ignore: must_be_immutable
class MoveableStackItem extends StatefulWidget {
  MoveableItem moveableitem;
  int index;
  double parentwidth;
  double parentheight;
  final Function refresh;

  MoveableStackItem(this.moveableitem, this.index, this.parentwidth,
      this.parentheight, this.refresh);

  @override
  State<StatefulWidget> createState() {
    return _MoveableStackItemState(
        moveableitem, index, parentwidth, parentheight, refresh);
  }
}

class _MoveableStackItemState extends State<MoveableStackItem> {
  MoveableItem moveableitem;
  int index;
  double parentwidth;
  double parentheight;
  final Function refresh;
  TextEditingController numbercontroller = TextEditingController();
  TextEditingController tacticmemocontroller = TextEditingController();
  List<int> numberList = List<int>.generate(100, (index) => index);
  Map<String, List<String>> movementList = {
    'backposition': ['없음', '공격 가담', '후방 대기'],
    'leftsideback': ['없음', '공격 가담', '후방 대기', '안쪽 침투'],
    'rightsideback': ['없음', '공격 가담', '후방 대기', '안쪽 침투'],
    'leftwinger': ['없음', '전방 침투', '안쪽 침투', '빌드업 관여'],
    'rightwinger': ['없음', '전방 침투', '안쪽 침투', '빌드업 관여'],
    'centerforward': ['없음', '최전방 침투', '사선 침투', '빌드업 관여'],
    'attackingmidfielder': ['없음', '전방 침투', '사선 침투', '빌드업 관여']
  };
  Map<String, List<String>> roleList = {
    'GK': ['없음', '스위퍼 키퍼', '클래식 골키퍼'],
    'CB': ['없음', '볼플레잉 수비수', '중앙 수비수', '안정형 수비수', '리베로'],
    'FB': ['없음', '완성형 윙백', '인버티드 윙백', '안정형 풀백', '풀백', '윙백'],
    'DM': ['없음', '앵커', '딥라잉 플레이메이커', '수비형 미드필더', '하프백', '레지스타'],
    'CM': [
      '없음',
      '볼위닝 미드필더',
      '박스투박스 미드필더',
      '중앙 미드필더',
      '메짤라',
      '로밍 플레이메이커',
      '와이드 미드필더'
    ],
    'AM': ['없음', '전진형 플레이메이커', '공격형 미드필더', '트레콰니스타'],
    'WF': ['없음', '인사이드 포워드', '인버티드 윙어', '클래식 윙어', '수비형 윙어'],
    'CF': [
      '없음',
      '전진형 포워드',
      '완성형 포워드',
      '딥라잉 포워드',
      '펄스 나인',
      '포쳐',
      '압박형 포워드',
      '쉐도우 스트라이커',
      '타겟형 포워드'
    ]
  };
  AppViewModel appdata = Get.find();

  _MoveableStackItemState(this.moveableitem, this.index, this.parentwidth,
      this.parentheight, this.refresh);

  @override
  void initState() {
    super.initState();
    tacticmemocontroller.text = moveableitem.memo;
  }

  double _getNewXPosition(
      double dx, double maxX, double minX, double xPosition) {
    double newXPosition = xPosition + dx;
    if (newXPosition < 0) {
      newXPosition = 0;
    } else if (newXPosition > maxX) {
      newXPosition = maxX;
    } else if (newXPosition < minX) {
      newXPosition = minX;
    }
    return (newXPosition + dx) / parentwidth;
  }

  double _getNewYPosition(double dy, double maxY, double yPosition) {
    double newYPosition = yPosition + dy;
    if (newYPosition < 0) {
      newYPosition = 0;
    } else if (newYPosition > maxY) {
      newYPosition = maxY;
    }
    return (newYPosition + dy) / parentheight;
  }

  String setMovementByRole(String role) {
    String resultPosition = '없음';
    if (role == '완성형 윙백' || role == '리베로' || role == '메짤라') {
      resultPosition = '공격 가담';
    }
    if (role == '전진형 포워드' || role == '압박형 포워드') {
      resultPosition = '최전방 침투';
    }
    if (role == '인사이드 포워드' || role == '인버티드 윙어' || role == '인버티드 윙백') {
      resultPosition = '안쪽 침투';
    }
    if (role == '하프백' || role == '안정형 풀백' || role == '안정형 수비수') {
      resultPosition = '후방 대기';
    }
    return resultPosition;
  }

  void updatenumber(int newValue) {
    setState(() {
      moveableitem.number = newValue;
    });
  }

  void updatemovement(String newValue) {
    setState(() {
      moveableitem.movement = newValue;
    });
  }

  MoveableItem refreshItem(MoveableItem item) {
    MoveableItem result = MoveableItem(
        memo: '',
        number: 0,
        movement: '없음',
        position: item.position,
        role: '없음',
        userEmail: '',
        xPosition: item.xPosition,
        yPosition: item.yPosition);
    return result;
  }

  String setposition(double xPosition, double yPosition) {
    String position = '';
    if ((xPosition >= 0.23 && xPosition <= 0.65) &&
        (yPosition >= 0.38 && yPosition < 0.52)) {
      position = 'CB';
    }
    if (((xPosition > 0.03 && xPosition < 0.23) &&
            (yPosition > 0.31 && yPosition < 0.52)) ||
        (xPosition > 0.65 && xPosition <= 0.85) &&
            (yPosition > 0.31 && yPosition <= 0.52)) {
      position = 'FB';
    }
    if ((xPosition >= 0.23 && xPosition <= 0.65) &&
        (yPosition >= 0.3 && yPosition < 0.38)) {
      position = 'DM';
    }
    if ((xPosition >= 0.03 && xPosition <= 0.85) &&
        (yPosition >= 0.2 && yPosition < 0.3)) {
      position = 'CM';
    }
    if ((xPosition >= 0.28 && xPosition <= 0.6) &&
        (yPosition >= 0.12 && yPosition <= 0.21)) {
      position = 'AM';
    }
    if (((xPosition > 0.03 && xPosition < 0.28) &&
            (yPosition >= 0.01 && yPosition < 0.2)) ||
        (xPosition > 0.6 && xPosition <= 0.85) &&
            (yPosition >= 0.01 && yPosition < 0.2)) {
      position = 'WF';
    }
    if ((xPosition >= 0.28 && xPosition <= 0.6) &&
        (yPosition >= 0.01 && yPosition < 0.12)) {
      position = 'CF';
    }
    return position;
  }

  String setmovement(double xPosition, double yPosition) {
    String position = '';
    if (yPosition >= 0.2) {
      position = 'backposition';
    }
    if (((xPosition > 0.03 && xPosition < 0.23) &&
        (yPosition > 0.31 && yPosition < 0.52))) {
      position = 'leftsideback';
    }
    if ((xPosition > 0.65 && xPosition <= 0.85) &&
        (yPosition > 0.31 && yPosition <= 0.52)) {
      position = 'rightsideback';
    }
    if (xPosition >= 0.28 &&
        xPosition <= 0.6 &&
        (yPosition > 0.12 && yPosition < 0.2)) {
      position = 'attackingmidfielder';
    }
    if (xPosition > 0.03 && xPosition < 0.28 && yPosition < 0.2) {
      position = 'leftwinger';
    }
    if (xPosition > 0.6 && xPosition < 0.85 && yPosition < 0.2) {
      position = 'rightwinger';
    }
    if (xPosition >= 0.28 && xPosition <= 0.6 && yPosition < 0.12) {
      position = 'centerforward';
    }
    return position;
  }

  Widget movementWidget(String movement, String position) {
    if (movement == '전방 침투' || movement == '공격 가담' || movement == '최전방 침투') {
      return Image.asset(
        'assets/arrow/uparrow.png',
        fit: BoxFit.cover,
      );
    }
    if (movement == '후방 대기' || movement == '빌드업 관여') {
      return Image.asset(
        'assets/arrow/downarrow.png',
        fit: BoxFit.cover,
      );
    }
    if (movement == '사선 침투') {
      return Image.asset(
        'assets/arrow/doublearrow.png',
        fit: BoxFit.fill,
      );
    }
    if (movement == '안쪽 침투') {
      if (position == 'leftwinger' || position == 'leftsideback') {
        return Image.asset(
          'assets/arrow/uprightarrow.png',
          fit: BoxFit.fill,
        );
      }
      if (position == 'rightwinger' || position == 'rightsideback') {
        return Image.asset(
          'assets/arrow/upleftarrow.png',
          fit: BoxFit.fill,
        );
      }
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    double xPosition = moveableitem.xPosition * parentwidth;
    double yPosition = moveableitem.yPosition * parentheight;
    return GetBuilder(builder: (AppViewModel appdata) {
      return Positioned(
        top: yPosition,
        left: xPosition,
        child: FutureBuilder(
            future: userController.getuserdataToemail(moveableitem.userEmail),
            builder: (context, snapshot) {
              MyInfo? usermodel = snapshot.data;
              return DragTarget(
                builder: (
                  BuildContext context,
                  List<dynamic> accepted,
                  List<dynamic> rejected,
                ) {
                  return GestureDetector(
                    onPanUpdate: (moveableitem.xPosition == 0.45 &&
                            moveableitem.yPosition == 0.51)
                        ? null
                        : (tapInfo) {
                            setState(() {
                              double newXPosition = _getNewXPosition(
                                  tapInfo.delta.dx,
                                  width * 0.85,
                                  width * 0.03,
                                  xPosition);

                              double newYPosition = _getNewYPosition(
                                  tapInfo.delta.dy, height * 0.52, yPosition);

                              moveableitem.xPosition = newXPosition;
                              moveableitem.yPosition = newYPosition;
                              moveableitem.position =
                                  setposition(newXPosition, newYPosition);

                              appdata.squadmodel.playerlist[index] =
                                  moveableitem;
                            });
                          },
                    onTap: () {
                      appdata.istacticSwitch && moveableitem.position != 'GK'
                          ? showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return StatefulBuilder(builder:
                                    (BuildContext context,
                                        StateSetter setState) {
                                  return AlertDialog(
                                    title: const Text('전술 정보'),
                                    content: SizedBox(
                                      height: parentheight * 0.35,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            SizedBox(height: height * 0.01),
                                            const Text("포지션"),
                                            SizedBox(height: height * 0.01),
                                            Text(moveableitem.position),
                                            SizedBox(height: height * 0.04),
                                            const Text("전술 역할"),
                                            SizedBox(height: height * 0.01),
                                            DropdownButton(
                                                value: moveableitem.role,
                                                items: roleList[
                                                        moveableitem.position]!
                                                    .map((value) {
                                                  return DropdownMenuItem(
                                                    value: value,
                                                    child: Text(value),
                                                  );
                                                }).toList(),
                                                onChanged: (String? value) {
                                                  setState(() {
                                                    moveableitem.role = value!;
                                                    moveableitem.movement =
                                                        setMovementByRole(
                                                            value);
                                                    updatemovement(
                                                        setMovementByRole(
                                                            value));
                                                    appdata.squadmodel
                                                            .playerlist[index] =
                                                        moveableitem;
                                                  });
                                                }),
                                            SizedBox(height: height * 0.04),
                                            const Text("움직임"),
                                            SizedBox(height: height * 0.01),
                                            DropdownButton(
                                                value: moveableitem.movement,
                                                items: movementList[setmovement(
                                                        moveableitem.xPosition,
                                                        moveableitem
                                                            .yPosition)]!
                                                    .map((value) {
                                                  return DropdownMenuItem(
                                                    value: value,
                                                    child: Text(value),
                                                  );
                                                }).toList(),
                                                onChanged: (String? value) {
                                                  setState(() {
                                                    moveableitem.movement =
                                                        value!;
                                                    appdata.squadmodel
                                                            .playerlist[index] =
                                                        moveableitem;
                                                    updatemovement(value);
                                                  });
                                                }),
                                            SizedBox(height: height * 0.04),
                                            const Text("메모"),
                                            TextField(
                                              controller: tacticmemocontroller,
                                              onChanged: (value) {},
                                            ),
                                            SizedBox(height: height * 0.01),
                                            Text(moveableitem.memo),
                                          ],
                                        ),
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          '확인',
                                          style: TextStyle(
                                              fontFamily: 'Simple',
                                              fontSize: width * 0.05,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  );
                                });
                              },
                            )
                          : showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return StatefulBuilder(builder:
                                    (BuildContext context,
                                        StateSetter setState) {
                                  return AlertDialog(
                                    title: const Text('선수 정보'),
                                    content: SizedBox(
                                      height: parentheight * 0.35,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            const Text("이름"),
                                            SizedBox(height: height * 0.01),
                                            Text(usermodel?.name ?? ''),
                                            SizedBox(height: height * 0.04),
                                            const Text("닉네임"),
                                            SizedBox(height: height * 0.01),
                                            Text(usermodel?.nickname ?? ''),
                                            SizedBox(height: height * 0.04),
                                            const Text("포지션"),
                                            SizedBox(height: height * 0.01),
                                            Text(moveableitem.position),
                                            SizedBox(height: height * 0.04),
                                            const Text("등번호"),
                                            SizedBox(height: height * 0.01),
                                            DropdownButton<int>(
                                              value: moveableitem.number,
                                              onChanged: (int? newValue) {
                                                if (newValue != null) {
                                                  setState(() {
                                                    moveableitem.number =
                                                        newValue;
                                                    updatenumber(newValue);
                                                    appdata.squadmodel
                                                            .playerlist[index] =
                                                        moveableitem;
                                                  });
                                                }
                                              },
                                              items: numberList
                                                  .map<DropdownMenuItem<int>>(
                                                      (int value) {
                                                return DropdownMenuItem<int>(
                                                  value: value,
                                                  child: Text(value.toString()),
                                                );
                                              }).toList(),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          if (usermodel != null) {
                                            setState(() {
                                              moveableitem =
                                                  refreshItem(moveableitem);
                                              appdata.squadmodel
                                                      .playerlist[index] =
                                                  moveableitem;
                                              appdata.squadmodel.userlist
                                                  .add(usermodel.uid);
                                              refresh();
                                            });
                                          } else {
                                            toastMessage('선수가 없습니다.');
                                          }
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          '초기화',
                                          style: TextStyle(
                                              fontFamily: 'Simple',
                                              fontSize: width * 0.04,
                                              color: Colors.black),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          '확인',
                                          style: TextStyle(
                                              fontFamily: 'Simple',
                                              fontSize: width * 0.04,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  );
                                });
                              },
                            );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Visibility(
                          visible: appdata.istacticSwitch,
                          child: moveableitem.position == 'GK'
                              ? Container()
                              : SizedBox(
                                  width: width * 0.06,
                                  height: height * 0.025,
                                  child: movementWidget(
                                      moveableitem.movement,
                                      setmovement(moveableitem.xPosition,
                                          moveableitem.yPosition))),
                        ),
                        SizedBox(
                          height: height * 0.005,
                        ),
                        Stack(children: [
                          Container(
                            padding: EdgeInsets.zero,
                            width: width * 0.105,
                            height: height * 0.06,
                            child: Image.asset(
                              "assets/uniform.png",
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                              top: height * 0.015,
                              left: width * 0.028,
                              child: SizedBox(
                                width: width * 0.05,
                                child: Text(
                                  moveableitem.number == 0
                                      ? ''
                                      : moveableitem.number.toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: 'Simple',
                                      fontSize: width * 0.05),
                                ),
                              ))
                        ]),
                        Container(
                          padding: EdgeInsets.zero,
                          width: width * 0.105,
                          height: height * 0.025,
                          child: Text(
                            usermodel?.name ?? '',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'Simple', fontSize: width * 0.025),
                          ),
                        )
                      ],
                    ),
                  );
                },
                onWillAccept: (MyInfo? data) {
                  return true;
                },
                onAccept: (MyInfo data) {
                  setState(() {
                    moveableitem.userEmail = data.email;
                    appdata.squadmodel.playerlist[index] = moveableitem;
                    appdata.squadmodel.userlist.remove(data.uid);
                  });
                },
              );
            }),
      );
    });
  }
}
