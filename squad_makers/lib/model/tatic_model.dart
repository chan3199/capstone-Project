class taticInfo {
  String name;
  String simpleInfo;
  String docId;
  String defenseline;
  String spacing;
  String shotfrequency;
  String pressure;
  String attackdirection;
  String passdistance;

  taticInfo(
      {required this.name,
      required this.simpleInfo,
      required this.docId,
      required this.defenseline,
      required this.spacing,
      required this.pressure,
      required this.shotfrequency,
      required this.attackdirection,
      required this.passdistance});

  taticInfo.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        simpleInfo = json['simpleInfo'],
        docId = json['docId'],
        defenseline = json['defenceline'],
        spacing = json['spacing'],
        shotfrequency = json['shotfrequency'],
        pressure = json['pressure'],
        attackdirection = json['attackdirection'],
        passdistance = json['passdistance'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'simpleInfo': simpleInfo,
        'docId': docId,
        'defenceline': defenseline,
        'spacing': spacing,
        'shotfrequency': shotfrequency,
        'pressure': pressure,
        'attackdirection': attackdirection,
        'passdistance': passdistance
      };
}
