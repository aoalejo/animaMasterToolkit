import 'package:amt/models/character/consumable_state.dart';
import 'package:amt/models/enums.dart';
import 'package:amt/models/modifiers_state.dart';
import 'package:amt/models/roll.dart';
import 'package:hive/hive.dart';

part 'character_state.g.dart';

@HiveType(typeId: 3, adapterName: "CharacterStateAdapter")
class CharacterState {
  @HiveField(0)
  int selectedWeaponIndex = 0;
  @HiveField(1)
  bool hasAction = true;
  @HiveField(2)
  List<ConsumableState> consumables = [];
  @HiveField(3)
  String notes = "";
  @HiveField(4)
  Roll currentTurn = Roll(description: "", roll: 0, rolls: []);
  @HiveField(5)
  String turnModifier = '';
  @HiveField(6)
  int defenseNumber = 1;
  @HiveField(7)
  ModifiersState modifiers = ModifiersState();

  void updateTurn(String newValue) {
    turnModifier = newValue;
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

  CharacterState({
    this.selectedWeaponIndex = 0,
    this.hasAction = true,
    this.notes = '',
    this.defenseNumber = 1,
    this.turnModifier = '',
    required this.currentTurn,
    required this.consumables,
    required this.modifiers,
  });

  int getLifePointsPercentage() {
    final hitPoints = getConsumable(ConsumableType.hitPoints);

    if (hitPoints == null) return 100;
    if (hitPoints.maxValue == 0) return 100;

    return ((hitPoints.actualValue / hitPoints.maxValue) * 100).toInt();
  }

  CharacterState copy() {
    return CharacterState(
      currentTurn: Roll(description: "", roll: 1, rolls: []),
      consumables: consumables.map((e) => e.copy()).toList(),
      modifiers: ModifiersState(),
    );
  }
}
