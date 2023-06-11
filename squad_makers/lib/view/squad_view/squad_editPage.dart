import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squad_makers/controller/database_controller.dart';
import 'package:squad_makers/model/moveableitem_model.dart';
import 'package:squad_makers/model/myinfo.dart';
import 'package:squad_makers/utils/loding.dart';
import 'package:squad_makers/view_model/app_view_model.dart';

class SquadEditPage extends StatefulWidget {
  const SquadEditPage({super.key});

  @override
  State<SquadEditPage> createState() => _SquadEditState();
}

class _SquadEditState extends State<SquadEditPage> {
  String? flag;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(child: _buildStack(context)),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    flag = 'player';
  }

  Widget _buildStack(BuildContext context) {
    return GetBuilder(builder: (AppViewModel appdata) {
      return Loading(
        child: LayoutBuilder(builder: (context, constraints) {
          var width = MediaQuery.of(context).size.width;
          var height = MediaQuery.of(context).size.height;
          List<Widget> moveableitemWidgets = [];
          for (int i = 0; i < appdata.squadmodel.playerlist.length; i++) {
            MoveableItem msimodel = appdata.squadmodel.playerlist[i];
            moveableitemWidgets
                .add(MoveableStackItem(msimodel, i, width, height));
          }
          return Scaffold(
            appBar: AppBar(
                backgroundColor: Color(0x805EA152),
                title: Text(
                  appdata.squadTemp.squadname,
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
                        top: height * 0.01,
                        left: width * 0.83,
                        child: Container(
                          width: width * 0.15,
                          height: height * 0.04,
                          child: ElevatedButton(
                            child: Text('저장'),
                            onPressed: () async {
                              appdata.isLoadingScreen = true;
                              await databasecontroller.fetchsquad(
                                  appdata.squadmodel, width, height);
                              appdata.squadTemp = appdata.squadmodel;
                              appdata.isLoadingScreen = false;
                              setState(() {});
                            },
                          ),
                        ),
                      ),
                      Positioned(
                        top: height * 0.01,
                        left: width * 0.65,
                        child: Container(
                          width: width * 0.15,
                          height: height * 0.04,
                          child: ElevatedButton(
                            child: Text('취소'),
                            onPressed: () {
                              appdata.squadmodel = appdata.squadTemp;
                              setState(() {});
                            },
                          ),
                        ),
                      ),
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
                  Container(
                      height: height * 0.25,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Color(0xff5EA152),
                          )),
                      child: flag == 'player' ? playerList() : TaticsBoard()),
                ],
              ),
            ),
          );
        }),
      );
    });
  }
}

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

  double _getNewXPosition(double dx, double maxX, double xPosition) {
    double newXPosition = xPosition + dx;
    if (newXPosition < 0) {
      newXPosition = 0;
    } else if (newXPosition > maxX) {
      newXPosition = maxX;
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
    return Positioned(
      top: yPosition,
      left: xPosition,
      child: FutureBuilder(
          future: databasecontroller.getuserdata(moveableitem.userEmail),
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
                      double newXPosition = _getNewXPosition(
                          tapInfo.delta.dx, width - width * 0.15, xPosition);

                      double newYPosition = _getNewYPosition(tapInfo.delta.dy,
                          height * 0.7 - height * 0.1, yPosition);

                      moveableitem.xPosition = newXPosition;
                      moveableitem.yPosition = newYPosition;
                      print(moveableitem.xPosition.toString() +
                          '-' +
                          moveableitem.yPosition.toString());
                      appdata.squadmodel.playerlist[index] = moveableitem;
                    });
                  },
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return StatefulBuilder(builder:
                            (BuildContext context, StateSetter setState) {
                          return AlertDialog(
                            title: Text('선수 정보'),
                            content: SizedBox(
                              height: parentheight * 0.35,
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
                                  Text("등번호"),
                                  SizedBox(height: height * 0.01),
                                  DropdownButton<int>(
                                    value: moveableitem.number,
                                    onChanged: (int? newValue) {
                                      if (newValue != null) {
                                        setState(() {
                                          moveableitem.number = newValue;
                                          appdata.squadmodel.playerlist[index] =
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
  }
}

class playerList extends StatefulWidget {
  playerList({Key? key}) : super(key: key);

  @override
  State<playerList> createState() => _playerListState();
}

class _playerListState extends State<playerList> {
  @override
  Widget build(BuildContext context) {
    AppViewModel appdata = Get.find();
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return FutureBuilder(
        future: databasecontroller.getclubuserlist(appdata.squadmodel.userlist),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
                child: Text('오류가 발생했습니다.',
                    style:
                        TextStyle(fontFamily: 'Simple', color: Colors.black)));
          } else if (snapshot.data == null) {
            return Container();
          }
          List<dynamic> clubuserlist = snapshot.data!;
          return GridView.builder(
            padding: EdgeInsets.all(width * 0.02),
            scrollDirection: Axis.horizontal,
            itemCount: clubuserlist.length,
            itemBuilder: (BuildContext context, int index) {
              var GridWidth = MediaQuery.of(context).size.width;
              var GridHeith = MediaQuery.of(context).size.height;
              MyInfo clubuser = clubuserlist.elementAt(index);
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
                              Text("이름 : " + clubuser.name,
                                  style: TextStyle(
                                      fontFamily: 'Simple',
                                      fontSize: width * 0.03,
                                      color: Colors.black)),
                              SizedBox(height: height * 0.05),
                              Text("닉네임 : " + clubuser.nickname,
                                  style: TextStyle(
                                      fontFamily: 'Simple',
                                      fontSize: width * 0.03,
                                      color: Colors.black)),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('닫기',
                                style: TextStyle(
                                    fontFamily: 'Simple',
                                    fontSize: width * 0.03,
                                    color: Colors.black)),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                clubuser.name = '';
                              });
                              Navigator.of(context).pop();
                            },
                            child: Text('정보 초기화',
                                style: TextStyle(
                                    fontFamily: 'Simple',
                                    fontSize: width * 0.03,
                                    color: Colors.black)),
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
                        backgroundImage: NetworkImage(clubuser.image),
                      ),
                      SizedBox(
                        width: GridWidth,
                        height: GridHeith * 0.01,
                      ),
                      Container(
                          child: Text(
                        clubuser.name,
                        style: TextStyle(fontSize: width * 0.02),
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
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          );
        });
  }
}

class TaticsBoard extends StatefulWidget {
  TaticsBoard({Key? key}) : super(key: key);

  @override
  State<TaticsBoard> createState() => _TaticsBoardState();
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

class _TaticsBoardState extends State<TaticsBoard> {
  final taticNameController = TextEditingController();
  final taticInfoController = TextEditingController();
  String line = '높게';
  final linelist = ['높게', '낮게'];
  String space = '넓게';
  final spacelist = ['넓게', '좁게'];
  String shot = '신중하게';
  final shotlist = ['신중하게', '빈번하게'];
  String pressure = '강하게';
  final pressurelist = ['강하게', '약하게'];
  String direction = '중앙';
  final directionlist = ['중앙', '측면'];
  String pass = '짧은 패스';
  final passlist = ['짧은 패스', '긴 패스'];
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
        child: Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          if (taticNameController.text == '')
            Text('전술 이름',
                style: TextStyle(
                  fontSize: width * 0.05,
                  fontFamily: 'Simple',
                  color: Colors.black,
                ))
          else
            Text(taticNameController.text),
          SizedBox(
            width: width * 0.3,
          ),
          TextButton(
              child: Text('편집',
                  style: TextStyle(
                    fontSize: width * 0.05,
                    fontFamily: 'Simple',
                    color: Colors.black,
                  )),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState1) {
                        return AlertDialog(
                          title: Text('전술 편집',
                              style: TextStyle(
                                  fontFamily: 'Simple',
                                  fontSize: width * 0.03,
                                  color: Colors.black)),
                          content: SingleChildScrollView(
                            child: Column(
                              children: [
                                Text('전술 이름 편집',
                                    style: TextStyle(
                                        fontFamily: 'Simple',
                                        fontSize: width * 0.03,
                                        color: Colors.black)),
                                TextFormField(
                                  controller: taticNameController,
                                ),
                                SizedBox(height: height * 0.05),
                                Text('전술 간단 설명 편집',
                                    style: TextStyle(
                                        fontFamily: 'Simple',
                                        fontSize: width * 0.03,
                                        color: Colors.black)),
                                TextFormField(
                                    controller: taticInfoController,
                                    style: TextStyle(
                                        fontFamily: 'Simple',
                                        fontSize: width * 0.03,
                                        color: Colors.black)),
                                SizedBox(height: height * 0.05),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('수비 라인',
                                        style: TextStyle(
                                            fontFamily: 'Simple',
                                            fontSize: width * 0.03,
                                            color: Colors.black)),
                                    SizedBox(
                                      width: width * 0.2,
                                    ),
                                    DropdownButton(
                                        value: line,
                                        items: linelist.map((value) {
                                          return DropdownMenuItem(
                                            value: value,
                                            child: Text(value,
                                                style: TextStyle(
                                                    fontFamily: 'Simple',
                                                    fontSize: width * 0.03,
                                                    color: Colors.black)),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          setState1(() {
                                            line = value!;
                                          });
                                          setState(() {
                                            line = value!;
                                          });
                                        })
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('선수 간격',
                                        style: TextStyle(
                                            fontFamily: 'Simple',
                                            fontSize: width * 0.03,
                                            color: Colors.black)),
                                    SizedBox(
                                      width: width * 0.2,
                                    ),
                                    DropdownButton(
                                        value: space,
                                        items: spacelist.map((value) {
                                          return DropdownMenuItem(
                                            value: value,
                                            child: Text(value,
                                                style: TextStyle(
                                                    fontFamily: 'Simple',
                                                    fontSize: width * 0.03,
                                                    color: Colors.black)),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          setState1(() {
                                            space = value!;
                                          });
                                          setState(() {
                                            space = value!;
                                          });
                                        })
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('슛 빈도',
                                        style: TextStyle(
                                            fontFamily: 'Simple',
                                            fontSize: width * 0.03,
                                            color: Colors.black)),
                                    SizedBox(
                                      width: width * 0.15,
                                    ),
                                    dropdownmenu(shot, shotlist, (value) {
                                      setState1(() {
                                        shot = value!;
                                      });
                                      setState(() {
                                        shot = value!;
                                      });
                                    })
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('압박 강도',
                                        style: TextStyle(
                                            fontFamily: 'Simple',
                                            fontSize: width * 0.03,
                                            color: Colors.black)),
                                    SizedBox(
                                      width: width * 0.15,
                                    ),
                                    dropdownmenu(pressure, pressurelist,
                                        (value) {
                                      setState1(() {
                                        pressure = value!;
                                      });
                                      setState(() {
                                        pressure = value!;
                                      });
                                    })
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('공격 방향',
                                        style: TextStyle(
                                            fontFamily: 'Simple',
                                            fontSize: width * 0.03,
                                            color: Colors.black)),
                                    SizedBox(
                                      width: width * 0.2,
                                    ),
                                    dropdownmenu(direction, directionlist,
                                        (value) {
                                      setState1(() {
                                        direction = value!;
                                      });
                                      setState(() {
                                        direction = value!;
                                      });
                                    })
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('패스 길이',
                                        style: TextStyle(
                                            fontFamily: 'Simple',
                                            fontSize: width * 0.03,
                                            color: Colors.black)),
                                    SizedBox(
                                      width: width * 0.12,
                                    ),
                                    dropdownmenu(pass, passlist, (value) {
                                      setState1(() {
                                        pass = value!;
                                      });
                                      setState(() {
                                        pass = value!;
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
                                Navigator.of(context).pop();
                              },
                              child: Text('닫기',
                                  style: TextStyle(
                                      fontFamily: 'Simple',
                                      fontSize: width * 0.03,
                                      color: Colors.black)),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {});
                                Navigator.of(context).pop();
                              },
                              child: Text('정보 초기화',
                                  style: TextStyle(
                                      fontFamily: 'Simple',
                                      fontSize: width * 0.03,
                                      color: Colors.black)),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              }),
        ]),
        Text('전술 간단 설명',
            style: TextStyle(
              fontSize: width * 0.05,
              fontFamily: 'Simple',
              color: Colors.black,
            )),
        SizedBox(
          height: height * 0.001,
        ),
        Text(taticInfoController.text,
            style: TextStyle(
              fontSize: width * 0.04,
              fontFamily: 'Simple',
              color: Colors.black,
            )),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('수비 라인 : ' + line,
                style: TextStyle(
                  fontSize: width * 0.04,
                  fontFamily: 'Simple',
                  color: Colors.black,
                )),
            Text('선수 간격 : ' + space,
                style: TextStyle(
                  fontSize: width * 0.04,
                  fontFamily: 'Simple',
                  color: Colors.black,
                )),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('슈팅 빈도 : ' + shot,
                style: TextStyle(
                  fontSize: width * 0.04,
                  fontFamily: 'Simple',
                  color: Colors.black,
                )),
            Text('압박 강도 : ' + pressure,
                style: TextStyle(
                  fontSize: width * 0.04,
                  fontFamily: 'Simple',
                  color: Colors.black,
                )),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('공격 방향 : ' + direction,
                style: TextStyle(
                  fontSize: width * 0.04,
                  fontFamily: 'Simple',
                  color: Colors.black,
                )),
            Text('패스 길이 : ' + pass,
                style: TextStyle(
                  fontSize: width * 0.04,
                  fontFamily: 'Simple',
                  color: Colors.black,
                ))
          ],
        ),
      ],
    ));
  }
}
