// import 'package:flutter/material.dart';

// class Player {
//   final String name;
//   final Offset initialPosition;

//   Player({required this.name, required this.initialPosition});
// }

// class testPage extends StatelessWidget {
//   final List<Player> _players = [
//     Player(name: "GK", initialPosition: Offset(180, 320)),
//     Player(name: "RB", initialPosition: Offset(50, 250)),
//     Player(name: "CB1", initialPosition: Offset(150, 250)),
//     Player(name: "CB2", initialPosition: Offset(250, 250)),
//     Player(name: "LB", initialPosition: Offset(350, 250)),
//     Player(name: "CDM", initialPosition: Offset(250, 180)),
//     Player(name: "CM1", initialPosition: Offset(150, 180)),
//     Player(name: "CM2", initialPosition: Offset(250, 180)),
//     Player(name: "RM", initialPosition: Offset(150, 100)),
//     Player(name: "LM", initialPosition: Offset(250, 100)),
//     Player(name: "ST", initialPosition: Offset(250, 40)),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text('Soccer Squad'),
//         ),
//         body: Container(
//           color: Colors.green, // 배경 색상 설정
//           child: Stack(
//             children: _players
//                 .map((player) => DraggablePlayer(player: player))
//                 .toList(),
//           ),
//         ));
//   }
// }

// class DraggablePlayer extends StatefulWidget {
//   final Player player;

//   DraggablePlayer({required this.player});

//   @override
//   _DraggablePlayerState createState() => _DraggablePlayerState();
// }

// class _DraggablePlayerState extends State<DraggablePlayer> {
//   late Offset _position;

//   @override
//   void initState() {
//     super.initState();
//     _position = widget.player.initialPosition;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Positioned(
//       left: _position.dx,
//       top: _position.dy,
//       child: Draggable(
//         child: Container(
//           width: 50,
//           height: 50,
//           color: Colors.blue,
//           child: Center(
//             child: Text(
//               widget.player.name,
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//         ),
//         feedback: Container(
//           width: 50,
//           height: 50,
//           color: Colors.blue.withOpacity(0.5),
//           child: Center(
//             child: Text(
//               widget.player.name,
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//         ),
//         childWhenDragging: Container(),
//         onDraggableCanceled: (velocity, offset) {
//           setState(() {
//             _position = offset;
//           });
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class Player {
  final String name;
  final IconData iconData;
  Offset position;

  Player({required this.name, required this.iconData, required this.position});
}

class testPage extends StatefulWidget {
  @override
  _testPageState createState() => _testPageState();
}

class _testPageState extends State<testPage> {
  final List<Player> _lineup = [
    Player(name: "GK", iconData: Icons.person, position: Offset(250, 500)),
    Player(name: "LB", iconData: Icons.person, position: Offset(100, 300)),
    Player(name: "CB1", iconData: Icons.person, position: Offset(250, 300)),
    Player(name: "CB2", iconData: Icons.person, position: Offset(400, 300)),
    Player(name: "RB", iconData: Icons.person, position: Offset(550, 300)),
    Player(name: "CM1", iconData: Icons.person, position: Offset(250, 200)),
    Player(name: "CM2", iconData: Icons.person, position: Offset(400, 200)),
    Player(name: "LM", iconData: Icons.person, position: Offset(100, 100)),
    Player(name: "RM", iconData: Icons.person, position: Offset(550, 100)),
    Player(name: "AM", iconData: Icons.person, position: Offset(250, 50)),
    Player(name: "ST", iconData: Icons.person, position: Offset(400, 50)),
  ];

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Soccer Field'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Stack(
            children: [
              GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    _lineup.forEach((player) {
                      player.position += details.delta;
                    });
                  });
                },
                child: Container(
                  width: width,
                  height: height,
                  color: Colors.green,
                ),
              ),
              ..._lineup.asMap().entries.map((entry) {
                final index = entry.key;
                final player = entry.value;

                return Positioned(
                  left: player.position.dx,
                  top: player.position.dy,
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      setState(() {
                        player.position += details.delta;
                      });
                    },
                    child: Icon(
                      player.iconData,
                      size: 32,
                      color: Colors.blue,
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
