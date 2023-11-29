import 'package:amt/models/enums.dart';
import 'package:amt/presentation/combat/custom_combat_card.dart';
import 'package:amt/presentation/states/characters_page_state.dart';
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
        Text(
          appState.combatState.combatTotal(),
        ),
        appState.combatState.calculateDamage() > 0
            ? TextButton(
                style: ButtonStyle(),
                onPressed: () {
                  var character = appState
                      .characters[appState.combatState.defendantCharacter];

                  character.removeFrom(
                    appState.combatState.calculateDamage(),
                    ConsumableType.hitPoints,
                  );

                  appState.updateCharacter(character);
                },
                child: Text("Aplicar daño"),
              )
            : TextButton(
                style: ButtonStyle(
                    foregroundColor:
                        MaterialStatePropertyAll(theme.disabledColor)),
                onPressed: () {},
                child: Text("Aplicar daño"),
              )
      ],
    );
  }
}