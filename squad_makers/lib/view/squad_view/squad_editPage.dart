import 'package:flutter/material.dart';

class SquadEditPage extends StatefulWidget {
  const SquadEditPage({super.key});

  @override
  State<SquadEditPage> createState() => _SquadEditState();
}

class _SquadEditState extends State<SquadEditPage> {
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
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                Image.asset(
                  "assets/field.png",
                  fit: BoxFit.fill,
                  width: width,
                  height: height * 0.7,
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
            Expanded(
              child: Container(
                width: width,
                height: height * 0.25,
              ),
            )
          ],
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
      child: GestureDetector(
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
      ),
    );
  }
}
