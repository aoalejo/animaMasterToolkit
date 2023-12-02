import 'package:amt/models/character/character.dart';
import 'package:amt/presentation/TextFormFieldCustom.dart';
import 'package:amt/presentation/bottom_sheet_modifiers.dart';
import 'package:amt/presentation/charactersTable/consumable_card.dart';
import 'package:amt/presentation/charactersTable/modifiers_card.dart';
import 'package:amt/presentation/charactersTable/weapons_rack.dart';
import 'package:amt/presentation/states/characters_page_state.dart';
import 'package:amt/resources/modifiers.dart';
import 'package:flutter/material.dart';
import 'package:function_tree/function_tree.dart';
import 'package:provider/provider.dart';

class CharacterInfoCard extends StatelessWidget {
  final spacer = SizedBox(height: 8, width: 8);
  final bool attacking;

  CharacterInfoCard({required this.attacking});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<CharactersPageState>();
    var theme = Theme.of(context);

    Character? character = attacking
        ? appState.characterAttacking()
        : appState.defendingCharacter();

    return character != null
        ? Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                SizedBox(
                  width: 10000,
                  height: 40,
                  child: ColoredBox(
                    color: attacking
                        ? theme.colorScheme.primary
                        : theme.colorScheme.secondary,
                    child: TextFormFieldCustom(
                      align: TextAlign.center,
                      style: theme.textTheme.titleMedium!.copyWith(
                        color: theme.colorScheme.onPrimary,
                      ),
                      text: character.profile.name,
                      onChanged: (value) {
                        character.profile.name = value;
                        appState.updateCharacter(character);
                      },
                    ),
                  ),
                ),
                spacer,
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _row(
                            [
                              Text("Arma:"),
                              Expanded(
                                  child: WeaponsRack(
                                weapons: character.combat.weapons,
                                selectedWeapon: character.selectedWeapon(),
                                onEdit: (weapon) => {
                                  character.combat.updateWeapon(weapon),
                                  appState.updateCharacter(character),
                                },
                                onSelect: (element) => {
                                  character.state.selectedWeaponIndex =
                                      character.combat.weapons.indexOf(element),
                                  appState.updateCharacter(character),
                                },
                              ))
                            ],
                          ),
                          spacer,
                          _row([
                            Expanded(
                              flex: 2,
                              child: Text(
                                  "Turno: ${character.selectedWeapon().turn.toString()} + "),
                            ),
                            spacer,
                            Expanded(
                                flex: 2,
                                child: TextFormFieldCustom(
                                  text: character.state.turnModifier,
                                  onChanged: (value) {
                                    var newChar =
                                        _calculateTurn(character, value);
                                    appState.updateCharacter(newChar);
                                  },
                                )),
                            spacer,
                            Expanded(
                              flex: 2,
                              child: Text(
                                '+ ${character.state.currentTurn.getRollsAsString()}',
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                '= ${character.state.currentTurn.roll.toString()}',
                                textAlign: TextAlign.end,
                                style: theme.textTheme.titleMedium,
                              ),
                            ),
                            spacer,
                          ]),
                          spacer,
                          SizedBox(
                            height: 150,
                            child: GridView.count(
                              scrollDirection: Axis.horizontal,
                              crossAxisCount: 2,
                              childAspectRatio: 0.4,
                              children: [
                                for (var consumable
                                    in character.state.consumables)
                                  ConsumableCard(
                                    consumable,
                                    onChangedActual: (actual) {
                                      int index = character.state.consumables
                                          .indexOf(consumable);
                                      consumable.update(actual: actual);
                                      character.state.consumables[index] =
                                          consumable;
                                      appState.updateCharacter(character);
                                    },
                                    onChangedMax: (max) {
                                      int index = character.state.consumables
                                          .indexOf(consumable);
                                      consumable.update(max: max);
                                      character.state.consumables[index] =
                                          consumable;
                                      appState.updateCharacter(character);
                                    },
                                  ),
                              ],
                            ),
                          ),
                          spacer,
                          _row([
                            Expanded(
                                child: OutlinedButton(
                              child: Column(children: [
                                Text("Modificadores"),
                                Text(
                                  character.state.modifiers
                                      .totalModifierDescription(),
                                  style: theme.textTheme.bodySmall,
                                  textAlign: TextAlign.center,
                                ),
                              ]),
                              onPressed: () {
                                BottomSheetModifiers.show(
                                    context,
                                    character.state.modifiers,
                                    Modifiers.getStatusModifiers(),
                                    (newModifiersState) {
                                  character.state.modifiers = newModifiersState;
                                  appState.updateCharacter(character);
                                });
                              },
                            ))
                          ]),
                          spacer,
                          SizedBox(
                            height: 70,
                            width: 989,
                            child: ModifiersCard(
                              aspectRatio: 0.3,
                              modifiers: character.state.modifiers.getAll(),
                              onSelected: (modifier) {
                                character.state.modifiers
                                    .removeModifier(modifier);
                                appState.updateCharacter(character);
                              },
                            ),
                          ),
                          spacer,
                          SizedBox(
                              height: 40,
                              child: TextFormFieldCustom(
                                text: character.state.notes,
                                onChanged: (value) {
                                  character.state.notes = value;
                                  appState.updateCharacter(character);
                                },
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        : Card();
  }

  Character _calculateTurn(Character character, String value) {
    var baseTurn = character.selectedWeapon().turn;
    character.state.turnModifier = value;
    var turn = character.state.currentTurn;
    var modifier = 0;

    try {
      modifier = value.interpret().toInt();
    } catch (e) {}

    var total = baseTurn +
        turn.rolls.reduce((value, element) => value + element) +
        modifier;

    character.state.currentTurn.roll = total;
    return character;
  }

  _row(List<Widget> children) {
    return SizedBox(
      height: 40,
      child: Row(children: children),
    );
  }
}
