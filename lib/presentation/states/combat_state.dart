import 'package:amt/models/character/character.dart';
import 'package:amt/models/enums.dart';
import 'package:amt/models/modifiers_state.dart';
import 'package:amt/models/rules/rules.dart';
import 'package:amt/resources/modifiers.dart';
import 'package:amt/utils/explained_text.dart';

class ScreenCombatStateAttack {
  var roll = "";
  var damage = "";
  var attack = "";

  var damageType = DamageTypes.ene;
  Character? character;

  ModifiersState modifiers = ModifiersState();
}

class ScreenCombatStateDefense {
  var roll = "";
  var armour = "";
  var defense = "";

  var defenseType = DefenseType.parry;
  Character? character;

  ModifiersState modifiers = ModifiersState();
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
    List<ExplainedText> result = [];

    var damage = calculateDamage();

    result.add(damage);

    var critical = CombatRules.criticalDamage(
      defender: defense.character,
      damage: damage.result,
    );

    if (critical != null) result.add(critical);

    var counter = CombatRules.calculateCounterBonus(attackValue: finalAttackValue, defenseValue: finalDefenseValue);

    if (counter != null) {
      result.add(counter);
    }

    print("counter ${counter?.text}");

    var breakage = CombatRules.calculateBreakage(
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
