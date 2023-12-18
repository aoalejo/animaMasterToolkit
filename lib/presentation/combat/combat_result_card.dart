import 'package:amt/models/enums.dart';
import 'package:amt/models/rules/rules.dart';
import 'package:amt/presentation/bottom_sheet_custom.dart';
import 'package:amt/presentation/combat/custom_combat_card.dart';
import 'package:amt/presentation/states/characters_page_state.dart';
import 'package:amt/utils/explained_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CombatReturnCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<CharactersPageState>();
    final theme = Theme.of(context);

    return CustomCombatCard(
      title: "Resultado",
      children: [
        ExplainedTextContainer(
          info: appState.combatState.attackResult(),
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

                var damage = 0; //appState.combatState.calculateDamage();

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

class ExplainedTextContainer extends StatelessWidget {
  final ExplainedText info;
  final int hierarchy;

  ExplainedTextContainer({
    required this.info,
    this.hierarchy = 1,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var showDetail = false;

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Tooltip(message: info.explanation, child: Text(info.text)),
                  if (showDetail)
                    for (var explanation in info.explanations)
                      Card(
                        color: _colorForHierarchy(theme, hierarchy),
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: ExplainedTextContainer(
                            info: explanation,
                            hierarchy: hierarchy + 1,
                          ),
                        ),
                      ),
                ],
              ),
            ),
            if (info.explanations.isNotEmpty)
              IconButton(
                  onPressed: () {
                    setState(() => showDetail = !showDetail);
                  },
                  icon: Icon(showDetail ? Icons.arrow_drop_up : Icons.arrow_drop_down)),
          ],
        );
      },
    );
  }

  Color _colorForHierarchy(ThemeData theme, int hierarchy) {
    if (hierarchy % 3 == 0) {
      return theme.colorScheme.tertiaryContainer;
    }

    if (hierarchy % 2 == 0) {
      return theme.colorScheme.secondaryContainer;
    }

    return theme.cardColor;
  }
}
