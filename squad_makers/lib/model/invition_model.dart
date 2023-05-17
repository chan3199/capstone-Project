InvitionModel? invitionModel;

class InvitionModel {
  final DateTime date;
  final String clubname;
  final String image;
  final String user;

  InvitionModel(this.date, this.clubname, this.image, this.user);

  InvitionModel.fromJson(Map<String, dynamic> json)
      : date = json['date'],
        clubname = json['clubname'],
        image = json['image'],
        user = json['user'];
  Map<String, dynamic> toJson() =>
      {'date': date, 'clubname': clubname, 'image': image, 'user': user};
}
