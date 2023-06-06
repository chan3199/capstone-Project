ClubModel? clubmodel;

class ClubModel {
  DateTime date;
  String name;
  String image;
  String info;
  String clubmaster;
  List<dynamic> clubuserlist;
  List<dynamic> squadlist;
  int clubuser;
  List<dynamic> adminlist;

  ClubModel({
    required this.date,
    required this.name,
    required this.image,
    required this.info,
    required this.clubmaster,
    required this.clubuserlist,
    required this.squadlist,
    required this.clubuser,
    required this.adminlist,
  });

  ClubModel.fromJson(Map<String, dynamic> json)
      : date = json["date"].toDate(),
        name = json['name'],
        image = json['image'],
        info = json['info'],
        clubmaster = json['clubmaster'],
        clubuserlist = json['clubuserlist'],
        squadlist = json['squadlist'],
        clubuser = json['clubuser'],
        adminlist = json['adminlist'];

  Map<String, dynamic> toJson() => {
        'date': date,
        'name': name,
        'image': image,
        'info': info,
        'clubmaster': clubmaster,
        'clubuserlist': clubuserlist,
        'squadlist': squadlist,
        'clubuser': clubuser,
        'adminlist': adminlist,
      };
}
