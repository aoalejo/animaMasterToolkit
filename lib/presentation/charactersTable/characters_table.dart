import 'package:amt/models/character/character.dart';
import 'package:amt/models/enums.dart';
import 'package:amt/models/modifiers_state.dart';
import 'package:amt/presentation/charactersTable/character_info.dart';
import 'package:amt/presentation/states/characters_page_state.dart';
import 'package:amt/presentation/states/combat_state.dart';
import 'package:amt/utils/Int+Extension.dart';
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
                    shape: appState.combatState.attack.character?.uuid ==
                            character.uuid
                        ? _border(theme.colorScheme.primary)
                        : appState.combatState.defense.character?.uuid ==
                                character.uuid
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
                                Expanded(
                                  child: Text(character.profile.name),
                                ),
                                Stack(
                                  alignment: AlignmentDirectional.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(8),
                                      child: CircularProgressIndicator(
                                        value: character.state
                                                .getLifePointsPercentage()
                                                .toDouble() /
                                            100,
                                        color: character.state
                                            .getLifePointsPercentage()
                                            .percentageColor(),
                                      ),
                                    ),
                                    Text(
                                      "${character.state.getLifePointsPercentage()}%",
                                      style: theme.textTheme.bodySmall!
                                          .copyWith(
                                              fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                )
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
                                        var surprise = SurpriseType.calculate(
                                          attacker: character,
                                          defendant: appState
                                              .combatState.defense.character,
                                        );

                                        appState.updateCombatState(
                                          attacking: character,
                                          attackRoll: "",
                                          attackingModifiers: ModifiersState(),
                                          damageModifier: "",
                                          baseAttackModifiers: "",
                                          surprise: surprise,
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
    var physicalResistance = character.resistances.physicalResistance;
    var armour = character.combat.armour.calculatedArmour
        .armourFor(appState.combatState.attack.damageType)
        .toString();
    var surprise = SurpriseType.calculate(
      attacker: appState.combatState.attack.character,
      defendant: character,
    );

    appState.updateCombatState(
      defendant: character,
      defenseRoll: "0",
      defenderModifiers: ModifiersState(),
      armourModifier: armour,
      defenseType: type,
      physicalResistanceBase: physicalResistance.toString(),
      baseDefenseModifiers: "",
      surprise: surprise,
    );
  }
}
