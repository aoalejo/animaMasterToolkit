import 'package:amt/models/enums.dart';
import 'package:amt/utils/json_utils.dart';
import 'package:hive/hive.dart';

part 'armour.g.dart';

@HiveType(typeId: 8, adapterName: 'ArmourAdapter')
class Armour {
  Armour({
    this.name,
    this.location,
    this.quality,
    this.fil = 0,
    this.con = 0,
    this.pen = 0,
    this.cal = 0,
    this.ele = 0,
    this.fri = 0,
    this.ene = 0,
    this.endurance,
    this.presence,
    this.movementRestriction,
    this.enchanted,
  });

  static Armour? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;

    return Armour(
      name: json['nombre'].toString(),
      location: JsonUtils.armourLocation(json['Localizacion']),
      quality: JsonUtils.integer(json['calidad'], 0),
      fil: JsonUtils.integer(json['FIL'], 2),
      con: JsonUtils.integer(json['CON'], 2),
      pen: JsonUtils.integer(json['PEN'], 2),
      cal: JsonUtils.integer(json['CAL'], 2),
      ele: JsonUtils.integer(json['ELE'], 2),
      fri: JsonUtils.integer(json['FRI'], 2),
      ene: JsonUtils.integer(json['ENE'], 2),
      endurance: JsonUtils.integer(json['Entereza'], 10),
      presence: JsonUtils.integer(json['Presencia'], 10),
      movementRestriction: JsonUtils.integer(json['RestMov'], 0),
      enchanted: json['Enc'].toString() == 'Si',
    );
  }

  Armour.fromValue({required String name, required int physical, required int energy}) {
    name = name;
    fil = physical;
    con = physical;
    pen = physical;
    cal = physical;
    ele = physical;
    fri = physical;
    ene = energy;
    endurance = 99;
  }
  @HiveField(0)
  String? name;
  @HiveField(1)
  ArmourLocation? location;
  @HiveField(2)
  int? quality;
  @HiveField(3)
  late int fil;
  @HiveField(4)
  late int con;
  @HiveField(5)
  late int pen;
  @HiveField(6)
  late int cal;
  @HiveField(7)
  late int ele;
  @HiveField(8)
  late int fri;
  @HiveField(9)
  late int ene;
  @HiveField(10)
  int? endurance;
  @HiveField(11)
  int? presence;
  @HiveField(12)
  int? movementRestriction;
  @HiveField(13)
  bool? enchanted;

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

  String description() {
    return 'Fil: $fil Con: $con Pen: $pen Cal: $cal Ele: $ele Fri: $fri Ene: $ene';
  }

  void changeForAll({required int add}) {
    fil = fil + add;
    con = con + add;
    pen = pen + add;
    cal = cal + add;
    ele = ele + add;
    fri = fri + add;
    ene = ene + add;
  }
}
