import 'package:amt/models/character/consumible_state.dart';
import 'package:amt/models/character/status_modifier.dart';
import 'package:amt/models/roll.dart';

class CharacterState {
  int selectedWeaponIndex = 0;
  bool hasAction = true;
  List<ConsumibleState> consumables = [];
  List<StatusModifier> modifiers = [];
  String notes = "";
  Roll currentTurn = Roll(description: "", roll: 0);
  int turnModifier = 0;

  CharacterState({
    this.selectedWeaponIndex = 0,
    this.hasAction = true,
    this.notes = "",
    required this.currentTurn,
    required this.consumables,
    required this.modifiers,
  });
}
