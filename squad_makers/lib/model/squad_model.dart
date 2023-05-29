class SquadModel {
  final DateTime date;
  final String clubname;
  final String squadname;
  final String tacticsinfo;
  final List<dynamic> subplayers;
  final List<dynamic> userlist;

  SquadModel(
      {required this.date,
      required this.clubname,
      required this.squadname,
      required this.tacticsinfo,
      required this.subplayers,
      required this.userlist});

  SquadModel.fromJson(Map<String, dynamic> json)
      : date = json["date"].toDate(),
        clubname = json['clubname'],
        squadname = json['squadname'],
        tacticsinfo = json["tacticsinfo"],
        subplayers = json["subplayers"],
        userlist = json["userlist"];

  Map<String, dynamic> toJson() => {
        'date': date,
        'clubname': clubname,
        'squadname': squadname,
        'tacticsinfo': tacticsinfo,
        'subplayers': subplayers,
        'userlist': userlist
      };
}
