import 'package:amt/models/armour.dart';
import 'package:amt/models/armour_data.dart';
import 'package:amt/models/attributes_list.dart';
import 'package:amt/models/character/character_ki.dart';
import 'package:amt/models/character/character_resistances.dart';
import 'package:amt/models/character/character_state.dart';
import 'package:amt/models/character/consumable_state.dart';
import 'package:amt/models/character_profile.dart';
import 'package:amt/models/combat_data.dart';
import 'package:amt/models/enums.dart';
import 'package:amt/models/modifiers_state.dart';
import 'package:amt/models/mystical.dart';
import 'package:amt/models/psychic_data.dart';
import 'package:amt/models/roll.dart';
import 'package:amt/models/weapon.dart';
import 'package:amt/resources/modifiers.dart';
import 'package:amt/utils/json_utils.dart';
import 'package:amt/utils/key_value.dart';
import 'package:function_tree/function_tree.dart';
import 'package:hive/hive.dart';
import 'package:logger/web.dart';
import 'package:uuid/uuid.dart';

part 'character.g.dart';

@HiveType(typeId: 0, adapterName: 'CharacterAdapter')
class Character extends HiveObject {
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
    required this.resistances,
  });

  Character.heading() {
    profile = CharacterProfile(name: 'Nombre');
  }

  static Character? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;

    final profile = CharacterProfile.fromJson(json.getMap('datosElementales')) ?? CharacterProfile();

    final consumables = <ConsumableState>[
      ConsumableState(
        name: 'Vida',
        maxValue: profile.hitPoints,
        actualValue: profile.hitPoints,
        step: 10,
        type: ConsumableType.hitPoints,
        description: 'indice de regeneración: ${profile.regeneration}:\n${getRegenerationDescription(profile.regeneration)}',
      ),
      ConsumableState(
        name: 'Cansancio',
        maxValue: profile.fatigue,
        actualValue: profile.fatigue,
        type: ConsumableType.fatigue,
        step: 1,
        description: '',
      ),
    ];

    final ki = CharacterKi.fromJson(json.getMap('Ki'));

    if (ki!.maximumPerAttribute.hasAValueWithMoreThanZero()) {
      final names = AttributesList.names();
      final max = ki.maximumPerAttribute.orderedList();
      final accumulation = ki.accumulationsPerAttribute.orderedList();

      for (var i = 0; i < max.length; i++) {
        if (max[i] > 0) {
          consumables.add(
            ConsumableState(name: 'Ki/${names[i]}', maxValue: max[i], actualValue: 1, step: accumulation[i], description: ''),
          );
        }
      }
    } else {
      if (ki.maximumAccumulation != 0) {
        consumables.add(
          ConsumableState(
            name: 'Ki',
            maxValue: ki.maximumAccumulation,
            actualValue: 01,
            step: ki.genericAccumulation,
            description: 'Usando ki unificado',
          ),
        );
      }
    }

    final mystical = Mystical.fromJson(json.getMap('Misticos'));

    if (mystical?.zeon != 0) {
      consumables.add(
        ConsumableState(
          name: 'Zeon',
          maxValue: mystical?.zeon ?? 0,
          actualValue: mystical?.zeon ?? 0,
          step: mystical?.act ?? 0,
          description: 'Regenera ${mystical!.zeonRegeneration} por día',
        ),
      );
    }

    final psychic = PsychicData.fromJson(json.getMap('Psiquicos'));

    if (psychic != null) {
      if (psychic.freeCvs != 0) {
        consumables.add(
          ConsumableState(
            name: 'CV',
            maxValue: psychic.freeCvs,
            actualValue: psychic.freeCvs,
            step: 1,
            description: '',
          ),
        );
      }
    }

    final combat = CombatData.fromJson(json.getMap('Combate')) ??
        CombatData(
          weapons: [],
          armour: ArmourData(armours: [], calculatedArmour: Armour()),
        );

    final state = CharacterState(
      consumables: consumables,
      modifiers: ModifiersState(),
      currentTurn: Roll.roll(
        base: combat.weapons.firstOrNull?.turn ?? 0,
        fumbleLevel: profile.fumbleLevel ?? 3,
        nature: profile.nature ?? 0,
      ),
    );

    return Character(
      uuid: const Uuid().v4(),
      attributes: AttributesList.fromJson(json.getMap('Atributos')) ?? AttributesList(),
      resistances: CharacterResistances.fromJson(json.getMap('Resistencias')) ?? CharacterResistances(),
      combat: combat,
      skills: json.getMap('Habilidades') ?? <String, String>{},
      mystical: mystical,
      profile: profile,
      psychic: psychic,
      state: state,
      ki: ki,
    );
  }

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
  @HiveField(9)
  late CharacterResistances resistances;

  static int initiativeSort(Character a, Character b) {
    if (a.state.currentTurn.roll > b.state.currentTurn.roll) {
      return -1;
    } else if (a.state.currentTurn.roll < b.state.currentTurn.roll) {
      return 1;
    } else {
      return 0;
    }
  }

  Weapon selectedWeapon() {
    try {
      return combat.weapons[state.selectedWeaponIndex];
    } catch (e) {
      return Weapon(name: '-', turn: 0, attack: 0, defense: 0, defenseType: DefenseType.dodge, damage: 0);
    }
  }

  void rollInitiative() {
    state.currentTurn = Roll.roll(
      base: calculateTurnBase(),
      fumbleLevel: profile.fumbleLevel ?? 3,
      nature: profile.nature ?? 0,
      turnFumble: true,
    );
  }

  static String getRegenerationDescription(int index) {
    final values = [
      '0',
      'Regenera 10 PV al día descansando, y -5 a negativos', // 1
      'Regenera 20 PV al día descansando, y -5 a negativos', // 2
      'Regenera 30 PV al día descansando, y -5 a negativos', // 3
      'Regenera 40 PV al día descansando, y -10 a negativos', // 4
      'Regenera 50 PV al día descansando, y -10 a negativos', // 5
      'Regenera 75 PV al día descansando, y -15 a negativos', // 6
      'Regenera 100 PV al día descansando, y -20 a negativos', // 7
      'Regenera 250 PV al día descansando, y -25 a negativos', // 8
      'Regenera 500 PV al día descansando, y -30 a negativos', // 9
      'Regenera 1 PV por minuto, y -40 negativos al dia', // 10
      'Regenera 2 PV por minuto, y -50 negativos al dia', // 11
      'Regenera 5 PV por minuto, y -5 negativos por hora', // 12
      'Regenera 10 PV por minuto, y -10 negativos por hora', // 13
      'Regenera 1 PV por asalto, y -15 negativos por hora', // 14
      'Regenera 5 PV por asalto, y -20 negativos por hora', // 15
      'Regenera 10 PV por asalto, y -10 negativos por minuto', // 16
      'Regenera 25 PV por asalto, y -10 negativos por asalto', // 17
      'Regenera 50 PV por asalto, y -25 negativos por asalto', // 18
      'Regenera 100 PV por asalto, todos sus negativos por asalto', // 19
      'Regenera 250 PV por asalto, todos sus negativos por asalto', // 20
      '',
    ];
    return values[index];
  }

  void removeFrom(int value, ConsumableType type) {
    state.consumables.where((element) => element.type == type).first.actualValue -= value;
  }

  String calculateAttack() {
    final weapon = selectedWeapon();

    final modifiers = state.modifiers.getAllModifiersForTypeString(ModifiersType.attack);

    return '${weapon.attack}$modifiers';
  }

  String calculateDefense(DefenseType type) {
    final weapon = selectedWeapon();
    final weaponDefense = weapon.defenseType;

    final modifiers = state.modifiers.getAllModifiersForTypeString(type == DefenseType.dodge ? ModifiersType.dodge : ModifiersType.parry);

    if (weaponDefense == type) {
      return '${weapon.defense}$modifiers';
    } else {
      return '${weapon.defense}-60$modifiers';
    }
  }

  int calculateTurnBase() {
    var totalTurn = selectedWeapon().turn;

    try {
      totalTurn = totalTurn + state.turnModifier.interpret().toInt();
    } catch (e) {
      Logger().d('cannot interpret modifier!');
    }

    return totalTurn + state.modifiers.getAllModifiersForType(ModifiersType.turn);
  }

  List<KeyValue> getCombatItems() {
    final weapon = selectedWeapon();
    final pv = state.getConsumable(ConsumableType.hitPoints)?.maxValue ?? 0;
    var defense = KeyValue(key: 'HE', value: weapon.defense.toString());

    if (weapon.defenseType == DefenseType.parry) {
      defense = KeyValue(key: 'HP', value: weapon.defense.toString());
    }

    return [
      KeyValue(key: 'Turno', value: weapon.turn.toString()),
      KeyValue(key: 'Pv', value: pv.toString()),
      KeyValue(key: 'HA', value: weapon.attack.toString()),
      defense,
      KeyValue(key: weapon.name, value: '${weapon.damage}'),
    ];
  }

  String getResumedSkills() {
    final skillsStr = skills.list().where((element) {
      var value = 0;
      try {
        value = int.parse(element.value);
      } catch (e) {
        Logger().e(e);
      }
      return value > 0;
    }).map((e) => '${e.key}: ${e.value}');

    return skillsStr.join(', ');
  }

  Character copyWith({String? uuid, bool? isNpc, int? number}) {
    return Character(
      uuid: uuid ?? this.uuid,
      attributes: attributes.copy(),
      skills: skills,
      profile: profile.copy(isNpc: isNpc, number: number),
      combat: combat.copy(),
      state: state.copy(),
      ki: ki?.copy(),
      mystical: mystical?.copy(),
      psychic: psychic?.copy(),
      resistances: resistances.copy(),
    );
  }

  bool isOn(String filter) {
    if (filter.isEmpty) return true;

    final string = '${profile.name}${profile.category}lv.${profile.level}level';
    var result = true;

    filter.split(' ').forEach((element) {
      if (!string.normalized.contains(element)) {
        result = false;
      }
    });

    return result;
  }

  String nameNormalized() {
    return profile.name.split('#').first.normalized;
  }
}

class CharacterList {
  CharacterList({required this.characters});

  static CharacterList? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;

    return CharacterList(characters: json.getList('characters').map(Character.fromJson).nonNulls.toList());
  }

  late List<Character> characters;
}

extension on String {
  String get normalized {
    return toLowerCase().replaceAll(' ', '');
  }
}
