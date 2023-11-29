import 'package:amt/models/character/consumable_state.dart';
import 'package:amt/models/modifier_state.dart';
import 'package:amt/models/roll.dart';
import 'package:amt/resources/modifiers.dart';
import 'package:function_tree/function_tree.dart';
import 'package:hive/hive.dart';

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
  int turnModifier = 0;
  @HiveField(6)
  int defenseNumber = 0;
  @HiveField(7)
  ModifiersState modifiers = ModifiersState();

  void updateTurn(String newValue) {
    try {
      turnModifier = newValue.interpret().toInt();
    } catch (e) {
      turnModifier = 0;
    }
  }

  CharacterState({
    this.selectedWeaponIndex = 0,
    this.hasAction = true,
    this.notes = "",
    this.defenseNumber = 0,
    this.turnModifier = 0,
    required this.currentTurn,
    required this.consumables,
    required this.modifiers,
  });

  int calculateTotalForTurn() {
    var totalTurn = turnModifier;

    totalTurn = modifiers.getAllModifiersForType(ModifiersType.turn);

    return totalTurn;
  }
}
