import 'package:amt/models/character/character.dart';
import 'package:amt/models/enums.dart';
import 'package:amt/models/modifiers_state.dart';
import 'package:amt/resources/modifiers.dart';
import 'package:function_tree/function_tree.dart';

class ScreenCombatStateAttack {
  var attackRoll = "";
  var damageModifier = "";
  var attackModifier = "";

  var damageType = DamageTypes.ene;
  Character? attacker;

  ModifiersState attackingModifiers = ModifiersState();
}

class ScreenCombatStateDefense {
  var defenseRoll = "";
  var armourModifier = "";
  var baseDefenseModifiers = "";

  var defenseType = DefenseType.parry;
  Character? defendant;

  ModifiersState defenderModifiers = ModifiersState();
}

class ScreenCombatStateCritical {
  var criticalRoll = "";
  var localizationRoll = "";
  var physicalResistanceBase = "";
  var physicalResistanceRoll = "";
  var damageDone = "";
  var modifierReduction = "";
}

class ScreenCombatState {
  ScreenCombatStateAttack attack = ScreenCombatStateAttack();
  ScreenCombatStateDefense defense = ScreenCombatStateDefense();
  ScreenCombatStateCritical critical = ScreenCombatStateCritical();

  int finalAttackValue() {
    var roll = 0;
    var attackBase = 0;
    var modifier = 0;

    try {
      roll = attack.attackRoll.interpret().toInt();
    } catch (e) {
      // Defaults to 0
    }

    try {
      attackBase = attack.attacker!.calculateAttack().interpret().toInt();
    } catch (e) {
      // Defaults to 0
    }

    try {
      modifier = attack.attackModifier.interpret().toInt();
    } catch (e) {
      // Defaults to 0
    }

    return attack.attackingModifiers
            .getAllModifiersForType(ModifiersType.attack) +
        roll +
        attackBase +
        modifier;
  }

  int finalDefenseValue() {
    var roll = 0;
    var defenseBase = 0;
    var numberOfDefensesModifier = 0;
    var defenseModifier = 0;
    var surpriseModifier = isSurprised() ? -150 : 0;

    try {
      roll = defense.defenseRoll.interpret().toInt();
    } catch (e) {
      // Defaults to 0
    }

    try {
      defenseBase = defense.defendant!
          .calculateDefense(defense.defenseType)
          .interpret()
          .toInt();
    } catch (e) {
      // Defaults to 0
    }

    try {
      defenseModifier = defense.baseDefenseModifiers.interpret().toInt();
    } catch (e) {
      // Defaults to 0
    }

    switch (defense.defendant?.state.defenseNumber ?? 1) {
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

    return defense.defenderModifiers
            .getAllModifiersForDefense(defense.defenseType) +
        roll +
        defenseBase +
        numberOfDefensesModifier +
        surpriseModifier +
        defenseModifier;
  }

  bool isSurprised() {
    var attackerTurn = attack.attacker?.state.currentTurn.roll ?? 0;
    var defendantTurn = defense.defendant?.state.currentTurn.roll ?? 0;

    return attackerTurn - 150 >= defendantTurn;
  }

  int calculateDamage() {
    var attackValue = finalAttackValue();
    var defenseValue = finalDefenseValue();

    var difference = attackValue - defenseValue;

    var baseDamageCalc = 0;
    var armourType = 0;

    try {
      baseDamageCalc = attack.damageModifier.interpret().toInt();
    } catch (e) {
      // Defaults to 0
    }

    try {
      armourType = defense.armourModifier.interpret().toInt();
    } catch (e) {
      // Defaults to 0
    }

    return ((baseDamageCalc - armourType * 10) * (difference / 100)).toInt();
  }

  String calculateResult() {
    var attackValue = finalAttackValue();
    var defenseValue = finalDefenseValue();

    var difference = attackValue - defenseValue;

    var damage = calculateDamage();

    var critical = "";

    var hitPoints = defense.defendant!.state
        .getConsumable(ConsumableType.hitPoints)
        ?.actualValue;

    if (hitPoints != null && damage >= hitPoints / 2) {
      critical = " Realiza un daño critico";
    }

    if (difference > 0) {
      return "Diferencia: $difference ${isSurprised() ? "(+90: ${difference + 90} Sorprendido!)" : ""}, Daño causado: $damage. $critical";
    } else {
      return "Diferencia: $difference ${isSurprised() ? "(+90: ${difference + 90} Sorprendido!)" : ""}, Contraataca con:  ${-difference ~/ 2}";
    }
  }

  int criticalResult() {
    var damageDoneInt = 0;
    var criticalRollInt = 0;

    var physicalResistanceBaseInt = 0;
    var physicalResistanceRollInt = 0;

    try {
      damageDoneInt = critical.damageDone.interpret().toInt();
    } catch (e) {
      // Defaults to 0
    }

    try {
      criticalRollInt = critical.criticalRoll.interpret().toInt();
    } catch (e) {
      // Defaults to 0
    }

    try {
      physicalResistanceBaseInt =
          critical.physicalResistanceBase.interpret().toInt();
    } catch (e) {
      // Defaults to 0
    }

    try {
      physicalResistanceRollInt =
          critical.physicalResistanceRoll.interpret().toInt();
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
      reduction = critical.modifierReduction.interpret().toInt();
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
      roll = critical.localizationRoll.interpret().toInt();
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
