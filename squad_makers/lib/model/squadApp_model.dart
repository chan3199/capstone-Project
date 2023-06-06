class SquadAppModel {
  DateTime date;
  String clubname;
  String squadname;
  String tacticsinfo;
  List<dynamic> playerlist;
  List<dynamic> subplayers;
  List<dynamic> userlist;

  SquadAppModel(
      {required this.date,
      required this.clubname,
      required this.squadname,
      required this.tacticsinfo,
      required this.playerlist,
      required this.subplayers,
      required this.userlist});

  SquadAppModel.fromJson(Map<String, dynamic> json)
      : date = json["date"].toDate(),
        clubname = json['clubname'],
        squadname = json['squadname'],
        tacticsinfo = json["tacticsinfo"],
        playerlist = json['playerlist'] ?? [],
        subplayers = json["subplayers"],
        userlist = json["userlist"];

  Map<String, dynamic> toJson() => {
        'date': date,
        'clubname': clubname,
        'squadname': squadname,
        'tacticsinfo': tacticsinfo,
        'playerlist': playerlist,
        'subplayers': subplayers,
        'userlist': userlist
      };
}
