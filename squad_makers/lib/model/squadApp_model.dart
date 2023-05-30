class SquadAppModel {
  final DateTime date;
  final String clubname;
  final String squadname;
  final String tacticsinfo;
  final List<dynamic> playerlist;
  final List<dynamic> subplayers;
  final List<dynamic> userlist;

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
