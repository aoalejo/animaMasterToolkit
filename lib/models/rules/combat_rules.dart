import 'dart:math';

import 'package:amt/models/armour.dart';
import 'package:amt/models/character/character.dart';
import 'package:amt/models/enums.dart';
import 'package:amt/models/modifiers_state.dart';
import 'package:amt/models/roll.dart';
import 'package:amt/models/rules/rules.dart';
import 'package:amt/models/weapon.dart';
import 'package:amt/resources/modifiers.dart';
import 'package:amt/utils/explained_text.dart';
import 'package:amt/utils/int_extension.dart';
import 'package:function_tree/function_tree.dart';

class CombatRules {
  static int numberOfDefensesModifier(int? defenseNumber) {
    switch (defenseNumber ?? 1) {
      case 0:
      case 1:
        return 0;
      case 2:
        return -30;
      case 3:
        return -50;
      case 4:
        return -70;
      default:
        return -90;
    }
  }

  static ExplainedText finalAttackValue({
    required String? roll,
    required String? baseAttack,
    required String? modifier,
    required SurpriseType? surpriseType,
    required ModifiersState? modifiers,
  }) {
    var rollNumber = roll?.safeInterpret ?? 0;
    var attackBaseNumber = baseAttack?.safeInterpret ?? 0;
    var modifierNumber = modifier?.safeInterpret ?? 0;
    var surpriseNumber = surpriseType == SurpriseType.attacker ? 90 : 0;
    var modifiersNumber = modifiers?.getAllModifiersForType(ModifiersType.attack) ?? 0;

    var total = attackBaseNumber + modifierNumber + rollNumber + modifiersNumber + surpriseNumber;

    return ExplainedText(
      title: "Ataque final",
      text: "Resultado en ataque: $total",
      explanation:
          "Base: $attackBaseNumber + Modificador: $modifierNumber + Tirada: $rollNumber + Modificadores: $modifiersNumber + Sorpresa: $surpriseNumber",
      result: total,
    );
  }

  static ExplainedText finalDefenseValue({
    required String? roll,
    required String? baseDefense,
    required String? modifier,
    required SurpriseType? surpriseType,
    required ModifiersState? modifiers,
    required ModifiersType? defenseType,
    required int? defensesNumber,
  }) {
    var rollNumber = roll?.safeInterpret ?? 0;
    var baseDefenseNumber = baseDefense?.safeInterpret ?? 0;
    var modifierNumber = modifier?.safeInterpret ?? 0;
    var surpriseNumber = surpriseType == SurpriseType.defender ? 90 : 0;
    var modifiersNumber = modifiers?.getAllModifiersForType(defenseType ?? ModifiersType.dodge) ?? 0;
    var numberOfDefensesModifier = CombatRules.numberOfDefensesModifier(defensesNumber);

    var total = modifiersNumber + rollNumber + baseDefenseNumber + numberOfDefensesModifier + modifierNumber + surpriseNumber;

    return ExplainedText(
      title: "Defensa final",
      text: "Resultado en defensa: $total",
      explanation:
          "Base: $baseDefenseNumber + Modificador: $modifierNumber + Tirada: $rollNumber + Modificadores: $modifiersNumber + Sorpresa: $surpriseNumber + Penalizador por defensas: $numberOfDefensesModifier",
      result: total,
    );
  }

  static ExplainedText calculateDamage({
    required ExplainedText attackValue,
    required ExplainedText defenseValue,
    required ExplainedText finalAbsorption,
    required int baseDamage,
  }) {
    var info = ExplainedText(title: "Daño");

    info.explanations.add(attackValue);
    info.explanations.add(defenseValue);
    info.explanations.add(finalAbsorption);

    var difference = (attackValue.result ?? 0) - (defenseValue.result ?? 0);

    var finalResult = (difference - (finalAbsorption.result ?? 0)).roundToTens;
    var damageDone = ((finalResult / 100) * baseDamage).toInt();

    info.add(
      explanation: "Ataque final: ${attackValue.result}, Defensa final ${defenseValue.result} (Diferencia $difference)",
    );

    info.add(
      explanation: "Resultado final: $finalResult = diferencia - absorción total, redondeado a decenas",
    );

    info.add(
      explanation: "Daño base: $baseDamage",
    );

    info.add(
      explanation: "Daño causado: $damageDone = (Resultado final / 100) * Daño base",
      result: damageDone,
    );

    if (damageDone < 10) {
      info.add(
        explanation: "Si el daño es menor a 10, impacta pero no realiza daños",
        reference: BookReference(page: 87, book: Books.coreExxet),
        text: "No realiza daños",
      );
    } else {
      info.text = "Daño causado: $damageDone";
    }

    info.result = damageDone;
    return info;
  }

