import 'package:amt/models/enums.dart';
import 'package:amt/models/roll.dart';
import 'package:amt/presentation/TextFormFieldCustom.dart';
import 'package:amt/presentation/bottom_sheet_modifiers.dart';
import 'package:amt/presentation/charactersTable/modifiers_card.dart';
import 'package:amt/presentation/combat/custom_combat_card.dart';
import 'package:amt/presentation/states/characters_page_state.dart';
import 'package:amt/resources/modifiers.dart';
import 'package:amt/utils/assets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CombatDefenseCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<CharactersPageState>();
    final theme = Theme.of(context);

    return CustomCombatCard(
      title:
          "${appState.characterDefending()?.profile.name ?? ""} ${appState.combatState.defenseType.displayable} (Total: ${appState.combatState.finalDefenseValue()})",
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
                      inputType: TextInputType.number,
                      text: appState.combatState.defenseRoll,
                      label: "Tirada de defensa",
                      onChanged: (value) =>
                          {appState.updateCombatState(defenseRoll: value)},
                      suffixIcon: IconButton(
                        onPressed: () {
                          appState.updateCombatState(
                              defenseRoll: Roll.roll().getRollsAsString());
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
                      label: "Defensa base",
                      text: appState.combatState.baseDefense,
                      onChanged: (value) =>
                          appState.updateCombatState(baseDefense: value),
                      suffixIcon: TextButton(
                        child: Text("+Can"),
                        onPressed: () {
                          var character = appState.characters[
                              appState.combatState.defendantCharacter];

                          character.removeFrom(
                            1,
                            ConsumableType.fatigue,
                          );
                          appState.combatState.baseDefense =
                              "${appState.combatState.baseDefense}+15";
                          appState.updateCharacter(character);
                        },
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
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormFieldCustom(
                              onChanged: (value) {
                                appState.updateCombatState(armour: value);
                              },
                              text: appState.combatState.armour,
                              label: "Tabla de armadura",
                              inputType: TextInputType.number,
                              suffixIcon: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  appState.updateCombatState(armour: "0");
                                },
                              ),
                            ),
                          )
                        ],
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 40,
                    child: TextButton(
                      onPressed: () {
                        var combat = appState.combatState;
                        BottomSheetModifiers.show(
                            context,
                            combat.defenderModifiers,
                            Modifiers.getSituationalModifiers(
                                combat.defenseType.toModifierType()),
                            (newModifiers) {
                          appState.updateCombatState(
                              defenderModifiers: newModifiers);
                        });
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "Situacionales",
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            appState.combatState.defenderModifiers
                                .getAllModifiersForDefense(
                                    appState.combatState.defenseType)
                                .toString(),
                            style: theme.textTheme.bodySmall,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
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
        SizedBox(
          width: 8000,
          child: Row(
            children: [
              ModifiersCard(
                aspectRatio: 0.2,
                modifiers: appState.combatState.attackingModifiers.getAll(),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Cantidad de defensas:"),
              ToggleButtons(
                isSelected: [
                  appState.combatState.defenseNumber == 1,
                  appState.combatState.defenseNumber == 2,
                  appState.combatState.defenseNumber == 3,
                  appState.combatState.defenseNumber == 4,
                  appState.combatState.defenseNumber >= 5,
                ],
                onPressed: (index) =>
                    {appState.updateCombatState(defenseNumber: index + 1)},
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                children: [
                  Text("1"),
                  Text("2"),
                  Text("3"),
                  Text("4"),
                  Text("5+"),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
