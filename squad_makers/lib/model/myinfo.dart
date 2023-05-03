MyInfo? myInfo;

class MyInfo {
  DateTime date;
  String email;
  String image;
  String name;
  String password;
  List<dynamic> myclubs;
  String uid;

  MyInfo(
      {required this.date,
      required this.email,
      required this.image,
      required this.password,
      required this.name,
      required this.myclubs,
      required this.uid});

  MyInfo.fromJson(Map<String, dynamic> json)
      : date = json['date'].toDate(),
        email = json['email'],
        image = json['image'],
        password = json['password'],
        name = json['name'],
        myclubs = json['myclubs'],
        uid = json['uid'];

  Map<String, dynamic> toJson() => {
        'date': date,
        'email': email,
        'image': image,
        'password': password,
        'name': name,
        'myclubs': myclubs,
        'uid': uid
      };
}
