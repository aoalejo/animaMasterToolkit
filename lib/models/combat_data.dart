import 'package:amt/models/armour.dart';
import 'package:amt/models/armour_data.dart';
import 'package:amt/models/weapon.dart';

class CombatData {
  late List<Weapon> weapons;
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
