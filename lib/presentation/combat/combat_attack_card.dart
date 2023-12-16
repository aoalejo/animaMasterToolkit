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

class CombatAttackCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<CharactersPageState>();
    final theme = Theme.of(context);
    final attacker = appState.combatState.attack.attacker;

    return CustomCombatCard(
      title:
          "${attacker?.profile.name ?? ""} Ataca (Total: ${appState.combatState.finalAttackValue()})",
      actionTitle: IconButton(
        icon: Icon(
          Icons.delete,
          color: theme.colorScheme.onPrimary,
        ),
        onPressed: () {
          appState.removeAttacker();
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
                      text: appState.combatState.attack.attackRoll,
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (attacker != null)
                          Flexible(
                            flex: 1,
                            child: Tooltip(
                              message: attacker?.calculateAttack() ?? "",
                              child: TextFormFieldCustom(
                                enabled: false,
                                label: "Ataque",
                                text: attacker?.calculateAttack() ?? "0",
                              ),
                            ),
                          ),
                        if (attacker != null) SizedBox(width: 4),
                        Flexible(
                          flex: 2,
                          child: TextFormFieldCustom(
                            inputType: TextInputType.number,
                            label: attacker != null ? "Modificador" : "Ataque",
                            suffixIcon: TextButton(
                              child: Text("+Can"),
                              onPressed: () {
                                var character =
                                    appState.combatState.attack.attacker;

                                character?.removeFrom(
                                  1,
                                  ConsumableType.fatigue,
                                );
                                appState.combatState.attack.attackModifier =
                                    "${appState.combatState.attack.attackModifier}+15";
                                appState.updateCharacter(character);
                              },
                            ),
                            text: appState.combatState.attack.attackModifier,
                            onChanged: (value) => appState.updateCombatState(
                                baseAttackModifiers: value),
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
                          if (attacker != null)
                            Flexible(
                              flex: 1,
                              child: TextFormFieldCustom(
                                enabled: false,
                                label: "Daño",
                                text:
                                    attacker.selectedWeapon().damage.toString(),
                              ),
                            ),
                          if (attacker != null) SizedBox(width: 4),
                          Flexible(
                            flex: 2,
                            child: TextFormFieldCustom(
                              onChanged: (value) {
                                appState.updateCombatState(baseDamage: value);
                              },
                              text: appState.combatState.attack.damageModifier,
                              label:
                                  "(${appState.combatState.attack.attacker?.selectedWeapon().name ?? "Daño base"})",
                              inputType: TextInputType.number,
                              suffixIcon: attacker != null
                                  ? Padding(
                                      padding: EdgeInsets.all(8),
                                      child: ToggleButtons(
                                        isSelected: [
                                          appState.combatState.attack.attacker
                                                  ?.selectedWeapon()
                                                  .principalDamage ==
                                              appState.combatState.attack
                                                  .damageType,
                                          appState.combatState.attack.attacker
                                                  ?.selectedWeapon()
                                                  .secondaryDamage ==
                                              appState
                                                  .combatState.attack.damageType
                                        ],
                                        onPressed: (index) => {
                                          appState.updateCombatState(
                                              damageType: index == 0
                                                  ? appState.combatState.attack
                                                      .attacker
                                                      ?.selectedWeapon()
                                                      .principalDamage
                                                  : appState.combatState.attack
                                                      .attacker
                                                      ?.selectedWeapon()
                                                      .secondaryDamage)
                                        },
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(8)),
                                        children: [
                                          Text(
                                            appState.combatState.attack.attacker
                                                    ?.selectedWeapon()
                                                    .principalDamage
                                                    ?.name ??
                                                "con",
                                            style: theme.textTheme.bodySmall,
                                          ),
                                          Text(
                                            appState.combatState.attack.attacker
                                                    ?.selectedWeapon()
                                                    .secondaryDamage
                                                    ?.name ??
                                                "con",
                                            style: theme.textTheme.bodySmall,
                                          ),
                                        ],
                                      ),
                                    )
                                  : null,
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
                            appState.combatState.attack.attackingModifiers,
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
                            appState.combatState.attack.attackingModifiers
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
            modifiers: appState.combatState.attack.attackingModifiers.getAll(),
            onSelected: (selected) {
              appState.combatState.attack.attackingModifiers
                  .removeModifier(selected);
              appState.updateCombatState(
                  attackingModifiers:
                      appState.combatState.attack.attackingModifiers);
            },
          ),
        ),
      ],
    );
  }
}
