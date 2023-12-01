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

class CombatAttackCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<CharactersPageState>();
    final theme = Theme.of(context);

    return CustomCombatCard(
      title:
          "${appState.characterAttacking()?.profile.name ?? ""} Ataca (Total: ${appState.combatState.finalAttackValue()})",
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
                      text: appState.combatState.attackRoll,
                      label: "Tirada de ataque",
                      onChanged: (value) =>
                          {appState.updateCombatState(attackRoll: value)},
                      suffixIcon: IconButton(
                        onPressed: () {
                          appState.updateCombatState(
                              attackRoll: Roll.roll().getRollsAsString());
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
                      key: Key("TextFormFieldBaseAttack"),
                      inputType: TextInputType.number,
                      label: "Ataque base",
                      suffixIcon: TextButton(
                        child: Text("+Can"),
                        onPressed: () {
                          var character = appState.characterAttacking();

                          character?.removeFrom(
                            1,
                            ConsumableType.fatigue,
                          );
                          appState.combatState.baseAttack =
                              "${appState.combatState.baseAttack}+15";
                          appState.updateCharacter(character);
                        },
                      ),
                      text: appState.combatState.baseAttack,
                      onChanged: (value) =>
                          appState.updateCombatState(baseAttack: value),
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
                          Flexible(
                            flex: 1,
                            child: TextFormFieldCustom(
                              onChanged: (value) {
                                appState.updateCombatState(baseDamage: value);
                              },
                              text: appState.combatState.baseDamage,
                              label:
                                  "Daño base (${appState.combatState.selectedWeapon.name})",
                              inputType: TextInputType.number,
                              suffixIcon: Padding(
                                padding: EdgeInsets.all(8),
                                child: ToggleButtons(
                                  isSelected: [
                                    appState.combatState.selectedWeapon
                                            .principalDamage ==
                                        appState.combatState.damageType,
                                    appState.combatState.selectedWeapon
                                            .secondaryDamage ==
                                        appState.combatState.damageType
                                  ],
                                  onPressed: (index) => {
                                    appState.updateCombatState(
                                        damageType: index == 0
                                            ? appState.combatState
                                                .selectedWeapon.principalDamage
                                            : appState.combatState
                                                .selectedWeapon.secondaryDamage)
                                  },
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8)),
                                  children: [
                                    Text(
                                      appState.combatState.selectedWeapon
                                              .principalDamage?.name ??
                                          "con",
                                      style: theme.textTheme.bodySmall,
                                    ),
                                    Text(
                                      appState.combatState.selectedWeapon
                                              .secondaryDamage?.name ??
                                          "con",
                                      style: theme.textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 40,
                    child: TextButton(
                      onPressed: () {
                        BottomSheetModifiers.show(
                            context,
                            appState.combatState.attackingModifiers,
                            Modifiers.getSituationalModifiers(
                                ModifiersType.attack), (newModifiers) {
                          appState.updateAttackingModifiers(newModifiers);
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
                            appState.combatState.attackingModifiers
                                .totalAttackingDescription(),
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
            modifiers: appState.combatState.attackingModifiers.getAll(),
          ),
        ),
      ],
    );
  }
}
