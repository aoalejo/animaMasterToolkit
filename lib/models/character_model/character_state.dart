import 'package:amt/models/character_model/consumable_state.dart';
import 'package:amt/models/enums.dart';
import 'package:amt/models/modifiers_state.dart';
import 'package:amt/models/roll.dart';
import 'package:amt/utils/json_utils.dart';
import 'package:hive/hive.dart';

part 'character_state.g.dart';

@HiveType(typeId: 3, adapterName: 'CharacterStateAdapter')
class CharacterState {
  CharacterState({
    required this.currentTurn,
    required this.consumables,
    required this.modifiers,
    this.selectedWeaponIndex = 0,
    this.hasAction = true,
    this.notes = '',
    this.defenseNumber = 1,
    this.turnModifier = '',
    this.isSurprised = 0,
  });
  @HiveField(0)
  int selectedWeaponIndex = 0;
  @HiveField(1)
  bool hasAction = true;
  @HiveField(2)
  List<ConsumableState> consumables = [];
  @HiveField(3)
  String notes = '';
  @HiveField(4)
  Roll currentTurn = Roll(description: '', roll: 0, rolls: []);
  @HiveField(5)
  String turnModifier = '';
  @HiveField(6)
  int defenseNumber = 1;
  @HiveField(7)
  ModifiersState modifiers = ModifiersState();
  @HiveField(8)
  int isSurprised;

  Map<String, dynamic> toJson() {
    return {
      'currentTurn': currentTurn.toJson(),
      'consumables': consumables.map((e) => e.toJson()).toList(),
      'modifiers': modifiers.toJson(),
      'selectedWeaponIndex': selectedWeaponIndex,
      'hasAction': hasAction,
      'notes': notes,
      'defenseNumber': defenseNumber,
      'turnModifier': turnModifier,
      'isSurprised': isSurprised,
    };
  }

  static CharacterState? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;

    final consumables = json.getList('consumables').map(ConsumableState.fromJson).nonNulls.toList();

    return CharacterState(
      currentTurn: Roll.fromJson(json.getMap('currentTurn')) ?? Roll(description: '', roll: 0, rolls: []),
      consumables: consumables,
      modifiers: ModifiersState.fromJson(json.getMap('modifiers')) ?? ModifiersState(),
      selectedWeaponIndex: JsonUtils.integer(json['selectedWeaponIndex'], 0),
      hasAction: JsonUtils.boolean(json['hasAction']),
      notes: JsonUtils.string(json['notes'], ''),
      defenseNumber: JsonUtils.integer(json['defenseNumber'], 1),
      turnModifier: JsonUtils.string(json['turnModifier'], ''),
      isSurprised: JsonUtils.integer(json['isSurprised'], 0),
    );
  }

  ConsumableState? getConsumable(ConsumableType type) {
    try {
      return consumables.firstWhere((element) => element.type == type);
    } catch (e) {
      return ConsumableState(
        actualValue: 0,
        maxValue: 0,
        name: '',
        step: 1,
        description: '',
      );
    }
  }

  int getLifePointsPercentage() {
    final hitPoints = getConsumable(ConsumableType.hitPoints);

    if (hitPoints == null) return 100;
    if (hitPoints.maxValue == 0) return 100;

    return ((hitPoints.actualValue / hitPoints.maxValue) * 100).toInt();
  }

  int getOtherConsumablePercentage() {
    final other = consumables.where((element) => element.type == ConsumableType.other).firstOrNull ?? getConsumable(ConsumableType.fatigue);

    if (other == null) return 100;

    try {
      return ((other.actualValue / other.maxValue) * 100).toInt();
    } catch (e) {
      return 100;
    }
  }

  ConsumableState? getFirstOtherConsumable() {
    final other = consumables.where((element) => element.type == ConsumableType.other).firstOrNull ?? getConsumable(ConsumableType.fatigue);

    return other;
  }

  CharacterState copy() {
    return CharacterState(
      currentTurn: Roll(description: '', roll: 1, rolls: []),
      consumables: consumables.map((e) => e.copy()).toList(),
      modifiers: ModifiersState(),
    );
  }
}