  static ExplainedText? calculateCounterBonus({
    required ExplainedText attackValue,
    required ExplainedText defenseValue,
  }) {
    var info = ExplainedText(title: "Contraataque");

    info.explanations.add(attackValue);
    info.explanations.add(defenseValue);

    var difference = (attackValue.result ?? 0) - (defenseValue.result ?? 0);

    var counterBonus = 0;

    if (difference < 0) {
      counterBonus = (-difference ~/ 2).roundToFives;
      counterBonus = min(counterBonus, 150);

      info.add(
        text: "Puede contraatacar con un bonificador de: $counterBonus",
        explanation: "diferencia / 2 redondeado a 5, con un máximo de 150",
        reference: BookReference(page: 87, book: Books.coreExxet),
      );
    } else {
      return null;
    }

    return info;
  }

  static ExplainedText calculateFinalAbsorption({
    required Armour? armour,
    required DamageTypes damageType,
    required String? armourTypeModifier,
  }) {
    var info = ExplainedText(title: "Absorción");

    var armourTypeBase = armour?.armourFor(damageType) ?? 0;

    var armourTypeModifierNumber = armourTypeModifier?.safeInterpret ?? 0;

    var armourAbsorption = (armourTypeModifierNumber + armourTypeBase) * 10;

    info.add(
      explanation: "Absorción de armadura = (($armourTypeBase + $armourTypeModifier) * 10)",
    );
    var baseAbsorption = 20;
    info.result = armourAbsorption + baseAbsorption;

    info.add(
      text: "Absorición total: ${info.result}",
      explanation: "Todos los seres tienen una absorción base de 20 que se suma a la anterior",
      reference: BookReference(page: 86, book: Books.coreExxet),
    );

    return info;
  }

  static int calculateBaseDamage({required Weapon? weapon, required String? damageModifier}) {
    var baseDamageOfWeapon = weapon?.damage ?? 0;
    var baseDamageModifier = damageModifier?.safeInterpret ?? 0;

    return baseDamageOfWeapon + baseDamageModifier;
  }

  static ExplainedText? criticalDamage({required Character? defender, required int? damage}) {
    var info = ExplainedText(title: "Critico");
    var actualLife = (defender?.state.getConsumable(ConsumableType.hitPoints)?.actualValue ?? 999);
    damage = damage ?? 0;

    var porcentualDamage = ((damage / actualLife) * 100).toInt();

    info.add(
      explanation: "Vida actual: $actualLife, Daño: $porcentualDamage%",
    );

    if (actualLife / 2 < damage) {
      info.add(
        text: "Realiza un daño crítico",
        explanation: "Si un ataque daña más de la mitad de la vida actual del objetivo, se considera que realizó un crítico",
        reference: BookReference(page: 95, book: Books.coreExxet),
      );
    } else if (actualLife / 10 < damage) {
      info.add(
        text: "Realiza un daño crítico si fue apuntado a un punto vital",
        explanation:
            "Si un ataque apuntado a una zona vital daña más de un décimo de la vida actual del objetivo, se considera que realizó un crítico",
        reference: BookReference(page: 96, book: Books.coreExxet),
      );
    } else {
      return null;
    }

    return info;
  }

  static int calculateStrengthBonusOnBreakage(Character? character) {
    var strength = character?.attributes.strength ?? 0;
    if (strength == 8 || strength == 9) {
      return 1;
    }
    if (strength == 10) {
      return 2;
    }
    if (strength == 11 || strength == 12) {
      return 3;
    }
    if (strength == 13 || strength == 14) {
      return 4;
    }
    if (strength > 15) {
      return 5;
    }

    return 0;
  }

