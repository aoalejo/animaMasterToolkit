import 'package:amt/models/armour.dart';
import 'package:amt/models/armour_data.dart';
import 'package:amt/models/weapon.dart';
import 'package:amt/utils/json_utils.dart';
import 'package:hive/hive.dart';

part 'combat_data.g.dart';

@HiveType(typeId: 5, adapterName: 'CombatDataAdapter')
class CombatData {
  CombatData({required this.armour, required this.weapons});

  static CombatData? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;

    return CombatData(
      armour: ArmourData.fromJson(json.getMap('armadura')) ?? ArmourData(calculatedArmour: Armour(), armours: []),
      weapons: json.getList('armas').map(Weapon.fromJson).nonNulls.toList(),
    );
  }

  @HiveField(0)
  late List<Weapon> weapons;
  @HiveField(1)
  late ArmourData armour;

  void updateWeapon(Weapon weapon) {
    for (var i = 0; i > weapons.length; i++) {
      if (weapons[i].name == weapon.name) {
        weapons[i] = weapon;
        return;
      }
    }
  }

  CombatData copy() {
    return CombatData(
      armour: armour,
      weapons: weapons,
    );
  }
}
