import 'package:amt/models/character/character.dart';
import 'package:amt/models/enums.dart';
import 'package:amt/models/modifiers_state.dart';
import 'package:amt/models/rules/rules.dart';
import 'package:amt/resources/modifiers.dart';
import 'package:amt/utils/explained_text.dart';
import 'package:function_tree/function_tree.dart';

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
    return CombatRules.getCriticalLocalization(critical.criticalRoll);
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

  ExplainedText attackResult() {
    print("attackResult START");

    var info = ExplainedText();

    var damage = CombatRules.calculateDamage(
      attackValue: finalAttackValue,
      defenseValue: finalDefenseValue,
      finalAbsorption: calculateFinalAbsorption,
      baseDamage: CombatRules.calculateBaseDamage(
        weapon: attack.character?.selectedWeapon(),
        damageModifier: attack.damage,
      ),
    );

    info.add(text: damage.text);
    info.explanations.add(damage);

    print("damage ${damage.text}");

    var critical = CombatRules.criticalDamage(
      defender: defense.character,
      damage: damage.result,
    );

    info.add(text: critical.text);
    info.explanations.add(critical);

    print("critical ${critical.text}");

    var counter = CombatRules.calculateCounterBonus(attackValue: finalAttackValue, defenseValue: finalDefenseValue);

    if (counter != null) {
      info.add(text: counter.text);
      info.explanations.add(counter);
    }

    print("counter ${counter?.text}");

    var breakage = CombatRules.calculateBreakage(
      attacker: attack.character,
      defender: defense.character,
      defenseType: defense.defenseType,
    );

    info.add(text: breakage.text);
    info.explanations.add(breakage);

    print("breakage ${breakage.text}");
    print("Final text ${info.text}");
    return info;
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
      physicalResistanceBaseInt = critical.physicalResistanceBase.interpret().toInt();
    } catch (e) {
      // Defaults to 0
    }

    try {
      physicalResistanceRollInt = critical.physicalResistanceRoll.interpret().toInt();
    } catch (e) {
      // Defaults to 0
    }

    var result = damageDoneInt + criticalRollInt - physicalResistanceBaseInt - physicalResistanceRollInt;

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
      description = '$description:\nSe recibe un negativo a toda acción de $critical. El penalizador se recupera a un ritmo de 5 puntos por asalto.';
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
}
