import 'package:amt/models/character/status_modifier.dart';
import 'package:amt/models/roll.dart';
import 'package:amt/presentation/general/explained_result_container.dart';
import 'package:amt/presentation/text_form_field_custom.dart';
import 'package:amt/presentation/combat/custom_combat_card.dart';
import 'package:amt/presentation/states/characters_page_state.dart';
import 'package:amt/utils/assets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CombatCriticalCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<CharactersPageState>();
    var combatState = appState.combatState;
    var criticalResult = combatState.criticalResult();

    var attacker = combatState.attack.character;
    var defender = combatState.defense.character;

    var criticalResultResult = combatState.criticalResultWithReduction(criticalResult: criticalResult.result);

    return CustomCombatCard(
      title: 'Critico',
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 1,
              child: Column(
                children: [
                  SizedBox(
                    height: 40,
                    child: TextFormFieldCustom(
                      key: Key("TextFormFieldBaseAttack"),
                      inputType: TextInputType.number,
                      label: "Daño causado",
                      text: combatState.critical.damageDone,
                      onChanged: (value) => appState.updateCombatState(damageDone: value),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 40,
                    child: TextFormFieldCustom(
                      inputType: TextInputType.number,
                      text: combatState.critical.criticalRoll,
                      label: "Tirada de critico",
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
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 40,
                    child: TextFormFieldCustom(
                      inputType: TextInputType.number,
                      text: combatState.critical.localizationRoll,
                      label: "Tirada de localización",
                      onChanged: (value) => {appState.updateCombatState(localizationRoll: value)},
                      suffixIcon: IconButton(
                        onPressed: () {
                          appState.updateCombatState(
                              localizationRoll: Roll.roll(
                            canCrit: false,
                            canFumble: false,
                          ).getRollsAsString());
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
            SizedBox(
              width: 12,
            ),
            Flexible(
              flex: 1,
              child: Column(
                children: [
                  SizedBox(
                    height: 40,
                    child: TextFormFieldCustom(
                      key: Key("TextFormFieldBaseAttack"),
                      inputType: TextInputType.number,
                      label: "RF Base",
                      text: combatState.critical.physicalResistanceBase,
                      onChanged: (value) => appState.updateCombatState(physicalResistanceBase: value),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 40,
                    child: TextFormFieldCustom(
                      inputType: TextInputType.number,
                      text: combatState.critical.physicalResistanceRoll,
                      label: "Tirada de RF",
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
                  SizedBox(
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
        SizedBox(
          height: 10,
        ),
        for (var explanation in combatState.criticalEffects(criticalResult))
          ExplainedTextContainer(
            explanationsExpanded: appState.explanationsExpanded,
            onExpanded: (name) => appState.toggleExplanationStatus(name),
            info: explanation,
          ),
        SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 40,
          child: Row(
            children: [
              Flexible(
                flex: 1,
                child: TextFormFieldCustom(
                  inputType: TextInputType.number,
                  label: "Reducción de penalizador",
                  text: combatState.critical.modifierReduction,
                  onChanged: (value) => appState.updateCombatState(modifierReduction: value),
                ),
              ),
              Flexible(
                flex: 1,
                child: Center(
                  child: TextButton(
                    onPressed: () {
                      var character = combatState.defense.character;

                      var result = criticalResultResult;

                      var midValue = -(result ~/ 2);
                      if (result < 50) {
                        midValue = 0;
                      }

                      var criticalModifier = StatusModifier(
                        name: "Critico ($result)",
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
                    child: Text("Aplicar penalizador ($criticalResultResult)"),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
