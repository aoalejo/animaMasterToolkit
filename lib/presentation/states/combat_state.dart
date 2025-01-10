import 'package:amt/models/character_model/character.dart';
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
      defender: defense.character,
    );
  }

  ExplainedText get calculateFinalAbsorption {
    return CombatRules.calculateFinalAbsorption(
      armour: defense.character?.combat.armour.calculatedArmour,
      damageType: attack.damageType,
      armourTypeModifier: defense.armour,
      defender: defense.character,
      surpriseType: surpriseType,
    );
  }

  ExplainedText? calculateDamage() {
    return CombatRules.calculateDamage(
      attackValue: finalAttackValue,
      defenseValue: finalDefenseValue,
      finalAbsorption: calculateFinalAbsorption,
      baseDamage: CombatRules.calculateBaseDamage(
        weapon: attack.character?.selectedWeapon(),
        damageModifier: attack.damage,
      ),
      defender: defense.character,
    );
  }

  List<ExplainedText> attackResult() {
    final result = <ExplainedText>[];

    final damage = calculateDamage();

    if (damage != null) result.add(damage);

    final additionalRules = ExplainedText(
      title: 'Reglas a tener en cuenta',
      text: 'Reglas a tener en cuenta',
      explanation: 'Algunas reglas que se utilizaron para este cálculo',
    );

    if (defense.character?.profile.damageAccumulation ?? false) {
      additionalRules.explanations
        ..add(
          ExplainedText(
            title: 'Doble daño según área de ataque',
            text: 'Doble daño según área de ataque',
            explanation:
                'Si una criatura con acumulación recibe un Ataque con un área que cubra por lo menos la mitad de su cuerpo, recibirá el doble de daño de lo que indique el resultado',
            reference: BookReference(
              page: 97,
              book: Books.coreExxet,
            ),
            specialRule: SpecialRule.damageAccumulation,
          ),
        )
        ..add(
          ExplainedText(
            title: 'Sorpresa en el ataque',
            text: 'Sorpresa en el ataque',
            explanation:
                'Si la sorpresa ha sido provocada por no saber dónde se encuentra su adversario no puede realizar una devolución ese asalto en contra de dicho individuo.',
            reference: BookReference(
              page: 97,
              book: Books.coreExxet,
            ),
            specialRule: SpecialRule.damageAccumulation,
          ),
        );
    }

    if ((attack.character?.profile.uroboros ?? false) || (defense.character?.profile.uroboros ?? false)) {
      additionalRules.explanations.add(
        ExplainedText(
          title: 'La Sangre de Uroboros',
          text: 'La Sangre de Uroboros',
          explanation:
              'Legado de Uroboros obtiene Sorpresa contra cualquier adversario, superándolo simplemente por un resultado de 100 puntos en lugar de necesitar 150. '
              'Ademas, cuando declara que desea retirarse de un combate, no aplica el penalizador de Flanco a su habilidad de defensa',
          reference: BookReference(
            page: 77,
            book: Books.prometheus,
          ),
          specialRule: SpecialRule.uruboros,
        ),
      );
    }

    if (additionalRules.explanations.isNotEmpty) {
      result.add(additionalRules);
    }

    final critical = CombatRules.criticalDamage(
      defender: defense.character,
      damage: damage?.result ?? 0,
    );

    if (critical != null) result.add(critical);

    final counter = CombatRules.calculateCounterBonus(
      attackValue: finalAttackValue,
      defenseValue: finalDefenseValue,
      defender: defense.character,
    );

    if (counter != null) result.add(counter);

    // Logger().d('counter ${counter?.text}');

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
      defender: defense.character,
    );
  }

  List<ExplainedText> criticalEffects(ExplainedText criticalResult) {
    return CombatRules.criticalDescription(
      defender: defense.character,
      criticalResult: criticalResult,
    );
  }
}
