import 'package:amt/models/enums.dart';
import 'package:amt/models/rules/rules.dart';
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

class ExplainedTextContainer extends StatelessWidget {
  final ExplainedText info;
  final int hierarchy;
  final Map<String, bool> explanationsExpanded;
  final Function(String) onExpanded;
  final String parent;

  ExplainedTextContainer({
    required this.info,
    required this.explanationsExpanded,
    required this.onExpanded,
    this.parent = "",
    this.hierarchy = 1,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    String titleForStatus = parent + info.title;
    bool hasToBeExpanded = explanationsExpanded[titleForStatus] ?? false;

    return Card(
      clipBehavior: Clip.hardEdge,
      color: _colorForHierarchy(theme, hierarchy),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 999,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: Text(
                          info.text,
                          style: theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      if (info.explanation.isNotEmpty || info.explanations.isNotEmpty)
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          onPressed: () {
                            onExpanded(titleForStatus);
                          },
                          icon: Icon(
                            hasToBeExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                          ),
                        ),
                    ],
                  ),
                ),
                if (hasToBeExpanded)
                  Padding(
                    padding: EdgeInsets.all(4),
                    child: Text(
                      info.explanation,
                      style: theme.textTheme.bodySmall!.copyWith(fontStyle: FontStyle.italic, fontWeight: FontWeight.w600),
                    ),
                  ),
                if (hasToBeExpanded)
                  for (var explanation in info.explanations)
                    ExplainedTextContainer(
                      onExpanded: onExpanded,
                      explanationsExpanded: explanationsExpanded,
                      info: explanation,
                      hierarchy: hierarchy + 1,
                      parent: info.title,
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _colorForHierarchy(ThemeData theme, int hierarchy) {
    if (hierarchy % 2 == 0) {
      return theme.colorScheme.secondaryContainer;
    }

    return theme.cardColor;
  }
}
