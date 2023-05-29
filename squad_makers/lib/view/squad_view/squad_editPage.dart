import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squad_makers/controller/database_controller.dart';
import 'package:squad_makers/model/moveableitem_model.dart';
import 'package:squad_makers/model/myinfo.dart';
import 'package:squad_makers/model/squad_model.dart';
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
    return LayoutBuilder(builder: (context, constraints) {
      var width = MediaQuery.of(context).size.width;
      var height = MediaQuery.of(context).size.height;
      AppViewModel appdata = Get.find();
      return Scaffold(
        appBar: AppBar(
            backgroundColor: Color(0x805EA152),
            title: Text(
              'squad',
              style: TextStyle(
                color: Colors.black,
              ),
            )),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FutureBuilder<SquadModel>(
                  future: databasecontroller.getsquadinfo(
                      appdata.clubModel.name, appdata.squadname),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(child: Text('오류가 발생했습니다.'));
                    } else if (snapshot.data == null) {
                      return Container();
                    } else {
                      print(snapshot.data);
                      return Stack(
                        children: [
                          Image.asset(
                            "assets/field.png",
                            fit: BoxFit.fill,
                            width: width,
                            height: height * 0.6,
                          ),
                        ],
                      );
                    }
                  }),
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
                            borderRadius: BorderRadius.all(Radius.circular(0)),
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
                            borderRadius: BorderRadius.all(Radius.circular(0)),
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
    });
  }
}

class MoveableStackItem extends StatefulWidget {
  final String userEmail;
  final double xPosition;
  final double yPosition;
  final String number;
  final String movement;
  final String role;

  MoveableStackItem(this.userEmail, this.xPosition, this.yPosition, this.number,
      this.movement, this.role);

  @override
  State<StatefulWidget> createState() {
    return _MoveableStackItemState(this.xPosition, this.yPosition);
  }
}

class _MoveableStackItemState extends State<MoveableStackItem> {
  double xPosition = 0;
  double yPosition = 0;

  String playerName = '';

  _MoveableStackItemState(this.xPosition, this.yPosition);

  double _getNewXPosition(double dx, double maxX) {
    double newXPosition = xPosition + dx;
    if (newXPosition < 0) {
      newXPosition = 0;
    } else if (newXPosition > maxX) {
      newXPosition = maxX;
    }
    return newXPosition;
  }

  double _getNewYPosition(double dy, double maxY) {
    double newYPosition = yPosition + dy;
    if (newYPosition < 0) {
      newYPosition = 0;
    } else if (newYPosition > maxY) {
      newYPosition = maxY;
    }
    return newYPosition;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Positioned(
      top: yPosition,
      left: xPosition,
      child: DragTarget(
        builder: (
          BuildContext context,
          List<dynamic> accepted,
          List<dynamic> rejected,
        ) {
          return GestureDetector(
            onPanUpdate: (tapInfo) {
              setState(() {
                double newXPosition = _getNewXPosition(
                  tapInfo.delta.dx,
                  width - width * 0.15,
                );
                double newYPosition = _getNewYPosition(
                  tapInfo.delta.dy,
                  height * 0.7 - height * 0.1,
                );
                xPosition = newXPosition;
                yPosition = newYPosition;
              });
            },
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('선수 정보'),
                    content: Column(
                      children: [Text(playerName)],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('닫기'),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            playerName = '';
                          });
                          Navigator.of(context).pop();
                        },
                        child: Text('정보 초기화'),
                      ),
                    ],
                  );
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
                    playerName,
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
            playerName = data.name;
          });
        },
      ),
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
        future:
            databasecontroller.getclubuserlist(appdata.clubModel.clubuserlist),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('오류가 발생했습니다.'));
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
                        content: Column(
                          children: [Text(clubuser.name)],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('닫기'),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                clubuser.name = '';
                              });
                              Navigator.of(context).pop();
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
                          title: Text('전술 편집'),
                          content: SingleChildScrollView(
                            child: Column(
                              children: [
                                Text('전술 이름 편집'),
                                TextFormField(
                                  controller: taticNameController,
                                ),
                                Text('전술 간단 설명 편집'),
                                TextFormField(
                                  controller: taticInfoController,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('수비 라인'),
                                    SizedBox(
                                      width: width * 0.2,
                                    ),
                                    DropdownButton(
                                        value: line,
                                        items: linelist.map((value) {
                                          return DropdownMenuItem(
                                            value: value,
                                            child: Text(value),
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
                                    Text('선수 간격'),
                                    SizedBox(
                                      width: width * 0.2,
                                    ),
                                    DropdownButton(
                                        value: space,
                                        items: spacelist.map((value) {
                                          return DropdownMenuItem(
                                            value: value,
                                            child: Text(value),
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
                                    Text('슛 빈도'),
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
                                    Text('압박 강도'),
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
                                    Text('공격 방향'),
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
                                    Text('패스 길이'),
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
                              child: Text('닫기'),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {});
                                Navigator.of(context).pop();
                              },
                              child: Text('정보 초기화'),
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
