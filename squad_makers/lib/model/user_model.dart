MyInfo? myInfo;

class MyInfo {
  DateTime date;
  String email;
  String image;
  String name;
  String nickname;
  String pushToken;

  MyInfo({
    required this.date,
    required this.email,
    required this.image,
    required this.name,
    required this.nickname,
    required this.pushToken,
  });

  MyInfo.fromJson(Map<String, dynamic> json)
      : date = json['date'].toDate(),
        email = json['email'],
        image = json['image'],
        name = json['name'],
        nickname = json['nickname'],
        pushToken = json['pushToken'] ?? '';

  Map<String, dynamic> toJson() => {
        'date': date,
        'email': email,
        'image': image,
        'name': name,
        'nickname': nickname,
        'pushToken': pushToken,
      };
}
