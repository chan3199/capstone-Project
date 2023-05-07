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
            title: Text(
          'squad',
          style: TextStyle(
            color: Colors.black,
          ),
        )),
        body: Column(
          children: [
            Stack(
              children: [
                Image.asset(
                  "assets/field.png",
                  fit: BoxFit.fill,
                  width: width,
                  height: height * 0.63,
                ),
                MoveableStackItem(175, 90),
                MoveableStackItem(0, 0),
                MoveableStackItem(0, 0),
                MoveableStackItem(0, 0),
                MoveableStackItem(0, 0),
                MoveableStackItem(0, 0),
                MoveableStackItem(0, 0),
                MoveableStackItem(0, 0),
                MoveableStackItem(0, 0),
                MoveableStackItem(0, 0),
                MoveableStackItem(0, 0),
              ],
            ),
            Container(
              width: width,
              height: height * 0.25,
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

  MoveableStackItem(this.xPosition, this.yPosition);

  @override
  State<StatefulWidget> createState() {
    return _MoveableStackItemState(this.xPosition, this.yPosition);
  }
}

class _MoveableStackItemState extends State<MoveableStackItem> {
  double xPosition = 0;
  double yPosition = 0;

  _MoveableStackItemState(this.xPosition, this.yPosition);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: yPosition,
      left: xPosition,
      child: GestureDetector(
        onPanUpdate: (tapInfo) {
          setState(() {
            xPosition += tapInfo.delta.dx;
            yPosition += tapInfo.delta.dy;
          });
        },
        child: Container(
          width: 60,
          height: 60,
          child: Image.asset("assets/uniform.png"),
        ),
      ),
    );
  }
}
