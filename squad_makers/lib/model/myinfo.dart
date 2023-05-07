MyInfo? myInfo;

class MyInfo {
  DateTime date;
  String email;
  String image;
  String name;
  String nickname;
  String uid;

  MyInfo(
      {required this.date,
      required this.email,
      required this.image,
      required this.name,
      required this.nickname,
      required this.uid});

  MyInfo.fromJson(Map<String, dynamic> json)
      : date = json['date'].toDate(),
        email = json['email'],
        image = json['image'],
        name = json['name'],
        nickname = json['nickname'],
        uid = json['uid'];

  Map<String, dynamic> toJson() => {
        'date': date,
        'email': email,
        'image': image,
        'name': name,
        'nickname': nickname,
        'uid': uid
      };
}
