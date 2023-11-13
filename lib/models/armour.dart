import 'package:amt/utils/json_utils.dart';

class Armour {
  String? name;
  ArmourLocation? location;
  int? quality;
  late int fil;
  late int con;
  late int pen;
  late int cal;
  late int ele;
  late int fri;
  late int ene;
  int? endurance;
  int? presence;
  int? movementRestriction;
  bool? enchanted;

  Armour(
      {this.name,
      this.location,
      this.quality,
      this.fil = 2,
      this.con = 2,
      this.pen = 2,
      this.cal = 2,
      this.ele = 2,
      this.fri = 2,
      this.ene = 2,
      this.endurance,
      this.presence,
      this.movementRestriction,
      this.enchanted});

  int armourFor(DamageTypes damage) {
    switch (damage) {
      case DamageTypes.fil:
        return fil;
      case DamageTypes.pen:
        return pen;
      case DamageTypes.con:
        return con;
      case DamageTypes.fri:
        return fri;
      case DamageTypes.cal:
        return cal;
      case DamageTypes.ele:
        return ele;
      case DamageTypes.ene:
        return ene;
    }
  }

  Armour.fromJson(Map<String, dynamic> json) {
    name = json['nombre'];
    location = JsonUtils.armourLocation(json['Localizacion']);
    quality = JsonUtils.integer(json['calidad'], 0);
    fil = JsonUtils.integer(json['FIL'], 2);
    con = JsonUtils.integer(json['CON'], 2);
    pen = JsonUtils.integer(json['PEN'], 2);
    cal = JsonUtils.integer(json['CAL'], 2);
    ele = JsonUtils.integer(json['ELE'], 2);
    fri = JsonUtils.integer(json['FRI'], 2);
    ene = JsonUtils.integer(json['ENE'], 2);
    endurance = JsonUtils.integer(json['Entereza'], 10);
    presence = JsonUtils.integer(json['Presencia'], 10);
    movementRestriction = JsonUtils.integer(json['RestMov'], 0);
    enchanted = json['Enc'].toString() == "Si";
  }
}