  static String getCriticalLocalization(String? localizationRoll) {
    var roll = localizationRoll?.safeInterpret ?? -1;

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

  static ExplainedText calculateBreakage({
    required Character? attacker,
    required Character? defender,
    required DefenseType defenseType,
  }) {
    var info = ExplainedText(title: "Rotura");
    var weaponAttacker = attacker?.selectedWeapon();
    var weaponDefender = defender?.selectedWeapon();
    var armourDefender = (defender?.combat.armour.armours.firstOrNull?.endurance ?? 999);

    var breakageAttacker = (weaponAttacker?.breakage ?? 0);
    var breakageDefender = (weaponDefender?.breakage ?? 0);

    var rollAttacker = Roll.d10Roll().roll;
    var rollDefender = Roll.d10Roll().roll;

    var modifierAttacker = CombatRules.calculateStrengthBonusOnBreakage(attacker);
    var modifierDefender = CombatRules.calculateStrengthBonusOnBreakage(defender);

    var totalBreakageAttacker = breakageAttacker + rollAttacker + modifierAttacker;
    info.add(
      explanation: "Total rotura atacante: Rotura del arma ($breakageAttacker) + tirada ($rollAttacker) + Bono por fuerza ($modifierAttacker)",
      reference: BookReference(page: 91, book: Books.coreExxet),
    );

    var totalBreakageDefender = breakageDefender + rollDefender + modifierDefender;

    // Checks attacker weapon vs defender weapon if parry, and vs armour if dodge
    if (defenseType == DefenseType.parry) {
      info.add(explanation: "Como hace una parada, se calcula la rotura de ambas armas entre sí");

      info.add(
        explanation: "Total rotura defensor: Rotura del arma ($breakageDefender) + tirada ($rollDefender) + Bono por fuerza ($modifierDefender)",
      );

      if (totalBreakageDefender > (weaponAttacker?.endurance ?? 999)) {
        info.add(
          text: "El arma del atacante baja una categoría de calidad",
          explanation:
              "defensor: (${breakageDefender + modifierDefender} + $rollDefender (=$totalBreakageDefender) vs atacante: ${(weaponAttacker?.endurance ?? 999)})",
        );
      } else {
        info.add(
          explanation:
              "El arma del atacante resiste. defensor: (${breakageDefender + modifierDefender} + $rollDefender (=$totalBreakageDefender) vs atacante: ${(weaponAttacker?.endurance ?? 999)})",
        );
      }
      if (totalBreakageAttacker > (weaponDefender?.endurance ?? 999)) {
        info.add(
          text: "El arma del defensor baja una categoría de calidad",
          explanation:
              "atacante: (${breakageAttacker + modifierAttacker} + $rollAttacker (=$totalBreakageAttacker) vs defensor: ${(weaponDefender?.endurance ?? 999)})",
        );
      } else {
        info.add(
          explanation:
              "El arma del defensor resiste. atacante: (${breakageAttacker + modifierAttacker} + $rollAttacker (=$totalBreakageAttacker) vs defensor: ${(weaponDefender?.endurance ?? 999)})",
        );
      }
    } else {
      info.add(explanation: "Como hace una esquiva, se calcula la entereza contra la armadura del defensor solamente");
      if (totalBreakageAttacker > armourDefender) {
        info.add(
          text: "La armadura del defensor se desgasta",
          explanation:
              "la armadura baja un nivel de TA (${breakageAttacker + modifierAttacker} + $rollAttacker (=$totalBreakageAttacker) vs $armourDefender)",
        );
      } else {
        info.add(
          explanation: "la armadura resiste: (${breakageAttacker + modifierAttacker} + $rollAttacker (=$totalBreakageAttacker) vs $armourDefender)",
        );
      }
    }

    if (info.text.isEmpty) {
      info.text = "No se desgastan las armas en el enfrentamiento";
    }

    return info;
  }
}

extension on String {
  int get safeInterpret {
    try {
      return interpret().toInt();
    } catch (e) {
      return 0;
    }
  }
}
