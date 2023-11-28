import 'package:amt/models/character/character.dart';
import 'package:amt/models/enums.dart';
import 'package:amt/models/modifier_state.dart';
import 'package:amt/presentation/bottom_sheet_modifiers.dart';
import 'package:amt/presentation/charactersTable/actions_card.dart';
import 'package:amt/presentation/charactersTable/character_info.dart';
import 'package:amt/presentation/charactersTable/consumable_card.dart';
import 'package:amt/presentation/charactersTable/modifiers_card.dart';
import 'package:amt/presentation/charactersTable/turn_card.dart';
import 'package:amt/presentation/charactersTable/weapons_rack.dart';
import 'package:amt/presentation/states/characters_page_state.dart';
import 'package:amt/presentation/text_card.dart';
import 'package:amt/resources/modifiers.dart';
import 'package:amt/utils/debouncer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CharactersTable extends StatelessWidget {
  final _debouncer = Debouncer(milliseconds: 50);

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<CharactersPageState>();
    var theme = Theme.of(context);

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Table(
          columnWidths: const <int, TableColumnWidth>{
            0: IntrinsicColumnWidth(),
            1: FractionColumnWidth(0.2),
            2: FractionColumnWidth(0.1),
            3: FixedColumnWidth(200),
            4: FlexColumnWidth(),
          },
          children: [
            TableRow(children: [
              TextCard("Accion?"),
              TextCard("Personaje"),
              TextCard("Turno"),
              TextCard("Consumibles"),
              TextCard("Notas")
            ]),
            for (var item in appState.characters)
              TableRow(
                key: ValueKey("TableRow${item.uuid}"),
                decoration: BoxDecoration(
                  color: appState.characters.indexOf(item) % 2 == 0
                      ? Colors.transparent
                      : theme.colorScheme.tertiaryContainer.withAlpha(125),
                ),
                children: [
                  SizedBox(
                      height: 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Switch(
                            value: item.state.hasAction,
                            onChanged: (state) => {
                              item.state.hasAction = state,
                              appState.updateCharacter(item),
                            },
                          ),
                          InkWell(
                            onTap: () {
                              ShowCharacterInfo.call(context, item);
                            },
                            child: Icon(
                              Icons.info_outline,
                              color: theme.primaryColor,
                            ),
                          )
                        ],
                      )),
                  SizedBox(
                    height: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Padding(padding: EdgeInsets.fromLTRB(8, 0, 8, 0)),
                        TextFormField(
                          decoration: InputDecoration(
                            isDense: true,
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.all(8),
                          ),
                          initialValue: item.profile.name,
                          onChanged: (value) => {
                            _debouncer.run(() => {
                                  item.profile.name = value,
                                  appState.updateCharacter(item),
                                })
                          },
                          onTapOutside: (event) => {},
                        ),
                        WeaponsRack(
                          weapons: item.combat.weapons,
                          selectedWeapon: item.selectedWeapon(),
                          onEdit: () => {},
                          onSelect: (element) => {
                            item.state.selectedWeaponIndex =
                                item.combat.weapons.indexOf(element),
                            appState.updateCharacter(item),
                          },
                        ),
                      ],
                    ),
                  ),
                  TurnCard(
                    item,
                    onChanged: (newValue) {
                      _debouncer.run(
                        () => {
                          item.state.updateTurn(newValue),
                          appState.updateCharacter(item),
                        },
                      );
                    },
                  ),
                  SizedBox(
                    height: 100,
                    width: 200,
                    child: GridView.count(
                      scrollDirection: Axis.vertical,
                      crossAxisCount: 2,
                      childAspectRatio: 2,
                      children: [
                        for (var consumable in item.state.consumables)
                          ConsumableCard(
                            consumable,
                            onChangedActual: (actual) {
                              int index =
                                  item.state.consumables.indexOf(consumable);
                              consumable.updateActual(actual);
                              _debouncer.run(
                                () => {
                                  item.state.consumables[index] = consumable,
                                  appState.updateCharacter(item),
                                },
                              );
                            },
                            onChangedMax: (max) {
                              int index =
                                  item.state.consumables.indexOf(consumable);
                              consumable.updateMax(max);
                              _debouncer.run(
                                () => {
                                  item.state.consumables[index] = consumable,
                                  appState.updateCharacter(item),
                                },
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          height: 30,
                          child: Center(
                            child: TextFormField(
                              decoration: InputDecoration(
                                isDense: true,
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.all(8),
                              ),
                              initialValue: item.state.notes,
                              onChanged: (newText) {
                                _debouncer.run(
                                  () => {
                                    item.state.notes = newText,
                                    appState.updateCharacter(item),
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            ActionsCard(
                              onAttack: () {
                                var index = appState.characters.indexOf(item);
                                var weapon = item.selectedWeapon();

                                appState.updateCombatState(
                                  attackingCharacter: index,
                                  attackRoll: "0",
                                  attackingModifiers: ModifiersState(),
                                  baseAttack: _calculateAttack(item).toString(),
                                  baseDamage: weapon.damage.toString(),
                                  attackerTurn: item.state.currentTurn.roll,
                                  selectedWeapon: item.selectedWeapon(),
                                );
                              },
                              onDodge: () {
                                var index = appState.characters.indexOf(item);

                                appState.updateCombatState(
                                  defendantCharacter: index,
                                  defenseRoll: "0",
                                  defenderModifiers: ModifiersState(),
                                  baseDefense:
                                      _calculateDefense(item, DefenseType.dodge)
                                          .toString(),
                                  armour: item
                                      .combat.armour.calculatedArmour.fil
                                      .toString(),
                                  defenseType: DefenseType.dodge,
                                  defenseNumber: 0,
                                  damageType:
                                      item.selectedWeapon().principalDamage,
                                  selectedArmour:
                                      item.combat.armour.calculatedArmour,
                                  defenseTurn: item.state.currentTurn.roll,
                                );
                              },
                              onParry: () {
                                var index = appState.characters.indexOf(item);

                                appState.updateCombatState(
                                  defendantCharacter: index,
                                  defenseRoll: "0",
                                  defenderModifiers: ModifiersState(),
                                  baseDefense:
                                      _calculateDefense(item, DefenseType.parry)
                                          .toString(),
                                  armour: item
                                      .combat.armour.calculatedArmour.fil
                                      .toString(),
                                  defenseType: DefenseType.parry,
                                  defenseNumber: 0,
                                  selectedArmour:
                                      item.combat.armour.calculatedArmour,
                                  defenseTurn: item.state.currentTurn.roll,
                                );
                              },
                              onChangeModifiers: () {
                                BottomSheetModifiers.show(
                                    context,
                                    item.state.modifiers,
                                    Modifiers.getStatusModifiers(),
                                    (newModifiersState) {
                                  item.state.modifiers = newModifiersState;
                                  appState.updateCharacter(item);
                                });
                              },
                            ),
                            ModifiersCard(
                              modifiers: item.state.modifiers.getAll(),
                              onSelected: (modifier) {
                                item.state.modifiers.removeModifier(modifier);
                                appState.updateCharacter(item);
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }

  int _calculateDefense(Character character, DefenseType type) {
    var weapon = character.selectedWeapon();
    var weaponDefense = weapon.defenseType;

    var modifiers = character.state.modifiers.getAllModifiersForDefense(type);

    if (weaponDefense == type) {
      return weapon.defense + modifiers;
    } else {
      return weapon.defense - 60 + modifiers;
    }
  }

  int _calculateAttack(Character character) {
    var weapon = character.selectedWeapon();

    var modifiers =
        character.state.modifiers.getAllModifiersForType(ModifiersType.attack);

    return weapon.attack + modifiers;
  }
}
