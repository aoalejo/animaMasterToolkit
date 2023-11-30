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

class CombatCriticalCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<CharactersPageState>();
    final theme = Theme.of(context);

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
                      text: appState.combatState.damageDone,
                      onChanged: (value) =>
                          appState.updateCombatState(damageDone: value),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 40,
                    child: TextFormFieldCustom(
                      inputType: TextInputType.number,
                      text: appState.combatState.criticalRoll,
                      label: "Tirada de critico",
                      onChanged: (value) =>
                          {appState.updateCombatState(criticalRoll: value)},
                      suffixIcon: IconButton(
                        onPressed: () {
                          appState.updateCombatState(
                              criticalRoll: Roll.roll().getRollsAsString());
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
                      text: appState.combatState.physicalResistanceBase,
                      onChanged: (value) => appState.updateCombatState(
                          physicalResistanceBase: value),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 40,
                    child: TextFormFieldCustom(
                      inputType: TextInputType.number,
                      text: appState.combatState.physicalResistanceRoll,
                      label: "Tirada de RF",
                      onChanged: (value) => {
                        appState.updateCombatState(
                            physicalResistanceRoll: value)
                      },
                      suffixIcon: IconButton(
                        onPressed: () {
                          appState.updateCombatState(
                              physicalResistanceRoll:
                                  Roll.roll().getRollsAsString());
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
          ],
        ),
        SizedBox(
          height: 10,
        ),
        SizedBox(
          width: 8000,
          child: Row(
            children: [
              Expanded(
                  child: Card(
                color: theme.colorScheme.background,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    appState.combatState.criticalDescription(),
                  ),
                ),
              ))
            ],
          ),
        ),
      ],
    );
  }
}
