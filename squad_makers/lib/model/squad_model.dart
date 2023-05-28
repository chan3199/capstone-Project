import 'package:squad_makers/model/moveableitem_model.dart';

class SquadModel {
  final String clubname;
  final String squadname;
  final List<MoveableItem> playerlist;
  final String tacticsinfo;
  final List<dynamic> subplayers;
  final List<dynamic> userlist;

  SquadModel(
      {required this.clubname,
      required this.squadname,
      required this.playerlist,
      required this.tacticsinfo,
      required this.subplayers,
      required this.userlist});

  SquadModel.fromJson(Map<String, dynamic> json)
      : clubname = json['clubname'],
        squadname = json['squadname'],
        playerlist = json["playerlist"],
        tacticsinfo = json["tacticsinfo"],
        subplayers = json["subplayers"],
        userlist = json["userlist"];

  Map<String, dynamic> toJson() => {
        'clubname': clubname,
        'squadname': squadname,
        'playerlist': playerlist,
        'tacticsinfo': tacticsinfo,
        'subplayers': subplayers,
        'userlist': userlist
      };
}
