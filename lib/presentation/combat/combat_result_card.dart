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
          appState.combatState.calculateResult(),
        ),
        appState.combatState.calculateDamage() > 10
            ? TextButton(
                style: ButtonStyle(),
                onPressed: () {
                  var character = appState.combatState.defense.defendant;

                  var damage = appState.combatState.calculateDamage();

                  character?.removeFrom(
                    damage,
                    ConsumableType.hitPoints,
                  );

                  appState.updateCombatState(damageDone: damage.toString());

                  character?.state.defenseNumber += 1;

                  appState.updateCharacter(character);
                },
                child: Text("Aplicar daño"),
              )
            : TextButton(
                style: ButtonStyle(
                    foregroundColor:
                        MaterialStatePropertyAll(theme.disabledColor)),
                onPressed: () {
                  var character = appState.combatState.defense.defendant;

                  character?.state.defenseNumber += 1;
                  appState.updateCharacter(character);
                },
                child: Text("Añadir defensa"),
              )
      ],
    );
  }
}
