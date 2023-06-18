MoveableItem? moveableItem;

class MoveableItem {
  String userEmail;
  double xPosition;
  double yPosition;
  int number;
  String movement;
  String role;
  String memo;
  String position;

  MoveableItem(
      {required this.userEmail,
      required this.xPosition,
      required this.yPosition,
      required this.number,
      required this.movement,
      required this.role,
      required this.memo,
      required this.position});

  MoveableItem.fromJson(Map<String, dynamic> json)
      : userEmail = json["userEmail"],
        xPosition = json["xposition"],
        yPosition = json["yposition"],
        number = json["number"],
        movement = json["movement"],
        role = json["role"],
        memo = json["memo"],
        position = json["position"];

  Map<String, dynamic> toJson() => {
        'userEmail': userEmail,
        'xposition': xPosition,
        'yPosition': yPosition,
        'number': number,
        'movement': movement,
        'role': role,
        'memo': memo,
        'position': position
      };
}
