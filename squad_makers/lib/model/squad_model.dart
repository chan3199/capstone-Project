import 'package:squad_makers/model/moveableitem_model.dart';

class SquadModel {
  final List<MoveableItem> playerlist;
  final String formation;
  final String tacticsinfo;
  final List<dynamic> subplayers;
  final List<dynamic> userlist;

  SquadModel(
      {required this.playerlist,
      required this.formation,
      required this.tacticsinfo,
      required this.subplayers,
      required this.userlist});

  SquadModel.fromJson(Map<String, dynamic> json)
      : playerlist = json["playerlist"],
        formation = json["formation"],
        tacticsinfo = json["tacticsinfo"],
        subplayers = json["subplayers"],
        userlist = json["userlist"];

  Map<String, dynamic> toJson() => {
        'playerlist': playerlist,
        'formation': formation,
        'tacticsinfo': tacticsinfo,
        'subplayers': subplayers,
        'userlist': userlist
      };
}
