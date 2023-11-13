import 'package:amt/models/armour.dart';
import 'package:amt/models/armour_data.dart';
import 'package:amt/models/char_attributes.dart';
import 'package:amt/models/character/character_state.dart';
import 'package:amt/models/character/consumible_state.dart';
import 'package:amt/models/character_profile.dart';
import 'package:amt/models/combat_data.dart';
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

    ConsumibleState hitPoints = ConsumibleState(
      name: "Vida",
      maxValue: profile.hitPoints,
      actualValue: profile.hitPoints,
    );

    ConsumibleState fatigue = ConsumibleState(
      name: "Cansancio",
      maxValue: profile.fatigue,
      actualValue: profile.fatigue,
    );

    if (json['Ki'] != null) {}

    state = CharacterState(
      consumibles: [hitPoints, fatigue, fatigue, fatigue, fatigue],
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
