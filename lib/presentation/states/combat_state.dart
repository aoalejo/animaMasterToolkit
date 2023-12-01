import 'dart:math';

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

  String attackingCharacter = "";
  String defendantCharacter = "";

  var criticalRoll = "";
  var localizationRoll = "";
  var physicalResistanceBase = "";
  var physicalResistanceRoll = "";
  var damageDone = "";
  var modifierReduction = "";

  var actualHitPoints = 0;

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

    var damage = calculateDamage();

    var critical = "";

    if (damage >= actualHitPoints / 2) {
      critical = " Realiza un daño critico";
    }

    if (difference > 0) {
      return "Diferencia: $difference ${isSurprised() ? "(+80: ${difference + 80} Sorprendido!)" : ""}, Daño causado: $damage. $critical";
    } else {
      return "Diferencia: $difference ${isSurprised() ? "(+80: ${difference + 80} Sorprendido!)" : ""}, Contraataca con:  ${-difference ~/ 2}";
    }
  }

  int criticalResult() {
    var damageDoneInt = 0;
    var criticalRollInt = 0;

    var physicalResistanceBaseInt = 0;
    var physicalResistanceRollInt = 0;

    try {
      damageDoneInt = damageDone.interpret().toInt();
    } catch (e) {
      // Defaults to 0
    }

    try {
      criticalRollInt = criticalRoll.interpret().toInt();
    } catch (e) {
      // Defaults to 0
    }

    try {
      physicalResistanceBaseInt = physicalResistanceBase.interpret().toInt();
    } catch (e) {
      // Defaults to 0
    }

    try {
      physicalResistanceRollInt = physicalResistanceRoll.interpret().toInt();
    } catch (e) {
      // Defaults to 0
    }

    var result = damageDoneInt +
        criticalRollInt -
        physicalResistanceBaseInt -
        physicalResistanceRollInt;

    return result;
  }

  int criticalResultWithReduction() {
    var reduction = 0;
    var calculated = criticalResult();
    try {
      reduction = modifierReduction.interpret().toInt();
    } catch (e) {
      return calculated;
    }

    return calculated - reduction;
  }

  String criticalDescription() {
    var critical = criticalResult();
    var description = "Resultado de $critical";

    if (critical > 1) {
      description =
          '$description:\nSe recibe un negativo a toda acción de $critical. El penalizador se recupera a un ritmo de 5 puntos por asalto.';
    }

    if (critical > 50) {
      description = '$description hasta la mitad de su valor';
    }

    if (critical > 100) {
      description =
          '$description \nSi la localización indica un miembro, este queda destrozado o amputado de manera irrecuperable. Si alcanza la cabeza o el corazón, el personaje muere.';
    }

    if (critical > 150) {
      description =
          '$description \nqueda además inconsciente automáticamente, y muere en un número de minutos equivalente a su Constitución si no recibe atención médica.';
    }

    return description;
  }

  String getCriticalLocalization() {
    var roll = -1;

    try {
      roll = localizationRoll.interpret().toInt();
    } catch (e) {
      return " - ";
    }

    if (roll == -1) return " - ";

    if (roll >= 91) return "($roll) Cabeza";

    if (roll >= 89) return "($roll) Pierna izquierda - Pie";

    if (roll >= 85) return "($roll) Pierna izquierda - Pantorilla";

    if (roll >= 81) return "($roll) Pierna izquierda - Muslo";

    if (roll >= 79) return "($roll) Pierna derecha - Pie";

    if (roll >= 75) return "($roll) Pierna derecha - Pantorilla";

    if (roll >= 71) return "($roll) Pierna derecha - Muslo";

    if (roll >= 69) return "($roll) Brazo izquierdo - Mano";

    if (roll >= 65) return "($roll) Brazo izquierdo - Antebrazo inferior";

    if (roll >= 61) return "($roll) Brazo izquierdo - Antebrazo superior";

    if (roll >= 59) return "($roll) Brazo derecho - Mano";

    if (roll >= 55) return "($roll) Brazo derecho - Antebrazo inferior";

    if (roll >= 51) return "($roll) Brazo derecho - Antebrazo superior";

    if (roll >= 49) return "($roll) Torso - Corazón";

    if (roll >= 36) return "($roll) Torso - Pecho";

    if (roll >= 31) return "($roll) Torso - Riñones";

    if (roll >= 21) return "($roll) Torso - Estómago";

    if (roll >= 11) return "($roll) Torso - Hombro";

    if (roll >= 1) return "($roll) Torso - Costillas";

    return "$roll";
  }
}
