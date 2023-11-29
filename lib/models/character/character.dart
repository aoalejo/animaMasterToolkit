import 'package:amt/models/armour.dart';
import 'package:amt/models/armour_data.dart';
import 'package:amt/models/attributes_list.dart';
import 'package:amt/models/character/character_state.dart';
import 'package:amt/models/character/consumable_state.dart';
import 'package:amt/models/character/character_ki.dart';
import 'package:amt/models/character_profile.dart';
import 'package:amt/models/combat_data.dart';
import 'package:amt/models/enums.dart';
import 'package:amt/models/modifiers_state.dart';
import 'package:amt/models/mystical.dart';
import 'package:amt/models/psychic_data.dart';
import 'package:amt/models/roll.dart';
import 'package:amt/models/weapon.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'character.g.dart';

@HiveType(typeId: 0, adapterName: "CharacterAdapter")
class Character extends HiveObject {
  @HiveField(0)
  late String uuid;
  @HiveField(1)
  late AttributesList attributes;
  @HiveField(2)
  late Map<String, dynamic> skills;
  @HiveField(3)
  late CharacterProfile profile;
  @HiveField(4)
  late CharacterState state;
  @HiveField(5)
  late CombatData combat;
  @HiveField(6)
  late CharacterKi? ki;
  @HiveField(7)
  late Mystical? mystical;
  @HiveField(8)
  late PsychicData? psychic;

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
    required this.mystical,
    required this.psychic,
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

    var consumables = <ConsumableState>[];

    consumables.add(ConsumableState(
      name: "Vida",
      maxValue: profile.hitPoints,
      actualValue: profile.hitPoints,
      step: 0,
      type: ConsumableType.hitPoints,
      description:
          "indice de regeneración: ${profile.regeneration}:\n${getRegenDescription()}",
    ));

    consumables.add(ConsumableState(
      name: "Cansancio",
      maxValue: profile.fatigue,
      actualValue: profile.fatigue,
      type: ConsumableType.fatigue,
      step: 0,
      description: "",
    ));

    if (json['Ki'] != null) {
      ki = CharacterKi.fromJson(json['Ki']);

      if (ki!.maximumPerAttribute.hasAValueWithMoreThanZero()) {
        var names = AttributesList.names();
        var max = ki!.maximumPerAttribute.orderedList();
        var accumulation = ki!.accumulationsPerAttribute.orderedList();

        for (var i = 0; i < max.length; i++) {
          if (max[i] > 0) {
            consumables.add(
              ConsumableState(
                  name: "Ki/${names[i]}",
                  maxValue: max[i],
                  actualValue: 0,
                  step: accumulation[i],
                  description: ""),
            );
          }
        }
      } else {
        if (ki?.maximumAccumulation != 0) {
          consumables.add(
            ConsumableState(
                name: "Ki",
                maxValue: ki?.maximumAccumulation ?? 0,
                actualValue: 0,
                step: ki?.genericAccumulation ?? 0,
                description: "Usando ki unificado"),
          );
        }
      }
    } else {
      ki = null;
    }

    if (json['Misticos'] != null) {
      mystical = Mystical.fromJson(json['Misticos']);

      if (mystical?.zeon != 0) {
        consumables.add(
          ConsumableState(
              name: "Zeon",
              maxValue: mystical?.zeon ?? 0,
              actualValue: mystical?.zeon ?? 0,
              step: mystical?.act ?? 0,
              description: "Regenera ${mystical!.zeonRegeneration} por día"),
        );
      }
    } else {
      mystical = null;
    }

    if (json['Psiquicos'] != null) {
      psychic = PsychicData.fromJson(json['Psiquicos']);

      if (psychic?.freeCvs != 0) {
        consumables.add(ConsumableState(
          name: "CV",
          maxValue: psychic?.freeCvs ?? 0,
          actualValue: psychic?.freeCvs ?? 0,
          step: 0,
          description: "",
        ));
      }
    } else {
      psychic = null;
    }

    state = CharacterState(
      consumables: consumables,
      modifiers: ModifiersState(),
      currentTurn: Roll.roll(base: combat.weapons.first.turn),
    );
  }

  Weapon selectedWeapon() {
    return combat.weapons[state.selectedWeaponIndex];
  }

  void rollInitiative() {
    state.currentTurn = Roll.roll(
      base: selectedWeapon().turn + state.calculateTotalForTurn(),
    );
  }

  String getRegenDescription() {
    var values = [
      "0",
      "Regenera 10 PV al día descansando, y -5 a negativos", // 1
      "Regenera 20 PV al día descansando, y -5 a negativos", // 2
      "Regenera 30 PV al día descansando, y -5 a negativos", // 3
      "Regenera 40 PV al día descansando, y -10 a negativos", // 4
      "Regenera 50 PV al día descansando, y -10 a negativos", // 5
      "Regenera 75 PV al día descansando, y -15 a negativos", // 6
      "Regenera 100 PV al día descansando, y -20 a negativos", // 7
      "Regenera 250 PV al día descansando, y -25 a negativos", // 8
      "Regenera 500 PV al día descansando, y -30 a negativos", // 9
      "Regenera 1 PV por minuto, y -40 negativos al dia", // 10
      "Regenera 2 PV por minuto, y -50 negativos al dia", // 11
      "Regenera 5 PV por minuto, y -5 negativos por hora", // 12
      "Regenera 10 PV por minuto, y -10 negativos por hora", // 13
      "Regenera 1 PV por asalto, y -15 negativos por hora", // 14
      "Regenera 5 PV por asalto, y -20 negativos por hora", // 15
      "Regenera 10 PV por asalto, y -10 negativos por minuto", // 16
      "Regenera 25 PV por asalto, y -10 negativos por asalto", // 17
      "Regenera 50 PV por asalto, y -25 negativos por asalto", // 18
      "Regenera 100 PV por asalto, todos sus negativos por asalto", // 19
      "Regenera 250 PV por asalto, todos sus negativos por asalto", // 20
      ""
    ];
    return values[profile.regeneration];
  }

  void removeFrom(int value, ConsumableType type) {
    var firstOfType =
        state.consumables.where((element) => element.type == type).first;
    firstOfType.actualValue -= value;
  }
}

extension ListToKeyValue on Map<String, dynamic> {
  List<KeyValue> list({bool interchange = false}) {
    List<KeyValue> list = [];
    for (final entry in entries) {
      list.add(
        KeyValue(
          key: interchange ? entry.value.toString() : entry.key.toString(),
          value: interchange ? entry.key.toString() : entry.value.toString(),
        ),
      );
    }
    return list;
  }
}

class KeyValue {
  final String key;
  final String value;

  KeyValue({required this.key, required this.value});
}
