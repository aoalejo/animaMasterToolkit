import 'package:amt/models/armour.dart';
import 'package:amt/models/enums.dart';
import 'package:amt/models/modifiers_state.dart';
import 'package:amt/models/weapon.dart';
import 'package:amt/resources/modifiers.dart';
import 'package:function_tree/function_tree.dart';

class ScreenCombatState {
  var attackRoll = "";
  var baseDamage = "";
  var baseAttack = "";
  var damageType = DamageTypes.ene;

  var defenseRoll = "";
  var armour = "";
  var baseDefense = "";

  var finalTurnAttacker = 0;
  var finalTurnDefense = 0;

  var defenseType = DefenseType.parry;
  var defenseNumber = 0;

  int attackingCharacter = 0;
  int defendantCharacter = 0;

  Weapon selectedWeapon = Weapon(
      name: "",
      turn: 0,
      attack: 0,
      defense: 0,
      defenseType: DefenseType.dodge,
      principalDamage: DamageTypes.pen,
      damage: 0);

  Armour selectedArmour = Armour();

  ModifiersState attackingModifiers = ModifiersState();
  ModifiersState defenderModifiers = ModifiersState();

  int finalAttackValue() {
    var roll = 0;
    var attack = 0;

    try {
      roll = attackRoll.interpret().toInt();
    } catch (e) {
      // Defaults to 0
    }

    try {
      attack = baseAttack.interpret().toInt();
    } catch (e) {
      // Defaults to 0
    }

    return attackingModifiers.getAllModifiersForType(ModifiersType.attack) +
        roll +
        attack;
  }

  int finalDefenseValue() {
    var roll = 0;
    var defense = 0;
    var numberOfDefensesModifier = 0;
    var surpriseModifier = isSurprised() ? -150 : 0;

    try {
      roll = defenseRoll.interpret().toInt();
    } catch (e) {
      // Defaults to 0
    }

    try {
      defense = baseDefense.interpret().toInt();
    } catch (e) {
      // Defaults to 0
    }

    switch (defenseNumber) {
      case 1:
        numberOfDefensesModifier = 0;
      case 2:
        numberOfDefensesModifier = -30;
      case 3:
        numberOfDefensesModifier = -50;
      case 4:
        numberOfDefensesModifier = -70;
      case 5:
        numberOfDefensesModifier = -90;
    }

    return defenderModifiers.getAllModifiersForDefense(defenseType) +
        roll +
        defense +
        numberOfDefensesModifier +
        surpriseModifier;
  }

  bool isSurprised() {
    return finalTurnAttacker - 150 >= finalTurnDefense;
  }

  int calculateDamage() {
    var attack = finalAttackValue();
    var defense = finalDefenseValue();

    var difference = attack - defense;

    var baseDamageCalc = 0;
    var armourType = 0;

    try {
      baseDamageCalc = baseDamage.interpret().toInt();
    } catch (e) {
      // Defaults to 0
    }

    try {
      armourType = armour.interpret().toInt();
    } catch (e) {
      // Defaults to 0
    }

    return ((baseDamageCalc - armourType * 10) * (difference / 100)).toInt();
  }

  String combatTotal() {
    var attack = finalAttackValue();
    var defense = finalDefenseValue();

    var difference = attack - defense;

    if (difference > 0) {
      return "Diferencia: $difference ${isSurprised() ? "(+80: ${difference + 80} Sorprendido!)" : ""}, Daño causado: ${calculateDamage()} ";
    } else {
      return "Diferencia: $difference ${isSurprised() ? "(+80: ${difference + 80} Sorprendido!)" : ""}, Contraataca con:  ${-difference ~/ 2}";
    }
  }
}
