PositionInfo? positionInfo;

class PositionInfo {
  String docId;
  String name;
  String information;

  PositionInfo(
      {required this.docId, required this.name, required this.information});
  PositionInfo.fromJson(Map<String, dynamic> json)
      : docId = json['docId'],
        name = json['name'],
        information = json['information'];
  Map<String, dynamic> toJson() =>
      {'docId': docId, 'name': name, 'Information': information};
}
