PositionInfo? positionInfo;

class PositionInfo {
  String docId;
  String name;
  String Information;
  List<dynamic> image;

  PositionInfo(
      {required this.docId,
      required this.name,
      required this.Information,
      required this.image});
  PositionInfo.fromJson(Map<String, dynamic> json)
      : docId = json['docId'],
        name = json['name'],
        Information = json['Information'],
        image = json['image'];
  Map<String, dynamic> toJson() => {
        'docId': docId,
        'name': name,
        'Information': Information,
        'image': image
      };
}
