import 'package:amt/models/character/character.dart';
import 'package:amt/presentation/TextFormFieldCustom.dart';
import 'package:amt/presentation/bottom_sheet_modifiers.dart';
import 'package:amt/presentation/charactersTable/consumable_card.dart';
import 'package:amt/presentation/charactersTable/modifiers_card.dart';
import 'package:amt/presentation/charactersTable/weapons_rack.dart';
import 'package:amt/presentation/states/characters_page_state.dart';
import 'package:amt/resources/modifiers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CharacterInfoCard extends StatelessWidget {
  final spacer = SizedBox(height: 8, width: 8);
  final bool attacking;

  CharacterInfoCard({required this.attacking});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<CharactersPageState>();
    var theme = Theme.of(context);

    Character? _character = attacking
        ? appState.characterAttacking()
        : appState.characterDefending();

    return _character != null
        ? Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                SizedBox(
                  width: 10000,
                  height: 40,
                  child: ColoredBox(
                    color: theme.primaryColor,
                    child: TextFormFieldCustom(
                      align: TextAlign.center,
                      style: theme.textTheme.titleMedium!.copyWith(
                        color: theme.colorScheme.onPrimary,
                      ),
                      text: _character.profile.name,
                      onChanged: (value) {
                        _character.profile.name = value;
                        appState.updateCharacter(_character);
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
                                weapons: _character.combat.weapons,
                                selectedWeapon: _character.selectedWeapon(),
                                onEdit: (weapon) => {
                                  _character.combat.updateWeapon(weapon),
                                  appState.updateCharacter(_character),
                                },
                                onSelect: (element) => {
                                  _character.state.selectedWeaponIndex =
                                      _character.combat.weapons
                                          .indexOf(element),
                                  appState.updateCharacter(_character),
                                },
                              ))
                            ],
                          ),
                          spacer,
                          _row([
                            Expanded(
                              flex: 2,
                              child: Text(
                                  "Turno: ${_character.selectedWeapon().turn.toString()} + "),
                            ),
                            spacer,
                            Expanded(
                                flex: 2,
                                child: TextFormFieldCustom(
                                  text: _character.state.turnModifier,
                                  onChanged: (value) {
                                    _character.state.turnModifier = value;
                                    appState.updateCharacter(_character);
                                  },
                                )),
                            spacer,
                            Expanded(
                              flex: 2,
                              child: Text(
                                '+ ${_character.state.currentTurn.getRollsAsString()}',
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                '= ${_character.state.currentTurn.roll.toString()}',
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
                                    in _character.state.consumables)
                                  ConsumableCard(
                                    consumable,
                                    onChangedActual: (actual) {
                                      int index = _character.state.consumables
                                          .indexOf(consumable);
                                      consumable.update(actual: actual);
                                      _character.state.consumables[index] =
                                          consumable;
                                      appState.updateCharacter(_character);
                                    },
                                    onChangedMax: (max) {
                                      int index = _character.state.consumables
                                          .indexOf(consumable);
                                      consumable.update(max: max);
                                      _character.state.consumables[index] =
                                          consumable;
                                      appState.updateCharacter(_character);
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
                                  _character.state.modifiers
                                      .totalModifierDescription(),
                                  style: theme.textTheme.bodySmall,
                                  textAlign: TextAlign.center,
                                ),
                              ]),
                              onPressed: () {
                                BottomSheetModifiers.show(
                                    context,
                                    _character.state.modifiers,
                                    Modifiers.getStatusModifiers(),
                                    (newModifiersState) {
                                  _character.state.modifiers =
                                      newModifiersState;
                                  appState.updateCharacter(_character);
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
                                modifiers: _character.state.modifiers.getAll()),
                          ),
                          spacer,
                          SizedBox(
                              height: 40,
                              child: TextFormFieldCustom(
                                text: _character.state.notes,
                                onChanged: (value) {
                                  _character.state.notes = value;
                                  appState.updateCharacter(_character);
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

  _row(List<Widget> children) {
    return SizedBox(
      height: 40,
      child: Row(children: children),
    );
  }
}
