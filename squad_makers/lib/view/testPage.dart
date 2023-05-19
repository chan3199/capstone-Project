import 'package:flutter/material.dart';

class Player {
  final String name;
  final Offset initialPosition;

  Player({required this.name, required this.initialPosition});
}

class testPage extends StatelessWidget {
  final List<Player> _players = [
    Player(name: "GK", initialPosition: Offset(180, 320)),
    Player(name: "RB", initialPosition: Offset(50, 250)),
    Player(name: "CB1", initialPosition: Offset(150, 250)),
    Player(name: "CB2", initialPosition: Offset(250, 250)),
    Player(name: "LB", initialPosition: Offset(350, 250)),
    Player(name: "CDM", initialPosition: Offset(250, 180)),
    Player(name: "CM1", initialPosition: Offset(150, 180)),
    Player(name: "CM2", initialPosition: Offset(250, 180)),
    Player(name: "RM", initialPosition: Offset(150, 100)),
    Player(name: "LM", initialPosition: Offset(250, 100)),
    Player(name: "ST", initialPosition: Offset(250, 40)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Soccer Squad'),
        ),
        body: Container(
          color: Colors.green, // 배경 색상 설정
          child: Stack(
            children: _players
                .map((player) => DraggablePlayer(player: player))
                .toList(),
          ),
        ));
  }
}

class DraggablePlayer extends StatefulWidget {
  final Player player;

  DraggablePlayer({required this.player});

  @override
  _DraggablePlayerState createState() => _DraggablePlayerState();
}

class _DraggablePlayerState extends State<DraggablePlayer> {
  late Offset _position;

  @override
  void initState() {
    super.initState();
    _position = widget.player.initialPosition;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _position.dx,
      top: _position.dy,
      child: Draggable(
        child: Container(
          width: 50,
          height: 50,
          color: Colors.blue,
          child: Center(
            child: Text(
              widget.player.name,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        feedback: Container(
          width: 50,
          height: 50,
          color: Colors.blue.withOpacity(0.5),
          child: Center(
            child: Text(
              widget.player.name,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        childWhenDragging: Container(),
        onDraggableCanceled: (velocity, offset) {
          setState(() {
            _position = offset;
          });
        },
      ),
    );
  }
}
