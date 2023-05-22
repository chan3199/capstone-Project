PlayerModel? playerModel;

class PlayerModel {
  final double x;
  final double y;
  final String name;

  PlayerModel(this.x, this.y, this.name);

  PlayerModel.fomJson(Map<String, dynamic> json)
      : x = json['x'],
        y = json['y'],
        name = json['name'];
  Map<String, dynamic> toJson() => {'x': x, 'y': y, 'name': name};
}
