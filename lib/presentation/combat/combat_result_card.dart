import 'package:amt/models/enums.dart';
import 'package:amt/models/rules/rules.dart';
import 'package:amt/presentation/combat/custom_combat_card.dart';
import 'package:amt/presentation/general/explained_result_container.dart';
import 'package:amt/presentation/states/characters_page_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CombatReturnCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<CharactersPageState>();
    final theme = Theme.of(context);

    return CustomCombatCard(
      padding: 4,
      title: "Resultado",
      children: [
        for (var explanation in appState.combatState.attackResult())
          ExplainedTextContainer(
            explanationsExpanded: appState.explanationsExpanded,
            onExpanded: (name) => appState.toggleExplanationStatus(name),
            info: explanation,
          ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 32,
              child: Row(
                children: [
                  Text("Sorprende: "),
                  ToggleButtons(
                    isSelected: [
                      appState.combatState.surpriseType == SurpriseType.attacker,
                      appState.combatState.surpriseType == SurpriseType.defender,
                      appState.combatState.surpriseType == SurpriseType.none,
                    ],
                    onPressed: (index) {
                      switch (index) {
                        case 0:
                          appState.updateCombatState(surprise: SurpriseType.attacker);
                        case 1:
                          appState.updateCombatState(surprise: SurpriseType.defender);
                        case 2:
                          appState.updateCombatState(surprise: SurpriseType.none);
                      }
                    },
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    children: [
                      Text(" Atacante ", style: theme.textTheme.bodySmall),
                      Text(" Defensor ", style: theme.textTheme.bodySmall),
                      Text(" Ninguno ", style: theme.textTheme.bodySmall),
                    ],
                  ),
                ],
              ),
            ),
            TextButton(
              style: ButtonStyle(),
              onPressed: () {
                var character = appState.combatState.defense.character;

                var damage = appState.combatState.calculateDamage().result ?? 0;

                if (damage < 10) damage = 0;

                character?.removeFrom(
                  damage,
                  ConsumableType.hitPoints,
                );

                appState.updateCombatState(damageDone: damage.toString());

                character?.state.defenseNumber += 1;

                appState.updateCharacter(character);
              },
              child: Text("Aplicar daño / Añadir defensa"),
            )
          ],
        )
      ],
    );
  }
}
