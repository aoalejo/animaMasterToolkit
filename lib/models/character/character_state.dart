import 'package:amt/models/character/consumible_state.dart';
import 'package:amt/models/character/status_modifier.dart';
import 'package:amt/models/roll.dart';
import 'package:function_tree/function_tree.dart';

class CharacterState {
  int selectedWeaponIndex = 0;
  bool hasAction = true;
  List<ConsumibleState> consumables = [];
  Set<StatusModifier> modifiers = {};
  String notes = "";
  Roll currentTurn = Roll(description: "", roll: 0);
  int turnModifier = 0;

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

    for (var modifier in modifiers) {
      totalTurn = totalTurn + modifier.turn;
    }

    return totalTurn;
  }
}
