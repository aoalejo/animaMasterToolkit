import 'dart:math';

import 'package:amt/models/armour.dart';
import 'package:amt/models/character_model/character.dart';
import 'package:amt/models/enums.dart';
import 'package:amt/models/modifiers_state.dart';
import 'package:amt/models/roll.dart';
import 'package:amt/models/rules/rules.dart';
import 'package:amt/models/weapon.dart';
import 'package:amt/resources/modifiers.dart';
import 'package:amt/utils/explained_text.dart';
import 'package:amt/utils/int_extension.dart';

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
    final rollNumber = roll?.safeInterpret ?? 0;
    final attackBaseNumber = baseAttack?.safeInterpret ?? 0;
    final modifierNumber = modifier?.safeInterpret ?? 0;
    final surpriseNumber = surpriseType == SurpriseType.attacker ? 90 : 0;
    final modifiersNumber = modifiers?.getAllModifiersForType(ModifiersType.attack) ?? 0;

    final total = attackBaseNumber + modifierNumber + rollNumber + modifiersNumber + surpriseNumber;

    return ExplainedText(
      title: 'Ataque final',
      text: 'Resultado en ataque: $total',
      explanation:
          'Base: $attackBaseNumber + Modificador: $modifierNumber + Tirada: $rollNumber + Modificadores: $modifiersNumber + Sorpresa: $surpriseNumber',
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
    final rollNumber = roll?.safeInterpret ?? 0;
    final baseDefenseNumber = baseDefense?.safeInterpret ?? 0;
    final modifierNumber = modifier?.safeInterpret ?? 0;
    final surpriseNumber = surpriseType == SurpriseType.defender ? 90 : 0;
    final modifiersNumber = modifiers?.getAllModifiersForType(defenseType ?? ModifiersType.dodge) ?? 0;
    final numberOfDefensesModifier = CombatRules.numberOfDefensesModifier(defensesNumber);

    final total = modifiersNumber + rollNumber + baseDefenseNumber + numberOfDefensesModifier + modifierNumber + surpriseNumber;

    return ExplainedText(
      title: 'Defensa final',
      text: 'Resultado en defensa: $total',
      explanation:
          'Base: $baseDefenseNumber + Modificador: $modifierNumber + Tirada: $rollNumber + Modificadores: $modifiersNumber + Sorpresa: $surpriseNumber + Penalizador por defensas: $numberOfDefensesModifier',
      result: total,
    );
  }

  static ExplainedText calculateDamage({
    required ExplainedText attackValue,
    required ExplainedText defenseValue,
    required ExplainedText finalAbsorption,
    required int baseDamage,
  }) {
    final info = ExplainedText(title: 'Daño');

    info.explanations.add(attackValue);
    info.explanations.add(defenseValue);
    info.explanations.add(finalAbsorption);

    final difference = (attackValue.result ?? 0) - (defenseValue.result ?? 0);

    final finalResult = (difference - (finalAbsorption.result ?? 0)).roundToTens;
    final damageDone = ((finalResult / 100) * baseDamage).toInt();

    info
      ..add(
        explanation: 'Ataque final: ${attackValue.result}, Defensa final ${defenseValue.result} (Diferencia $difference)',
      )
      ..add(
        explanation: 'Resultado final: $finalResult = diferencia - absorción total, redondeado a decenas',
      )
      ..add(
        explanation: 'Daño base: $baseDamage',
      )
      ..add(
        explanation: 'Daño causado: $damageDone = (Resultado final / 100) * Daño base',
        result: damageDone,
      );

    if (damageDone < 10) {
      info.add(
        explanation: 'Si el daño es menor a 10, impacta pero no realiza daños',
        reference: BookReference(page: 87, book: Books.coreExxet),
        text: 'No realiza daños',
      );
    } else {
      info.text = 'Daño causado: $damageDone';
    }

    info.result = damageDone;
    return info;
  }

  static ExplainedText? calculateCounterBonus({
    required ExplainedText attackValue,
    required ExplainedText defenseValue,
  }) {
    final info = ExplainedText(title: 'Contraataque');

    info.explanations.add(attackValue);
    info.explanations.add(defenseValue);

    final difference = (attackValue.result ?? 0) - (defenseValue.result ?? 0);

    var counterBonus = 0;

    if (difference < 0) {
      counterBonus = (-difference ~/ 2).roundToFives;
      counterBonus = min(counterBonus, 150);

      info.add(
        text: 'Puede contraatacar con un bonificador de: $counterBonus',
        explanation: 'diferencia / 2 redondeado a 5, con un máximo de 150',
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
    final info = ExplainedText(title: 'Absorción');

    final armourTypeBase = armour?.armourFor(damageType) ?? 0;

    final armourTypeModifierNumber = armourTypeModifier?.safeInterpret ?? 0;

    final armourAbsorption = (armourTypeModifierNumber + armourTypeBase) * 10;

    info.add(
      explanation: 'Absorción de armadura = (($armourTypeBase + $armourTypeModifier) * 10)',
    );
    const baseAbsorption = 20;
    info
      ..result = armourAbsorption + baseAbsorption
      ..add(
        text: 'Absorición total: ${info.result}',
        explanation: 'Todos los seres tienen una absorción base de 20 que se suma a la anterior',
        reference: BookReference(page: 86, book: Books.coreExxet),
      );

    return info;
  }

  static int calculateBaseDamage({required Weapon? weapon, required String? damageModifier}) {
    final baseDamageOfWeapon = weapon?.damage ?? 0;
    final baseDamageModifier = damageModifier?.safeInterpret ?? 0;

    return baseDamageOfWeapon + baseDamageModifier;
  }

  static ExplainedText? criticalDamage({required Character? defender, required int? damage}) {
    final info = ExplainedText(title: 'Critico');
    final actualLife = defender?.state.getConsumable(ConsumableType.hitPoints)?.actualValue ?? 999;
    damage = damage ?? 0;

    final porcentualDamage = ((damage / actualLife) * 100).toInt();

    info.add(
      explanation: 'Vida actual: $actualLife, Daño: $porcentualDamage%',
    );

    if (actualLife / 2 < damage) {
      info.add(
        text: 'Realiza un daño crítico',
        explanation: 'Si un ataque daña más de la mitad de la vida actual del objetivo, se considera que realizó un crítico',
        reference: BookReference(page: 95, book: Books.coreExxet),
      );
    } else if (actualLife / 10 < damage) {
      info.add(
        text: 'Realiza un daño crítico si fue apuntado a un punto vital',
        explanation:
            'Si un ataque apuntado a una zona vital daña más de un décimo de la vida actual del objetivo, se considera que realizó un crítico',
        reference: BookReference(page: 96, book: Books.coreExxet),
      );
    } else {
      return null;
    }

    return info;
  }

  static int calculateStrengthBonusOnBreakage(Character? character) {
    final strength = character?.attributes.strength ?? 0;
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
    final roll = localizationRoll?.safeInterpret ?? -1;

    if (roll == -1) return ' - ';
    if (roll >= 91) return '($roll) Cabeza';
    if (roll >= 89) return '($roll) Pierna izquierda - Pie';
    if (roll >= 85) return '($roll) Pierna izquierda - Pantorilla';
    if (roll >= 81) return '($roll) Pierna izquierda - Muslo';
    if (roll >= 79) return '($roll) Pierna derecha - Pie';
    if (roll >= 75) return '($roll) Pierna derecha - Pantorilla';
    if (roll >= 71) return '($roll) Pierna derecha - Muslo';
    if (roll >= 69) return '($roll) Brazo izquierdo - Mano';
    if (roll >= 65) return '($roll) Brazo izquierdo - Antebrazo inferior';
    if (roll >= 61) return '($roll) Brazo izquierdo - Antebrazo superior';
    if (roll >= 59) return '($roll) Brazo derecho - Mano';
    if (roll >= 55) return '($roll) Brazo derecho - Antebrazo inferior';
    if (roll >= 51) return '($roll) Brazo derecho - Antebrazo superior';
    if (roll >= 49) return '($roll) Torso - Corazón';
    if (roll >= 36) return '($roll) Torso - Pecho';
    if (roll >= 31) return '($roll) Torso - Riñones';
    if (roll >= 21) return '($roll) Torso - Estómago';
    if (roll >= 11) return '($roll) Torso - Hombro';
    if (roll >= 1) return '($roll) Torso - Costillas';

    return '$roll';
  }

  static ExplainedText calculateBreakage({
    required Character? attacker,
    required Character? defender,
    required DefenseType defenseType,
  }) {
    final info = ExplainedText(title: 'Rotura');
    final weaponAttacker = attacker?.selectedWeapon();
    final weaponDefender = defender?.selectedWeapon();
    final armourDefender = defender?.combat.armour.armours.firstOrNull?.endurance ?? 999;

    final breakageAttacker = weaponAttacker?.breakage ?? 0;
    final breakageDefender = weaponDefender?.breakage ?? 0;

    final rollAttacker = Roll.d10Roll().roll;
    final rollDefender = Roll.d10Roll().roll;

    final modifierAttacker = CombatRules.calculateStrengthBonusOnBreakage(attacker);
    final modifierDefender = CombatRules.calculateStrengthBonusOnBreakage(defender);

    final totalBreakageAttacker = breakageAttacker + rollAttacker + modifierAttacker;
    info.add(
      explanation: 'Total rotura atacante: Rotura del arma ($breakageAttacker) + tirada ($rollAttacker) + Bono por fuerza ($modifierAttacker)',
      reference: BookReference(page: 91, book: Books.coreExxet),
    );

    final totalBreakageDefender = breakageDefender + rollDefender + modifierDefender;

    // Checks attacker weapon vs defender weapon if parry, and vs armour if dodge
    if (defenseType == DefenseType.parry) {
      info
        ..add(explanation: 'Como hace una parada, se calcula la rotura de ambas armas entre sí')
        ..add(
          explanation: 'Total rotura defensor: Rotura del arma ($breakageDefender) + tirada ($rollDefender) + Bono por fuerza ($modifierDefender)',
        );

      if (totalBreakageDefender > (weaponAttacker?.endurance ?? 999)) {
        info.add(
          text: 'El arma del atacante baja una categoría de calidad',
          explanation:
              'defensor: (${breakageDefender + modifierDefender} + $rollDefender (=$totalBreakageDefender) vs atacante: ${weaponAttacker?.endurance ?? 999})',
        );
      } else {
        info.add(
          explanation:
              'El arma del atacante resiste. defensor: (${breakageDefender + modifierDefender} + $rollDefender (=$totalBreakageDefender) vs atacante: ${weaponAttacker?.endurance ?? 999})',
        );
      }
      if (totalBreakageAttacker > (weaponDefender?.endurance ?? 999)) {
        info.add(
          text: 'El arma del defensor baja una categoría de calidad',
          explanation:
              'atacante: (${breakageAttacker + modifierAttacker} + $rollAttacker (=$totalBreakageAttacker) vs defensor: ${weaponDefender?.endurance ?? 999})',
        );
      } else {
        info.add(
          explanation:
              'El arma del defensor resiste. atacante: (${breakageAttacker + modifierAttacker} + $rollAttacker (=$totalBreakageAttacker) vs defensor: ${weaponDefender?.endurance ?? 999})',
        );
      }
    } else {
      info.add(explanation: 'Como hace una esquiva, se calcula la entereza contra la armadura del defensor solamente');
      if (totalBreakageAttacker > armourDefender) {
        info.add(
          text: 'La armadura del defensor se desgasta',
          explanation:
              'la armadura baja un nivel de TA (${breakageAttacker + modifierAttacker} + $rollAttacker (=$totalBreakageAttacker) vs $armourDefender)',
        );
      } else {
        info.add(
          explanation: 'la armadura resiste: (${breakageAttacker + modifierAttacker} + $rollAttacker (=$totalBreakageAttacker) vs $armourDefender)',
        );
      }
    }

    if (info.text.isEmpty) {
      info.text = 'No se desgastan las armas en el enfrentamiento';
    }

    return info;
  }

  static ExplainedText criticalResult({
    required String? damageDone,
    required String? criticalRoll,
    required String? physicalResistanceBase,
    required String? physicalResistanceRoll,
  }) {
    final damageDoneInt = damageDone?.safeInterpret ?? 0;
    final criticalRollInt = criticalRoll?.safeInterpret ?? 0;

    final physicalResistanceBaseInt = physicalResistanceBase?.safeInterpret ?? 0;
    final physicalResistanceRollInt = physicalResistanceRoll?.safeInterpret ?? 0;

    final result = damageDoneInt + criticalRollInt - physicalResistanceBaseInt - physicalResistanceRollInt;

    return ExplainedText(
      title: 'Resultado Critico',
      text: 'Resultado: $result',
      result: result,
      explanation:
          'Daño realizado ($damageDoneInt) + Tirada ($criticalRollInt) - RF ($physicalResistanceBaseInt) - Tirada RF ($physicalResistanceRollInt) = Resultado ($result)',
    );
  }

  static int criticalResultWithReduction({
    required String? reduction,
    required int? criticalResult,
  }) {
    final reductionInt = reduction?.safeInterpret ?? 0;
    return (criticalResult ?? 0) - reductionInt;
  }

  static List<ExplainedText> criticalDescription({
    required Character? defender,
    required ExplainedText criticalResult,
  }) {
    final list = <ExplainedText>[criticalResult];
    final critical = criticalResult.result ?? 0;

    final criticalEffects = ExplainedText(title: 'Efectos Critico');
    if ((criticalResult.result ?? 0) > 0) {
      list.add(criticalEffects);
    } else {
      return list;
    }

    var text = '';

    if (critical > 1) {
      text = '$text Se recibe un negativo a toda acción de $critical';
      criticalEffects.add(
        explanation: 'El penalizador se recupera a un ritmo de 5 puntos por asalto.',
      );
    }

    if (critical > 50) {
      criticalEffects.add(
        explanation: 'hasta la mitad de su valor',
      );
    }

    if (critical > 100) {
      text = '$text, destrozando si golpea un miembro';

      criticalEffects.add(
        explanation:
            'Si la localización indica un miembro, este queda destrozado o amputado de manera irrecuperable. Si alcanza la cabeza o el corazón, el personaje muere.',
      );
    }

    if (critical > 150) {
      text = '$text y quedando inconsciente. (Muere si no recibe atención médica en ${defender?.attributes.constitution} minutos)';

      criticalEffects.add(
        explanation:
            'Queda además inconsciente automáticamente, y muere en un número de minutos equivalente a su Constitución (${defender?.attributes.constitution}) si no recibe atención médica.',
      );
    }

    criticalEffects.text = text;

    return list;
  }
}
