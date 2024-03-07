import 'package:amt/models/character_model/character.dart';
import 'package:amt/presentation/presentation.dart';
import 'package:amt/resources/modifiers.dart';
import 'package:amt/utils/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:function_tree/function_tree.dart';
import 'package:logger/web.dart';
import 'package:provider/provider.dart';

class CharacterInfoCard extends StatelessWidget {
  CharacterInfoCard({required this.attacking, super.key});
  final spacer = const SizedBox(height: 8, width: 8);
  final bool attacking;
  final modifiersController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<CharactersPageState>();
    final theme = Theme.of(context);

    final character = attacking ? appState.combatState.attack.character : appState.combatState.defense.character;
    final consumables = character?.state.consumables;

    return character != null
        ? Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                SizedBox(
                  width: 10000,
                  height: 30,
                  child: ColoredBox(
                    color: attacking ? theme.colorScheme.primary : theme.colorScheme.secondary,
                    child: Text(
                      character.profile.name,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleMedium!.copyWith(
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
                spacer,
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _row(
                            [
                              const Text('Arma:'),
                              Expanded(
                                child: WeaponsRack(
                                  weapons: character.combat.weapons,
                                  selectedWeapon: character.selectedWeapon(),
                                  onEdit: (weapon) => {
                                    character.combat.updateWeapon(weapon),
                                    appState.updateCharacter(character),
                                  },
                                  onSelect: (element) => {
                                    character.state.selectedWeaponIndex = character.combat.weapons.indexOf(element),
                                    appState.updateCharacter(character),
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              const Text('Armadura:'),
                              Expanded(
                                child: ArmoursRack(
                                  armourBase: character.combat.armour,
                                  onEdit: (armour) => {
                                    character.combat.armour = armour,
                                    appState.updateCharacter(character),
                                  },
                                ),
                              ),
                            ],
                          ),
                          spacer,
                          _row([
                            Expanded(
                              flex: 2,
                              child: Text('Turno: ${character.selectedWeapon().turn} + '),
                            ),
                            spacer,
                            Expanded(
                              flex: 2,
                              child: AMTTextFormField(
                                text: character.state.turnModifier,
                                onChanged: (value) {
                                  final newChar = _calculateTurn(character, value);
                                  appState.updateCharacter(newChar);
                                },
                              ),
                            ),
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
                                '= ${character.state.currentTurn.roll}',
                                textAlign: TextAlign.end,
                                style: theme.textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            spacer,
                          ]),
                          spacer,
                          LayoutBuilder(
                            builder: (context, constraints) {
                              return AMTGrid(
                                elements: consumables!,
                                columns: constraints.constrainWidth() > 500 ? 3 : 2,
                                builder: (element, index) => ConsumableCard(
                                  element,
                                  onDelete: (consumable) {
                                    character.state.consumables.remove(consumable);
                                    appState.updateCharacter(character);
                                  },
                                  onChangedActual: (actual) {
                                    character.state.consumables[index].update(actual: actual);
                                    appState.updateCharacter(character);
                                  },
                                  onChangedMax: (max) {
                                    character.state.consumables[index].update(max: max);
                                    appState.updateCharacter(character);
                                  },
                                ),
                                lastElementBuilder: () => Card(
                                  color: theme.colorScheme.secondaryContainer,
                                  child: Center(
                                    child: TextButton(
                                      onPressed: () {
                                        CreateConsumable.show(context, (consumable) {
                                          character.state.consumables.add(consumable);
                                          appState.updateCharacter(character);
                                        });
                                      },
                                      child: const Text('Añadir'),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          spacer,
                          OutlinedButton(
                            child: Tooltip(
                              message: character.state.modifiers.totalModifierDescription(),
                              child: Row(
                                children: [
                                  const Text('Modificadores'),
                                  const SizedBox.square(
                                    dimension: 8,
                                  ),
                                  Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: AMTGrid(
                                        elements: character.state.modifiers.getAllModifiersString(),
                                        columns: 3,
                                        builder: (element, index) {
                                          return Text(
                                            '${element.key.abbreviated}: ${element.value}',
                                            overflow: TextOverflow.ellipsis,
                                            style: theme.textTheme.bodySmall,
                                            textAlign: TextAlign.right,
                                            maxLines: 1,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onPressed: () {
                              BottomSheetModifiers.show(context, character.state.modifiers, Modifiers.getStatusModifiers(), (newModifiersState) {
                                character.state.modifiers = newModifiersState;
                                appState.updateCharacter(character);
                              });
                            },
                          ),
                          spacer,
                          ModifiersCard(
                            modifiers: character.state.modifiers.getAll(),
                            onSelected: (modifier) {
                              character.state.modifiers.removeModifier(modifier);
                              appState.updateCharacter(character);
                            },
                          ),
                          spacer,
                          SizedBox(
                            height: 40,
                            child: AMTTextFormField(
                              label: 'Notas',
                              text: character.state.notes,
                              onChanged: (value) {
                                character.state.notes = value;
                                appState.updateCharacter(character);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        : const Card();
  }

  Character _calculateTurn(Character character, String value) {
    final baseTurn = character.selectedWeapon().turn;
    character.state.turnModifier = value;
    final turn = character.state.currentTurn;
    var modifier = 0;

    try {
      modifier = value.interpret().toInt();
    } catch (e) {
      Logger().e(e);
    }

    final total = baseTurn + turn.rolls.reduce((value, element) => value + element) + modifier;

    character.state.currentTurn.roll = total;
    return character;
  }

  SizedBox _row(List<Widget> children, {double height = 40}) {
    return SizedBox(
      height: height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: children,
      ),
    );
  }
}
