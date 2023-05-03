PositionInfo? positionInfo;

class PositionInfo {
  String docId;
  String name;
  String Information;

  PositionInfo(
      {required this.docId, required this.name, required this.Information});
  PositionInfo.fromJson(Map<String, dynamic> json)
      : docId = json['docId'],
        name = json['name'],
        Information = json['Information'];
  Map<String, dynamic> toJson() =>
      {'docId': docId, 'name': name, 'Information': Information};
}
