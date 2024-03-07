import 'package:amt/models/character_model/status_modifier.dart';
import 'package:amt/models/roll.dart';
import 'package:amt/presentation/combat/custom_combat_card.dart';
import 'package:amt/presentation/components/components.dart';
import 'package:amt/presentation/general/explained_result_container.dart';
import 'package:amt/presentation/states/characters_page_state.dart';
import 'package:amt/utils/assets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CombatCriticalCard extends StatelessWidget {
  const CombatCriticalCard({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<CharactersPageState>();
    final combatState = appState.combatState;
    final criticalResult = combatState.criticalResult();

    final attacker = combatState.attack.character;
    final defender = combatState.defense.character;

    final criticalResultResult = combatState.criticalResultWithReduction(criticalResult: criticalResult.result);

    return CustomCombatCard(
      title: 'Critico',
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Column(
                children: [
                  SizedBox(
                    height: 40,
                    child: AMTTextFormField(
                      key: const Key('TextFormFieldBaseAttack'),
                      label: 'Daño causado',
                      text: combatState.critical.damageDone,
                      onChanged: (value) => appState.updateCombatState(damageDone: value),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 40,
                    child: AMTTextFormField(
                      text: combatState.critical.criticalRoll,
                      label: 'Tirada de critico',
                      onChanged: (value) => {appState.updateCombatState(criticalRoll: value)},
                      suffixIcon: IconButton(
                        onPressed: () {
                          appState.updateCombatState(criticalRoll: attacker?.roll().getRollsAsString());
                        },
                        icon: SizedBox.square(
                          dimension: 24,
                          child: Assets.diceRoll,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 40,
                    child: AMTTextFormField(
                      inputType: TextInputType.number,
                      text: combatState.critical.localizationRoll,
                      label: 'Tirada de localización',
                      onChanged: (value) => {appState.updateCombatState(localizationRoll: value)},
                      suffixIcon: IconButton(
                        onPressed: () {
                          appState.updateCombatState(
                            localizationRoll: Roll.roll(
                              canCrit: false,
                              canFumble: false,
                            ).getRollsAsString(),
                          );
                        },
                        icon: SizedBox.square(
                          dimension: 24,
                          child: Assets.diceRoll,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Flexible(
              child: Column(
                children: [
                  SizedBox(
                    height: 40,
                    child: AMTTextFormField(
                      key: const Key('TextFormFieldBaseAttack'),
                      label: 'RF Base',
                      text: combatState.critical.physicalResistanceBase,
                      onChanged: (value) => appState.updateCombatState(physicalResistanceBase: value),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 40,
                    child: AMTTextFormField(
                      text: combatState.critical.physicalResistanceRoll,
                      label: 'Tirada de RF',
                      onChanged: (value) => {appState.updateCombatState(physicalResistanceRoll: value)},
                      suffixIcon: IconButton(
                        onPressed: () {
                          appState.updateCombatState(physicalResistanceRoll: defender?.roll().getRollsAsString());
                        },
                        icon: SizedBox.square(
                          dimension: 24,
                          child: Assets.diceRoll,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 40,
                    child: Center(
                      child: Text(combatState.criticalLocalization),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        for (final explanation in combatState.criticalEffects(criticalResult))
          ExplainedTextContainer(
            explanationsExpanded: appState.explanationsExpanded,
            onExpanded: appState.toggleExplanationStatus,
            info: explanation,
          ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 40,
          child: Row(
            children: [
              Flexible(
                child: AMTTextFormField(
                  inputType: TextInputType.number,
                  label: 'Reducción de penalizador',
                  text: combatState.critical.modifierReduction,
                  onChanged: (value) => appState.updateCombatState(modifierReduction: value),
                ),
              ),
              Flexible(
                child: Center(
                  child: TextButton(
                    onPressed: () {
                      final character = combatState.defense.character;

                      final result = criticalResultResult;

                      var midValue = -(result ~/ 2);
                      if (result < 50) {
                        midValue = 0;
                      }

                      final criticalModifier = StatusModifier(
                        name: 'Critico ($result)',
                        attack: -result,
                        dodge: -result,
                        parry: -result,
                        physicalAction: -result,
                        turn: -result,
                        isOfCritical: true,
                        midValue: midValue,
                      );

                      character?.state.modifiers.add(criticalModifier);

                      appState.updateCharacter(character);
                    },
                    child: Text('Aplicar penalizador ($criticalResultResult)'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
