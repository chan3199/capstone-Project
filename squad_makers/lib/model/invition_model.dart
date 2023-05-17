InvitionModel? invitionModel;

class InvitionModel {
  final String clubname;
  final String image;
  final String user;

  InvitionModel(this.clubname, this.image, this.user);

  InvitionModel.fromJson(Map<String, dynamic> json)
      : clubname = json['clubname'],
        image = json['image'],
        user = json['user'];
  Map<String, dynamic> toJson() =>
      {'clubname': clubname, 'image': image, 'user': user};
}
