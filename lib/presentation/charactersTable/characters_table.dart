import 'package:amt/models/character/character.dart';
import 'package:amt/models/enums.dart';
import 'package:amt/models/modifiers_state.dart';
import 'package:amt/presentation/charactersTable/character_info.dart';
import 'package:amt/presentation/states/characters_page_state.dart';
import 'package:amt/resources/modifiers.dart';
import 'package:amt/utils/assets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CharactersTable extends StatelessWidget {
  final spacer = SizedBox(height: 8, width: 8);

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<CharactersPageState>();
    var theme = Theme.of(context);

    return Column(
      children: [
        spacer,
        // Actions
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 1,
              child: TextButton.icon(
                onPressed: () {
                  appState.rollTurns();
                },
                icon: Icon(Icons.repeat),
                label: Text(
                  "Iniciativas",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: TextButton.icon(
                onPressed: () {
                  appState.getCharacters();
                },
                icon: Icon(Icons.upload_file),
                label: Text(
                  "Cargar Personaje",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: TextButton.icon(
                onPressed: () {
                  appState.resetConsumables();
                },
                icon: Icon(Icons.restore),
                label: Text(
                  "Restaurar consumibles",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ),
          ],
        ),
        spacer,
        // Header
        Padding(
          padding: EdgeInsets.all(4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _header(1, ""),
              _header(3, "Nombre"),
              _header(1, "Turno"),
              _header(5, "Acciones"),
            ],
          ),
        ),

        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                for (var character in appState.characters)
                  Card(
                    shape: appState.characterAttacking()?.uuid == character.uuid
                        ? _border(theme.colorScheme.primary)
                        : appState.characterDefending()?.uuid == character.uuid
                            ? _border(theme.colorScheme.secondary)
                            : null,
                    child: Row(
                      children: [
                        _cell(
                          size: 1,
                          child: Checkbox(
                            value: character.state.hasAction,
                            onChanged: (value) {
                              character.state.hasAction = value ?? true;
                              appState.updateCharacter(character);
                            },
                          ),
                        ),
                        _cell(
                            size: 3,
                            child: Row(
                              children: [
                                Text(character.profile.name),
                              ],
                            )),
                        _cell(
                          size: 1,
                          child: Tooltip(
                            message: character.state.currentTurn.description,
                            child: Card(
                              color: theme.colorScheme.primary,
                              child: Text(
                                character.state.currentTurn.roll.toString(),
                                style: theme.textTheme.bodyMedium!.copyWith(
                                    color: theme.colorScheme.onPrimary),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        _cell(
                            size: 5,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Tooltip(
                                    message: "Info",
                                    child: IconButton(
                                      icon: Icon(Icons.info),
                                      onPressed: () {
                                        ShowCharacterInfo.call(
                                            context, character,
                                            onRemove: (character) => {
                                                  appState.removeCharacter(
                                                      character)
                                                });
                                      },
                                    ),
                                  ),
                                  Tooltip(
                                    message: "Atacar",
                                    child: IconButton(
                                      icon: SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: Assets.knife,
                                      ),
                                      onPressed: () {
                                        var weapon = character.selectedWeapon();

                                        appState.updateCombatState(
                                          attackingCharacter: character.uuid,
                                          attackRoll: "0",
                                          attackingModifiers: ModifiersState(),
                                          baseAttack:
                                              _calculateAttack(character)
                                                  .toString(),
                                          baseDamage: weapon.damage.toString(),
                                          attackerTurn:
                                              character.state.currentTurn.roll,
                                          selectedWeapon:
                                              character.selectedWeapon(),
                                        );
                                      },
                                    ),
                                  ),
                                  Tooltip(
                                    message: "Parada",
                                    child: IconButton(
                                      icon: SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: Assets.shield,
                                      ),
                                      onPressed: () {
                                        _updateDefense(
                                          appState,
                                          character,
                                          DefenseType.parry,
                                        );
                                      },
                                    ),
                                  ),
                                  Tooltip(
                                    message: "Esquiva",
                                    child: IconButton(
                                      icon: SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: Assets.dodging,
                                      ),
                                      iconSize: 12,
                                      onPressed: () {
                                        _updateDefense(
                                          appState,
                                          character,
                                          DefenseType.dodge,
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ],
                    ),
                  )
              ],
            ),
          ),
        ),
      ],
    );
  }

  ShapeBorder _border(Color color) {
    return StadiumBorder(side: BorderSide(color: color));
  }

  Widget _header(int size, String text) {
    return Expanded(
        flex: size,
        child: Card(
          child: Text(
            text,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ));
  }

  Widget _cell({required int size, required Widget child}) {
    return Expanded(flex: size, child: child);
  }

  void _updateDefense(
    CharactersPageState appState,
    Character character,
    DefenseType type,
  ) {
    var hitPoints = character.state.getConsumable(ConsumableType.hitPoints);
    var physicalResistance = character.resistances.physicalResistance;

    appState.updateCombatState(
      defendantCharacter: character.uuid,
      defenseRoll: "0",
      defenderModifiers: ModifiersState(),
      baseDefense: _calculateDefense(character, type).toString(),
      armour: character.combat.armour.calculatedArmour.fil.toString(),
      defenseType: type,
      defenseNumber: character.state.defenseNumber,
      selectedArmour: character.combat.armour.calculatedArmour,
      defenseTurn: character.state.currentTurn.roll,
      physicalResistanceBase: physicalResistance.toString(),
      actualHitPoints: hitPoints?.actualValue ?? 0,
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
