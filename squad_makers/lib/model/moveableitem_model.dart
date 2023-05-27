MoveableItem? moveableItem;

class MoveableItem {
  final String useruid;
  final String number;
  final String movement;
  final String role;

  MoveableItem(
      {required this.useruid,
      required this.number,
      required this.movement,
      required this.role});

  MoveableItem.fromJson(Map<String, dynamic> json)
      : useruid = json["useruid"],
        number = json["number"],
        movement = json["movement"],
        role = json["role"];

  Map<String, dynamic> toJson() => {
        'useruid': useruid,
        'number': number,
        'movement': movement,
        'role': role
      };
}
