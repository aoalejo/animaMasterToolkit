import 'dart:async';

import 'package:amt/models/models.dart';
import 'package:amt/presentation/presentation.dart';
import 'package:amt/utils/assets.dart';
import 'package:amt/utils/int_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CharactersTable extends StatelessWidget {
  const CharactersTable({super.key});

  SizedBox get spacer => const SizedBox(height: 8, width: 8);

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<CharactersPageState>();
    final theme = Theme.of(context);

    return Column(
      children: [
        spacer,
        // Actions
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: TextButton.icon(
                onPressed: appState.rollTurns,
                icon: const Icon(Icons.repeat),
                label: const Text(
                  'Iniciativas',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ),
            Flexible(
              child: TextButton.icon(
                onPressed: appState.sheetsLoadingPercentage == -1
                    ? () async {
                        appState.showLoading(
                          message: 'Selecciona las planillas que deseas cargar#Si quieres convertir planillas excel, haz click en el ícono de arriba',
                        );
                        final files = await appState.getCharacters();
                        appState.hideLoading();

                        final timer = Timer.periodic(Duration(milliseconds: 250 * (files?.count ?? 1)), (timer) => appState.stepSheetLoading());
                        await appState.parseCharacters(files, appState.updateSheetLoading);
                        timer.cancel();
                      }
                    : null,
                icon: const Icon(Icons.upload_file),
                label: const Text(
                  'Cargar Personaje',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ),
            Flexible(
              child: TextButton.icon(
                onPressed: () {
                  CreateCharacter.show(context, appState.addCharacter);
                },
                icon: const Icon(Icons.edit_document),
                label: const Text(
                  'Crear Personaje',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ),
            Flexible(
              child: TextButton.icon(
                onPressed: appState.resetConsumables,
                icon: const Icon(Icons.restore),
                label: const Text(
                  'Restaurar consumibles',
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
          padding: const EdgeInsets.all(4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _header(1, ''),
              _header(2, 'Nombre'),
              _header(1, 'HP'),
              _header(2, 'Turno'),
              Tooltip(
                child: _header(1, 'C'),
                message: 'Aqui se visualiza el primer consumible que tenga el personaje sin ser la vida, puede ser Zeon, Ki o Fatiga por ejemplo',
              ),
              _header(5, 'Acciones'),
            ],
          ),
        ),

        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                for (final character in appState.characters)
                  Card(
                    shape: _characterShape(character, appState, theme),
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
                          size: 2,
                          child: Row(
                            children: [
                              Expanded(
                                child: Tooltip(
                                  message: character.profile.name,
                                  child: Text(
                                    character.profile.name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        _cell(
                          size: 1,
                          child: Stack(
                            alignment: AlignmentDirectional.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: CircularProgressIndicator(
                                  value: character.state.getLifePointsPercentage().toDouble() / 100,
                                  color: character.state.getLifePointsPercentage().percentageColor(),
                                ),
                              ),
                              Text(
                                '${character.state.getLifePointsPercentage()}%',
                                style: theme.textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        _cell(
                          size: 2,
                          child: Row(
                            children: [
                              Expanded(
                                child: Tooltip(
                                  message: character.state.currentTurn.description,
                                  child: Card(
                                    color: theme.colorScheme.primary,
                                    child: Text(
                                      character.state.currentTurn.roll.toString(),
                                      style: theme.textTheme.bodyMedium!.copyWith(color: theme.colorScheme.onPrimary),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                              _surpriseDesc(appState.characters, character, appState),
                            ],
                          ),
                        ),
                        _cell(
                          size: 1,
                          child: Tooltip(
                            message: '${character.state.getFirstOtherConsumable()?.name}\n${character.state.getFirstOtherConsumable()?.description}',
                            child: Stack(
                              alignment: AlignmentDirectional.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: CircularProgressIndicator(
                                    value: character.state.getOtherConsumablePercentage().toDouble() / 100,
                                    color: character.state.getOtherConsumablePercentage().percentageColor(),
                                  ),
                                ),
                                Text(
                                  character.state.getFirstOtherConsumable()?.actualValue.toString() ?? '',
                                  style: theme.textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                        _cell(
                          size: 5,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Tooltip(
                                  message: 'Info',
                                  child: IconButton(
                                    icon: const Icon(Icons.info),
                                    onPressed: () {
                                      ShowCharacterInfo.call(context, character, onEdit: appState.updateCharacter);
                                    },
                                  ),
                                ),
                                Tooltip(
                                  message: 'Atacar',
                                  child: IconButton(
                                    icon: SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: Assets.knife,
                                    ),
                                    onPressed: () {
                                      final surprise = SurpriseType.calculate(
                                        attacker: character,
                                        defendant: appState.combatState.defense.character,
                                      );

                                      appState.updateCombatState(
                                        attacking: character,
                                        attackRoll: '',
                                        attackingModifiers: ModifiersState(),
                                        damageModifier: '',
                                        baseAttackModifiers: '',
                                        surprise: surprise,
                                      );
                                    },
                                  ),
                                ),
                                Tooltip(
                                  message: 'Parada',
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
                                  message: 'Esquiva',
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
                                Tooltip(
                                  message: 'Opciones',
                                  child: IconButton(
                                    icon: const Icon(Icons.settings),
                                    onPressed: () {
                                      ShowCharacterOptions.call(
                                        context,
                                        character,
                                        onRemove: (character) => {appState.removeCharacter(character)},
                                        onEdit: appState.updateCharacter,
                                        onAddCharacter: (character) {
                                          appState.addCharacter(character, isNpc: character.profile.isNpc ?? false);
                                        },
                                      );
                                    },
                                  ),
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
          ),
        ),
      ],
    );
  }

  ShapeBorder? _characterShape(Character character, CharactersPageState appState, ThemeData theme) {
    if (character.state.isSurprised > 0) {
      return _border(Colors.orange.shade700, width: 2);
    } else if (character.state.isSurprised < 0) {
      return _border(Colors.green.shade700, width: 2);
    }

    return appState.combatState.attack.character?.uuid == character.uuid
        ? _border(theme.colorScheme.primary)
        : appState.combatState.defense.character?.uuid == character.uuid
            ? _border(theme.colorScheme.secondary)
            : _border(Colors.transparent);
  }

  Widget _surpriseDesc(List<Character> characters, Character character, CharactersPageState appState) {
    final surprisesTo = <Character>[];
    final getsSurprisedFrom = <Character>[];

    for (final element in characters) {
      final surprise = SurpriseType.calculate(
        attacker: element,
        defendant: character,
      );

      if (surprise == SurpriseType.attacker) {
        getsSurprisedFrom.add(element);
      } else if (surprise == SurpriseType.defender) {
        surprisesTo.add(element);
      }
    }

    var background = Colors.transparent;

    if (surprisesTo.isNotEmpty && getsSurprisedFrom.isNotEmpty) {
      background = Colors.grey.shade100;
    } else if (surprisesTo.isNotEmpty) {
      background = Colors.green.shade100;
    } else if (getsSurprisedFrom.isNotEmpty) {
      background = Colors.orange.shade100;
    }

    final surprisesToMessage = surprisesTo.isNotEmpty
        ? <InlineSpan>[
            const TextSpan(
              text: 'Sorprende a:\n',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: surprisesTo.map((e) => e.profile.name).join('\n'),
              style: const TextStyle(fontWeight: FontWeight.normal),
            ),
          ]
        : <InlineSpan>[];

    final surprisesFromMessage = getsSurprisedFrom.isNotEmpty
        ? <InlineSpan>[
            if (surprisesTo.isNotEmpty) const TextSpan(text: '\n'),
            const TextSpan(
              text: 'Es sorprendido por:\n',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: getsSurprisedFrom.map((e) => e.profile.name).join('\n'),
              style: const TextStyle(fontWeight: FontWeight.normal),
            ),
          ]
        : <InlineSpan>[];

    return MouseRegion(
      onEnter: (e) {
        for (final element in surprisesTo) {
          element.state.isSurprised = -1;
        }
        for (final element in getsSurprisedFrom) {
          element.state.isSurprised = 1;
        }
        appState.notify();
      },
      onExit: (e) {
        for (final element in characters) {
          element.state.isSurprised = 0;
        }
        appState.notify();
      },
      child: Tooltip(
        richMessage: TextSpan(
          text: '',
          children: <InlineSpan>[...surprisesToMessage, ...surprisesFromMessage],
        ),
        child: Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: background,
            border: Border.all(
              color: character.profile.uroboros ?? false ? Colors.red : Colors.grey.shade300,
              width: character.profile.uroboros ?? false ? 1 : 0,
            ),
          ),
          child: SizedBox(
            width: 24,
            height: 24,
            child: Assets.surprised(surprisesTo.isEmpty && getsSurprisedFrom.isEmpty ? Colors.black12 : Colors.black),
          ),
        ),
      ),
    );
  }

  ShapeBorder _border(Color color, {double width = 1}) {
    return StadiumBorder(side: BorderSide(color: color, width: width));
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
      ),
    );
  }

  Widget _cell({required int size, required Widget child}) {
    return Expanded(flex: size, child: child);
  }

  void _updateDefense(
    CharactersPageState appState,
    Character character,
    DefenseType type,
  ) {
    final physicalResistance = character.resistances.physicalResistance;
    final surprise = SurpriseType.calculate(
      attacker: appState.combatState.attack.character,
      defendant: character,
    );

    appState.updateCombatState(
      defendant: character,
      defenseRoll: '0',
      defenderModifiers: ModifiersState(),
      armourModifier: '',
      defenseType: type,
      physicalResistanceBase: physicalResistance.toString(),
      baseDefenseModifiers: '',
      surprise: surprise,
    );
  }
}
