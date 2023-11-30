import 'package:amt/models/character/consumable_state.dart';
import 'package:amt/models/enums.dart';
import 'package:amt/models/modifiers_state.dart';
import 'package:amt/models/roll.dart';
import 'package:amt/resources/modifiers.dart';
import 'package:function_tree/function_tree.dart';
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
    return consumables.firstWhere((element) => element.type == type);
  }

  CharacterState({
    this.selectedWeaponIndex = 0,
    this.hasAction = true,
    this.notes = "",
    this.defenseNumber = 1,
    this.turnModifier = '',
    required this.currentTurn,
    required this.consumables,
    required this.modifiers,
  });

  int calculateTotalForTurn() {
    var totalTurn = 0;

    try {
      totalTurn = turnModifier.interpret().toInt();
      // ignore: empty_catches
    } catch (e) {
      print("cannot interpret modifier!");
    }

    totalTurn =
        totalTurn + modifiers.getAllModifiersForType(ModifiersType.turn);

    return totalTurn;
  }
}
