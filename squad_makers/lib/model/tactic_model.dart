class TacticInfo {
  String name;
  String simpleInfo;
  String defenseline;
  String spacing;
  String shotfrequency;
  String pressure;
  String attackdirection;
  String passdistance;

  TacticInfo(
      {required this.name,
      required this.simpleInfo,
      required this.defenseline,
      required this.spacing,
      required this.pressure,
      required this.shotfrequency,
      required this.attackdirection,
      required this.passdistance});

  TacticInfo.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        simpleInfo = json['simpleInfo'],
        defenseline = json['defenceline'],
        spacing = json['spacing'],
        shotfrequency = json['shotfrequency'],
        pressure = json['pressure'],
        attackdirection = json['attackdirection'],
        passdistance = json['passdistance'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'simpleInfo': simpleInfo,
        'defenceline': defenseline,
        'spacing': spacing,
        'shotfrequency': shotfrequency,
        'pressure': pressure,
        'attackdirection': attackdirection,
        'passdistance': passdistance
      };
}
