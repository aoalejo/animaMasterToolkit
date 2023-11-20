import 'package:amt/models/character/consumable_state.dart';
import 'package:amt/models/modifier_state.dart';
import 'package:amt/models/roll.dart';
import 'package:amt/resources/modifiers.dart';
import 'package:function_tree/function_tree.dart';

class CharacterState {
  int selectedWeaponIndex = 0;
  bool hasAction = true;
  List<ConsumableState> consumables = [];
  String notes = "";
  Roll currentTurn = Roll(description: "", roll: 0);
  int turnModifier = 0;
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
