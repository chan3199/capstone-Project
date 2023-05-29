MoveableItem? moveableItem;

class MoveableItem {
  final String userEmail;
  final double xPosition;
  final double yPosition;
  final String number;
  final String movement;
  final String role;

  MoveableItem(
      {required this.userEmail,
      required this.xPosition,
      required this.yPosition,
      required this.number,
      required this.movement,
      required this.role});

  MoveableItem.fromJson(Map<String, dynamic> json)
      : userEmail = json["userEmail"],
        xPosition = json["xposition"],
        yPosition = json["yposition"],
        number = json["number"],
        movement = json["movement"],
        role = json["role"];

  Map<String, dynamic> toJson() => {
        'userEmail': userEmail,
        'xposition': xPosition,
        'yPosition': yPosition,
        'number': number,
        'movement': movement,
        'role': role
      };
}
