MyInfo? myInfo;

class MyInfo {
  DateTime date;
  String email;
  String image;
  String name;
  String nickname;
  List<dynamic> myclubs;
  String uid;

  MyInfo(
      {required this.date,
      required this.email,
      required this.image,
      required this.name,
      required this.nickname,
      required this.myclubs,
      required this.uid});

  MyInfo.fromJson(Map<String, dynamic> json)
      : date = json['date'].toDate(),
        email = json['email'],
        image = json['image'],
        name = json['name'],
        nickname = json['nickname'],
        myclubs = json['myclubs'],
        uid = json['uid'];

  Map<String, dynamic> toJson() => {
        'date': date,
        'email': email,
        'image': image,
        'name': name,
        'myclubs': myclubs,
        'nickname': nickname,
        'uid': uid
      };
}
