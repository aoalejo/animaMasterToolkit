import 'package:amt/models/armour.dart';
import 'package:amt/models/armour_data.dart';
import 'package:amt/models/weapon.dart';
import 'package:hive/hive.dart';

@HiveType(typeId: 5, adapterName: "CombatDataAdapter")
class CombatData {
  @HiveField(0)
  late List<Weapon> weapons;
  @HiveField(1)
  late ArmourData armour;

  CombatData({required this.armour, required this.weapons});

  CombatData.fromJson(Map<String, dynamic> json) {
    weapons = <Weapon>[];
    if (json['armas'] != null) {
      json['armas'].forEach((v) {
        weapons.add(Weapon.fromJson(v));
      });
    }

    armour = json['armadura'] != null
        ? ArmourData.fromJson(json['armadura'])
        : ArmourData(calculatedArmour: Armour(), armours: []);
  }
}
