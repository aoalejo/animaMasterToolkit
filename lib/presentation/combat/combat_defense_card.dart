import 'package:amt/models/enums.dart';
import 'package:amt/models/roll.dart';
import 'package:amt/presentation/text_form_field_custom.dart';
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
    final defendant = appState.combatState.defense.defendant;

    return CustomCombatCard(
      title:
          "${defendant?.profile.name ?? ""} ${appState.combatState.defense.defenseType.displayable} (Total: ${appState.combatState.finalDefenseValue()})",
      actionTitle: IconButton(
        icon: Icon(
          Icons.delete,
          color: theme.colorScheme.onPrimary,
        ),
        onPressed: () {
          appState.removeDefendant();
        },
      ),
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
                      text: appState.combatState.defense.defenseRoll,
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (defendant != null)
                          Flexible(
                            flex: 1,
                            child: Tooltip(
                              message: defendant?.calculateDefense(appState
                                      .combatState.defense.defenseType) ??
                                  "",
                              child: TextFormFieldCustom(
                                enabled: false,
                                label: "Defensa",
                                text: defendant?.calculateDefense(appState
                                        .combatState.defense.defenseType) ??
                                    "0",
                              ),
                            ),
                          ),
                        if (defendant != null) SizedBox(width: 4),
                        Flexible(
                          flex: 2,
                          child: TextFormFieldCustom(
                            inputType: TextInputType.number,
                            label:
                                defendant != null ? "Modificador" : "Defensa",
                            suffixIcon: TextButton(
                              child: Text("+Can"),
                              onPressed: () {
                                defendant?.removeFrom(
                                  1,
                                  ConsumableType.fatigue,
                                );
                                appState.updateCombatState(
                                    baseDefenseModifiers:
                                        "${appState.combatState.defense.baseDefenseModifiers}+15");
                                appState.updateCharacter(defendant);
                              },
                            ),
                            text: appState
                                .combatState.defense.baseDefenseModifiers,
                            onChanged: (value) => appState.updateCombatState(
                                baseDefenseModifiers: value),
                          ),
                        ),
                      ],
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
                          if (defendant != null)
                            Flexible(
                              flex: 1,
                              child: TextFormFieldCustom(
                                enabled: false,
                                label: "Armadura",
                                text: defendant?.combat.armour.calculatedArmour
                                    .armourFor(
                                        appState.combatState.attack.damageType)
                                    .toString(),
                              ),
                            ),
                          if (defendant != null) SizedBox(width: 4),
                          Flexible(
                            flex: 2,
                            child: TextFormFieldCustom(
                              onChanged: (value) {
                                appState.updateCombatState(armour: value);
                              },
                              text: appState.combatState.defense.armourModifier,
                              label: defendant != null
                                  ? "Modificador"
                                  : "Armadura",
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
                            combat.defense.defenderModifiers,
                            Modifiers.getSituationalModifiers(
                                combat.defense.defenseType.toModifierType()),
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
                            appState.combatState.defense.defenderModifiers
                                .getAllModifiersForDefense(
                                    appState.combatState.defense.defenseType)
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
          child: ModifiersCard(
            aspectRatio: 0.2,
            modifiers: appState.combatState.defense.defenderModifiers.getAll(),
            onSelected: (selected) {
              appState.combatState.defense.defenderModifiers
                  .removeModifier(selected);
              appState.updateCombatState(
                  defenderModifiers:
                      appState.combatState.defense.defenderModifiers);
            },
          ),
        ),
        if (defendant != null)
          SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    "Cantidad de defensas:",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                ToggleButtons(
                  isSelected: [
                    defendant.state.defenseNumber == 1,
                    defendant.state.defenseNumber == 2,
                    defendant.state.defenseNumber == 3,
                    defendant.state.defenseNumber == 4,
                    defendant.state.defenseNumber >= 5,
                  ],
                  onPressed: (index) {
                    defendant.state.defenseNumber = index + 1;
                    appState.updateCharacter(defendant);
                  },
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
