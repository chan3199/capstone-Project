import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squad_makers/controller/club_controller.dart';
import 'package:squad_makers/controller/squad_controller.dart';
import 'package:squad_makers/controller/user_controller.dart';
import 'package:squad_makers/model/moveableitem_model.dart';
import 'package:squad_makers/model/myinfo.dart';
import 'package:squad_makers/model/tactic_model.dart';
import 'package:squad_makers/utils/loding.dart';
import 'package:squad_makers/view_model/app_view_model.dart';

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
      theme: CupertinoThemeData(brightness: Brightness.dark),
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

  Widget dropdownmenu(value, List<String> list, func) {
    return DropdownButton(
        value: value,
        items: list.map((value) {
          return DropdownMenuItem(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: func);
  }

  void savetactic(AppViewModel appdata, TacticInfo tacticinfo) {
    appdata.squadmodel.tacticsinfo = tacticinfo.toJson();
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
                .add(MoveableStackItem(msimodel, i, width, height));
          }
          return Scaffold(
            appBar: AppBar(
                backgroundColor: Color(0x805EA152),
                centerTitle: true,
                title: Text(
                  appdata.squadmodel.squadname,
                  style: TextStyle(
                    color: Colors.black,
                  ),
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
                            child: Text('저장'),
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
                      // Positioned(
                      //     top: height * 0.21,
                      //     left: width * 0.28,
                      //     child: Container(
                      //       width: width * 0.12,
                      //       height: height * 0.07,
                      //       child: Image.asset(
                      //         "assets/uniform.png",
                      //         fit: BoxFit.cover,
                      //       ),
                      //     )),
                      // Positioned(
                      //     top: height * 0.01,
                      //     left: width * 0.6,
                      //     child: Container(
                      //       width: width * 0.12,
                      //       height: height * 0.07,
                      //       child: Image.asset(
                      //         "assets/uniform.png",
                      //         fit: BoxFit.cover,
                      //       ),
                      //     )),
                      // Positioned(
                      //     top: height * 0.12,
                      //     left: width * 0.6,
                      //     child: Container(
                      //       width: width * 0.12,
                      //       height: height * 0.07,
                      //       child: Image.asset(
                      //         "assets/uniform.png",
                      //         fit: BoxFit.cover,
                      //       ),
                      //     )),
                      // Positioned(
                      //     top: height * 0.12,
                      //     left: width * 0.28,
                      //     child: Container(
                      //       width: width * 0.12,
                      //       height: height * 0.07,
                      //       child: Image.asset(
                      //         "assets/uniform.png",
                      //         fit: BoxFit.cover,
                      //       ),
                      //     )),
                      ...moveableitemWidgets
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
                              backgroundColor: Color(0x805EA152),
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(0)),
                              ),
                              side: BorderSide(
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
                              backgroundColor: Color(0x805EA152),
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(0)),
                              ),
                              side: BorderSide(
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
                                  return Text('오류가 발생했습니다.');
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
                                                title: Text('선수 정보'),
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
                                                    child: Text('닫기'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        clubuser.name = '';
                                                      });
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text('정보 초기화'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child: Draggable<MyInfo>(
                                          data: clubuser,
                                          feedback: SizedBox(
                                            width: width * 0.12,
                                            height: height * 0.07,
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
                                                    fontSize: width * 0.02),
                                              )),
                                            ],
                                          ),
                                          onDragEnd: (details) {
                                            setState(() {});
                                          },
                                        ),
                                      );
                                    },
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2),
                                  );
                                }
                              })
                          : SingleChildScrollView(
                              child: Column(
                              children: [
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (tacticinfo.name == '')
                                        Container(
                                          width: width * 0.3,
                                          height: height * 0.05,
                                          alignment: Alignment.center,
                                          child: Text('전술 이름',
                                              style: TextStyle(
                                                fontSize: width * 0.05,
                                                fontFamily: 'Simple',
                                                color: Colors.black,
                                              )),
                                        )
                                      else
                                        Text(tacticinfo.name),
                                    ]),
                                Text('전술 간단 설명',
                                    style: TextStyle(
                                      fontSize: width * 0.04,
                                      fontFamily: 'Simple',
                                      color: Colors.black,
                                    )),
                                SizedBox(
                                  height: height * 0.01,
                                ),
                                Text(tacticinfo.simpleInfo,
                                    style: TextStyle(
                                      fontSize: width * 0.04,
                                      fontFamily: 'Simple',
                                      color: Colors.black,
                                    )),
                                SizedBox(
                                  height: height * 0.01,
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
                                                title: Text('전술 편집'),
                                                content: SingleChildScrollView(
                                                  child: Column(
                                                    children: [
                                                      Text('전술 이름 편집'),
                                                      TextFormField(
                                                        controller:
                                                            tacticNameController,
                                                        onChanged: (value) {
                                                          setState1(() {
                                                            tacticinfo.name =
                                                                value;
                                                            savetactic(appdata,
                                                                tacticinfo);
                                                          });
                                                        },
                                                      ),
                                                      SizedBox(
                                                          height:
                                                              height * 0.05),
                                                      Text('전술 간단 설명 편집'),
                                                      TextFormField(
                                                        controller:
                                                            tacticInfoController,
                                                        onChanged: (value) {
                                                          setState1(() {
                                                            tacticinfo
                                                                    .simpleInfo =
                                                                value;
                                                            savetactic(appdata,
                                                                tacticinfo);
                                                          });
                                                        },
                                                      ),
                                                      SizedBox(
                                                          height:
                                                              height * 0.05),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text('수비 라인'),
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
                                                                      value),
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
                                                          Text('선수 간격'),
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
                                                                      value),
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
                                                          Text('슛 빈도'),
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
                                                          Text('압박 강도'),
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
                                                          Text('공격 방향'),
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
                                                        children: [
                                                          Text('패스 길이'),
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
                                                    child: Text('확인'),
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

  MoveableStackItem(
      this.moveableitem, this.index, this.parentwidth, this.parentheight);

  @override
  State<StatefulWidget> createState() {
    return _MoveableStackItemState(
        moveableitem, index, parentwidth, parentheight);
  }
}

class _MoveableStackItemState extends State<MoveableStackItem> {
  MoveableItem moveableitem;
  int index;
  double parentwidth;
  double parentheight;
  TextEditingController numbercontroller = TextEditingController();
  List<int> numberList = List<int>.generate(100, (index) => index);
  AppViewModel appdata = Get.find();

  _MoveableStackItemState(
      this.moveableitem, this.index, this.parentwidth, this.parentheight);

  @override
  void initState() {
    super.initState();
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
    return newXPosition / parentwidth;
  }

  double _getNewYPosition(double dy, double maxY, double yPosition) {
    double newYPosition = yPosition + dy;
    if (newYPosition < 0) {
      newYPosition = 0;
    } else if (newYPosition > maxY) {
      newYPosition = maxY;
    }
    return newYPosition / parentheight;
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
                    onPanUpdate: (tapInfo) {
                      setState(() {
                        double newXPosition = _getNewXPosition(tapInfo.delta.dx,
                            width * 0.85, width * 0.03, xPosition);

                        double newYPosition = _getNewYPosition(
                            tapInfo.delta.dy, height * 0.52, yPosition);

                        moveableitem.xPosition = newXPosition;
                        moveableitem.yPosition = newYPosition;

                        appdata.squadmodel.playerlist[index] = moveableitem;
                      });
                    },
                    onTap: () {
                      appdata.istacticSwitch
                          ? showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return StatefulBuilder(builder:
                                    (BuildContext context,
                                        StateSetter setState) {
                                  return AlertDialog(
                                    title: Text('전술 정보'),
                                    content: SizedBox(
                                      height: parentheight * 0.35,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            Text("메모"),
                                            SizedBox(height: height * 0.01),
                                            Text(moveableitem.memo),
                                            SizedBox(height: height * 0.04),
                                            Text("포지션"),
                                            SizedBox(height: height * 0.01),
                                            Text(moveableitem.position),
                                            SizedBox(height: height * 0.04),
                                            // Text("전술 역할"),
                                            // SizedBox(height: height * 0.01),
                                            // Text(moveableitem.position),
                                            // SizedBox(height: height * 0.04),
                                            // Text("움직임"),
                                            // SizedBox(height: height * 0.01),
                                            // DropdownButton<int>(
                                            //   value: moveableitem.number,
                                            //   onChanged: (int? newValue) {
                                            //     if (newValue != null) {
                                            //       setState(() {
                                            //         moveableitem.number = newValue;
                                            //         appdata.squadmodel
                                            //                 .playerlist[index] =
                                            //             moveableitem;
                                            //       });
                                            //     }
                                            //   },
                                            //   items: numberList
                                            //       .map<DropdownMenuItem<int>>(
                                            //           (int value) {
                                            //     return DropdownMenuItem<int>(
                                            //       value: value,
                                            //       child: Text(value.toString()),
                                            //     );
                                            //   }).toList(),
                                            // )
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
                                          '닫기',
                                          style: TextStyle(
                                              fontFamily: 'Simple',
                                              fontSize: width * 0.03,
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
                                    title: Text('선수 정보'),
                                    content: SizedBox(
                                      height: parentheight * 0.35,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            Text("이름"),
                                            SizedBox(height: height * 0.01),
                                            Text(usermodel?.name ?? ''),
                                            SizedBox(height: height * 0.04),
                                            Text("닉네임"),
                                            SizedBox(height: height * 0.01),
                                            Text(usermodel?.nickname ?? ''),
                                            SizedBox(height: height * 0.04),
                                            Text("포지션"),
                                            SizedBox(height: height * 0.01),
                                            Text(moveableitem.position),
                                            SizedBox(height: height * 0.04),
                                            Text("등번호"),
                                            SizedBox(height: height * 0.01),
                                            DropdownButton<int>(
                                              value: moveableitem.number,
                                              onChanged: (int? newValue) {
                                                if (newValue != null) {
                                                  setState(() {
                                                    moveableitem.number =
                                                        newValue;
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
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          '닫기',
                                          style: TextStyle(
                                              fontFamily: 'Simple',
                                              fontSize: width * 0.03,
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
                      children: [
                        Container(
                          padding: EdgeInsets.zero,
                          width: width * 0.12,
                          height: height * 0.07,
                          child: Image.asset(
                            "assets/uniform.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.zero,
                          width: width * 0.1,
                          height: height * 0.02,
                          child: Text(
                            usermodel?.name ?? '',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 10),
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
