import 'package:amt/models/character/character.dart';
import 'package:amt/models/enums.dart';
import 'package:amt/models/modifiers_state.dart';
import 'package:amt/models/rules/rules.dart';
import 'package:amt/resources/modifiers.dart';
import 'package:amt/utils/explained_text.dart';
import 'package:logger/web.dart';

class ScreenCombatStateAttack {
  String roll = '';
  String damage = '';
  String attack = '';

  DamageTypes damageType = DamageTypes.ene;
  Character? character;

  ModifiersState modifiers = ModifiersState();
}

class ScreenCombatStateDefense {
  String roll = '';
  String armour = '';
  String defense = '';

  DefenseType defenseType = DefenseType.parry;
  Character? character;

  ModifiersState modifiers = ModifiersState();
}

class ScreenCombatStateCritical {
  String criticalRoll = '';
  String localizationRoll = '';
  String physicalResistanceBase = '';
  String physicalResistanceRoll = '';
  String damageDone = '';
  String modifierReduction = '';
}

class ScreenCombatState {
  ScreenCombatStateAttack attack = ScreenCombatStateAttack();
  ScreenCombatStateDefense defense = ScreenCombatStateDefense();
  ScreenCombatStateCritical critical = ScreenCombatStateCritical();
  SurpriseType surpriseType = SurpriseType.none;

  String get criticalLocalization {
    return CombatRules.getCriticalLocalization(critical.localizationRoll);
  }

  ExplainedText get finalAttackValue {
    return CombatRules.finalAttackValue(
      roll: attack.roll,
      baseAttack: attack.character?.calculateAttack(),
      modifier: attack.attack,
      surpriseType: surpriseType,
      modifiers: attack.modifiers,
    );
  }

  ExplainedText get finalDefenseValue {
    return CombatRules.finalDefenseValue(
      roll: defense.roll,
      baseDefense: defense.character?.calculateDefense(defense.defenseType),
      modifier: defense.defense,
      surpriseType: surpriseType,
      modifiers: defense.modifiers,
      defenseType: defense.defenseType.toModifierType(),
      defensesNumber: defense.character?.state.defenseNumber,
    );
  }

  ExplainedText get calculateFinalAbsorption {
    return CombatRules.calculateFinalAbsorption(
      armour: defense.character?.combat.armour.calculatedArmour,
      damageType: attack.damageType,
      armourTypeModifier: defense.armour,
    );
  }

  ExplainedText calculateDamage() {
    return CombatRules.calculateDamage(
      attackValue: finalAttackValue,
      defenseValue: finalDefenseValue,
      finalAbsorption: calculateFinalAbsorption,
      baseDamage: CombatRules.calculateBaseDamage(
        weapon: attack.character?.selectedWeapon(),
        damageModifier: attack.damage,
      ),
    );
  }

  List<ExplainedText> attackResult() {
    final result = <ExplainedText>[];

    final damage = calculateDamage();

    result.add(damage);

    final critical = CombatRules.criticalDamage(
      defender: defense.character,
      damage: damage.result,
    );

    if (critical != null) result.add(critical);

    final counter = CombatRules.calculateCounterBonus(attackValue: finalAttackValue, defenseValue: finalDefenseValue);

    if (counter != null) {
      result.add(counter);
    }

    Logger().d('counter ${counter?.text}');

    final breakage = CombatRules.calculateBreakage(
      attacker: attack.character,
      defender: defense.character,
      defenseType: defense.defenseType,
    );

    result.add(breakage);

    return result;
  }

  int criticalResultWithReduction({
    required int? criticalResult,
  }) {
    return CombatRules.criticalResultWithReduction(
      reduction: critical.modifierReduction,
      criticalResult: criticalResult,
    );
  }

  ExplainedText criticalResult() {
    return CombatRules.criticalResult(
      damageDone: critical.damageDone,
      criticalRoll: critical.criticalRoll,
      physicalResistanceBase: critical.physicalResistanceBase,
      physicalResistanceRoll: critical.physicalResistanceRoll,
    );
  }

  List<ExplainedText> criticalEffects(ExplainedText criticalResult) {
    return CombatRules.criticalDescription(
      defender: defense.character,
      criticalResult: criticalResult,
    );
  }
}
