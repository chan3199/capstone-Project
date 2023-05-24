import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squad_makers/controller/database_controller.dart';
import 'package:squad_makers/model/myinfo.dart';
import 'package:squad_makers/view_model/app_view_model.dart';

class SquadEditPage extends StatefulWidget {
  const SquadEditPage({super.key});

  @override
  State<SquadEditPage> createState() => _SquadEditState();
}

class _SquadEditState extends State<SquadEditPage> {
  String flag = 'player';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(child: _buildStack(context)),
      ),
    );
  }

  // #docregion Stack
  Widget _buildStack(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      var width = MediaQuery.of(context).size.width;
      var height = constraints.maxHeight;

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
              Stack(
                children: [
                  Image.asset(
                    "assets/field.png",
                    fit: BoxFit.fill,
                    width: width,
                    height: height * 0.6,
                  ),
                  MoveableStackItem(175, 40),
                  MoveableStackItem(175, 320),
                  MoveableStackItem(70, 80),
                  MoveableStackItem(280, 80),
                  MoveableStackItem(135, 200),
                  MoveableStackItem(215, 200),
                  MoveableStackItem(175, 120),
                  MoveableStackItem(70, 230),
                  MoveableStackItem(280, 230),
                  MoveableStackItem(135, 270),
                  MoveableStackItem(215, 270),
                ],
              ),
              // Expanded(
              //   child: Container(
              //     width: width,
              //     height: height * 0.25,
              //   ),
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: height * 0.045,
                    width: width * 0.18,
                    child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Color(0x805EA152),
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
                    width: width * 0.18,
                    child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Color(0x805EA152),
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
                  child: flag == 'player' ? playerList() : Container()),
            ],
          ),
        ),
      );
    });
  }
}

class MoveableStackItem extends StatefulWidget {
  double xPosition = 0;
  double yPosition = 0;

  MoveableStackItem(this.xPosition, this.yPosition, {super.key});

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
                    content: TextField(
                      onChanged: (value) {
                        setState(() {
                          playerName = value;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: '선수 이름',
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
              return Draggable<MyInfo>(
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
                      radius: width * 0.07,
                      backgroundImage: NetworkImage(clubuser.image),
                    ),
                    SizedBox(
                      width: GridWidth,
                      height: GridHeith * 0.01,
                    ),
                    Container(child: Text(clubuser.name)),
                  ],
                ),
              );
            },
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          );
        });
  }
}
