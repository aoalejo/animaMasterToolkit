import 'package:amt/models/enums.dart';
import 'package:amt/models/roll.dart';
import 'package:amt/presentation/bottom_sheet_modifiers.dart';
import 'package:amt/presentation/characters/modifiers_card.dart';
import 'package:amt/presentation/combat/custom_combat_card.dart';
import 'package:amt/presentation/components/components.dart';
import 'package:amt/presentation/states/characters_page_state.dart';
import 'package:amt/resources/modifiers.dart';
import 'package:amt/utils/assets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CombatDefenseCard extends StatelessWidget {
  const CombatDefenseCard({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<CharactersPageState>();
    final theme = Theme.of(context);
    final combatState = appState.combatState;
    final defense = combatState.defense;
    final character = defense.character;

    final damageAccumulation = defense.character?.profile.damageAccumulation ?? false;

    return CustomCombatCard(
      title:
          "${character?.profile.name ?? ""} ${damageAccumulation ? '(Acumulación de daño)' : '${defense.defenseType.displayable} (Total: ${combatState.finalDefenseValue.result})'}",
      actionTitle: character == null
          ? null
          : IconButton(
              icon: Icon(
                Icons.close,
                color: theme.colorScheme.onPrimary,
              ),
              onPressed: appState.removeDefendant,
            ),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Column(
                children: [
                  SizedBox(
                    height: 40,
                    child: AMTTextFormField(
                      enabled: !damageAccumulation,
                      text: defense.roll,
                      label: 'Tirada de defensa',
                      onChanged: (value) => {appState.updateCombatState(defenseRoll: value)},
                      suffixIcon: IconButton(
                        onPressed: () {
                          appState.updateCombatState(defenseRoll: (character?.roll() ?? Roll.roll()).getRollsAsString());
                        },
                        icon: SizedBox.square(
                          dimension: 24,
                          child: Assets.diceRoll,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (character != null)
                          Flexible(
                            child: Tooltip(
                              message: character.calculateDefense(defense.defenseType),
                              child: AMTTextFormField(
                                enabled: false,
                                label: 'Defensa',
                                text: damageAccumulation ? '-' : character.calculateDefense(defense.defenseType),
                              ),
                            ),
                          ),
                        if (character != null) const SizedBox(width: 4),
                        Flexible(
                          flex: 2,
                          child: AMTTextFormField(
                            enabled: !damageAccumulation,
                            label: character != null ? 'Modificador' : 'Defensa',
                            suffixIcon: TextButton(
                              child: const Text('+Can'),
                              onPressed: () {
                                character?.removeFrom(
                                  1,
                                  ConsumableType.fatigue,
                                );
                                appState
                                  ..updateCombatState(baseDefenseModifiers: '${defense.defense}+15')
                                  ..updateCharacter(character);
                              },
                            ),
                            text: defense.defense,
                            onChanged: (value) => appState.updateCombatState(baseDefenseModifiers: value),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Flexible(
              child: Column(
                children: [
                  SizedBox(
                    height: 40,
                    child: Row(
                      children: [
                        if (character != null)
                          Flexible(
                            child: AMTTextFormField(
                              enabled: false,
                              label: 'Armadura',
                              text: character.combat.armour.calculatedArmour.armourFor(combatState.attack.damageType).toString(),
                            ),
                          ),
                        if (character != null) const SizedBox(width: 4),
                        Flexible(
                          flex: 2,
                          child: AMTTextFormField(
                            onChanged: (value) {
                              appState.updateCombatState(armourModifier: value);
                            },
                            text: defense.armour,
                            label: character != null ? 'Modificador' : 'Armadura',
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                appState.updateCombatState(armourModifier: '');
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 40,
                    child: TextButton(
                      onPressed: () {
                        if (damageAccumulation) return;
                        BottomSheetModifiers.show(
                            context,
                            combatState.defense.modifiers,
                            Modifiers.getSituationalModifiers(
                              defense.defenseType.toModifierType(),
                              includeAllDefense: character == null,
                            ), (newModifiers) {
                          appState.updateCombatState(defenderModifiers: newModifiers);
                        });
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            damageAccumulation ? ' - ' : 'Situacionales',
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            defense.modifiers.getAllModifiersForDefense(defense.defenseType).toString(),
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
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: 8000,
          child: ModifiersCard(
            modifiers: defense.modifiers.getAll(),
            onSelected: (selected) {
              defense.modifiers.removeModifier(selected);
              appState.updateCombatState(defenderModifiers: defense.modifiers);
            },
          ),
        ),
        if (character != null && !damageAccumulation)
          SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Flexible(
                  child: Text(
                    'Cantidad de defensas:',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                ToggleButtons(
                  isSelected: [
                    character.state.defenseNumber == 1,
                    character.state.defenseNumber == 2,
                    character.state.defenseNumber == 3,
                    character.state.defenseNumber == 4,
                    character.state.defenseNumber >= 5,
                  ],
                  onPressed: (index) {
                    character.state.defenseNumber = index + 1;
                    appState.updateCharacter(character);
                  },
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  children: const [
                    Text('1'),
                    Text('2'),
                    Text('3'),
                    Text('4'),
                    Text('5+'),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }
}
