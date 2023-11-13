import 'package:amt/models/armour.dart';
import 'package:amt/models/armour_data.dart';
import 'package:amt/models/attributes_list.dart';
import 'package:amt/models/character/character_state.dart';
import 'package:amt/models/character/consumible_state.dart';
import 'package:amt/models/character/character_ki.dart';
import 'package:amt/models/character/status_modifier.dart';
import 'package:amt/models/character_profile.dart';
import 'package:amt/models/combat_data.dart';
import 'package:amt/models/mystical.dart';
import 'package:amt/models/roll.dart';
import 'package:amt/models/weapon.dart';
import 'package:uuid/uuid.dart';

class Character {
  late String uuid;
  late AttributesList attributes;
  late Map<String, dynamic> skills;
  late CharacterProfile profile;
  late CharacterState state;
  late CombatData combat;
  late CharacterKi? ki;
  late Mystical? mystical;

  static int initiativeSort(Character a, Character b) {
    if (a.state.currentTurn.roll > b.state.currentTurn.roll) {
      return -1;
    } else if (a.state.currentTurn.roll < b.state.currentTurn.roll) {
      return 1;
    } else {
      return 0;
    }
  }

  Character({
    required this.uuid,
    required this.attributes,
    required this.skills,
    required this.profile,
    required this.combat,
    required this.state,
    required this.ki,
  });

  Character.heading() {
    profile = CharacterProfile(name: "Nombre");
  }

  Character.fromJson(Map<String, dynamic> json) {
    uuid = Uuid().v4();

    attributes = json['Atributos'] != null
        ? AttributesList.fromJson(json['Atributos'])
        : AttributesList();

    combat = json['Combate'] != null
        ? CombatData.fromJson(json['Combate'])
        : CombatData(
            weapons: [],
            armour: ArmourData(armours: [], calculatedArmour: Armour()));

    skills = json['Habilidades'] ?? <String, String>{};

    profile = json['datosElementales'] != null
        ? CharacterProfile?.fromJson(json['datosElementales'])
        : CharacterProfile();

    var consumibles = <ConsumibleState>[];

    consumibles.add(ConsumibleState(
      name: "Vida",
      maxValue: profile.hitPoints,
      actualValue: profile.hitPoints,
      step: 0,
    ));

    consumibles.add(ConsumibleState(
      name: "Cansancio",
      maxValue: profile.fatigue,
      actualValue: profile.fatigue,
      step: 0,
    ));

    if (json['Ki'] != null) {
      ki = CharacterKi.fromJson(json['Ki']);

      if (ki!.maximumPerAttribute.hasAValueWithMoreThanZero()) {
        var names = AttributesList.names();
        var max = ki!.maximumPerAttribute.orderedList();
        var accum = ki!.acumulationsPerAttribute.orderedList();

        for (var i = 0; i > max.length; i++) {
          consumibles.add(
            ConsumibleState(
                name: "Ki/${names[i]}",
                maxValue: max[i],
                actualValue: 0,
                step: accum[i]),
          );
        }
      } else {
        consumibles.add(ConsumibleState(
          name: "Ki",
          maxValue: ki?.maximumAccumulation ?? 0,
          actualValue: 0,
          step: ki?.genericAccumulation ?? 0,
        ));
      }
    } else {
      ki = null;
    }

    if (json['Misticos'] != null) {
      mystical = Mystical.fromJson(json['Misticos']);

      consumibles.add(ConsumibleState(
        name: "Zeon",
        maxValue: mystical?.zeon ?? 0,
        actualValue: mystical?.zeon ?? 0,
        step: mystical?.act ?? 0,
      ));
    }

    state = CharacterState(
      consumables: consumibles,
      modifiers: [
        StatusModifier(name: "Derribado"),
        StatusModifier(name: "Ceguera parcial"),
        StatusModifier(name: "Paralisis parcial"),
        StatusModifier(name: "Desenfundar"),
        StatusModifier(name: "test4"),
        StatusModifier(name: "test5"),
        StatusModifier(name: "test6")
      ],
      currentTurn: Roll.roll(base: combat.weapons.first.turn),
    );
  }

  Weapon selectedWeapon() {
    return combat.weapons[state.selectedWeaponIndex];
  }

  void rollInitiative() {
    state.currentTurn = Roll.roll(
      base: selectedWeapon().turn + state.turnModifier,
    );
  }
}
