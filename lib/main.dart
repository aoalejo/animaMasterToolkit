import 'dart:convert';
import 'dart:io';

import 'package:amt/models/character/character.dart';
import 'package:amt/models/character/character_state.dart';
import 'package:amt/models/character/status_modifier.dart';
import 'package:amt/presentation/actions_card.dart';
import 'package:amt/presentation/bottom_sheet_custom.dart';
import 'package:amt/presentation/consumible_card.dart';
import 'package:amt/presentation/modifiers_card.dart';
import 'package:amt/presentation/text_card.dart';
import 'package:amt/presentation/turn_card.dart';
import 'package:amt/presentation/weapons_rack.dart';
import 'package:amt/resources/modifiers.dart';
import 'package:amt/utils/debouncer.dart';
import 'package:enough_convert/windows.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:function_tree/function_tree.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Personajes',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GeneratorPage();
  }
}

class MyAppState extends ChangeNotifier {
  var characters = <Character>[];

  void removeCharacter(Character character) {
    characters.remove(character);
    notifyListeners();
  }

  void rollTurns() {
    for (Character character in characters) {
      character.rollInitiative();
      character.state.hasAction = true;
    }

    characters.sort(Character.initiativeSort);
    notifyListeners();
  }

  void updateCharacter(Character character) {
    int index =
        characters.indexWhere((element) => element.uuid == character.uuid);

    characters[index] = character;

    notifyListeners();
  }

  void getCharacters() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
      allowMultiple: true,
    );

    if (result != null) {
      List<File> files = result.paths.map((path) => File(path ?? "")).toList();

      for (var file in files) {
        final json = await file.readAsString(encoding: Windows1252Codec());
        characters.add(Character.fromJson(jsonDecode(json)));
      }
    }

    notifyListeners();
  }
}

class GeneratorPage extends StatelessWidget {
  final _debouncer = Debouncer(milliseconds: 50);

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Personajes"),
        actions: [
          IconButton(
            icon: Icon(Icons.upload_file),
            onPressed: () {
              appState.getCharacters();
            },
          ),
          IconButton(
            icon: Icon(Icons.repeat),
            onPressed: () {
              appState.rollTurns();
            },
          )
        ],
      ),
      body: ColoredBox(
        color: theme.colorScheme.secondaryContainer,
        child: Align(
          alignment: Alignment.topLeft,
          child: Column(
            children: [
              Table(
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
                              ? theme.colorScheme.background
                              : theme.colorScheme.background.withAlpha(50)),
                      children: [
                        SizedBox(
                          height: 100,
                          child: Switch(
                            value: item.state.hasAction,
                            onChanged: (state) => {
                              item.state.hasAction = state,
                              appState.updateCharacter(item),
                            },
                          ),
                        ),
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
                              for (var consumible in item.state.consumables)
                                ConsumibleCard(
                                  consumible,
                                  onChangedActual: (actual) {
                                    int index = item.state.consumables
                                        .indexOf(consumible);
                                    consumible.updateActual(actual);
                                    _debouncer.run(
                                      () => {
                                        item.state.consumables[index] =
                                            consumible,
                                        appState.updateCharacter(item),
                                      },
                                    );
                                  },
                                  onChangedMax: (max) {
                                    int index = item.state.consumables
                                        .indexOf(consumible);
                                    consumible.updateMax(max);
                                    _debouncer.run(
                                      () => {
                                        item.state.consumables[index] =
                                            consumible,
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
                                    onAtack: () {},
                                    onDodge: () {},
                                    onParry: () {},
                                    onChangeModifiers: () {
                                      _showBottomSheetModalModifiers(
                                          context, item.state, (newState) {
                                        item.state = newState;
                                        appState.updateCharacter(item);
                                      });
                                    },
                                  ),
                                  ModifiersCard(
                                      modifiers: item.state.modifiers),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showBottomSheetModalModifiers(
    BuildContext context,
    CharacterState state,
    void Function(CharacterState) onModifiersChanged,
  ) {
    void toggleModifier(StateSetter setState, StatusModifier modifier) {
      setState(
        () => {
          if (state.containsModifier(modifier))
            {state.removeModifier(modifier)}
          else
            {state.modifiers.add(modifier)},
          onModifiersChanged(state)
        },
      );
    }

    final theme = Theme.of(context);
    final subtitleButton = theme.textTheme.bodySmall;

    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return BottomSheetCustom(
              text: 'Selección/Edición de arma',
              children: [
                for (var modifier in Modifiers.getModifiers())
                  TextButton(
                    onPressed: () => {toggleModifier(setState, modifier)},
                    child: Padding(
                      padding: EdgeInsets.all(4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(modifier.name),
                              Text(
                                modifier.description(),
                                overflow: TextOverflow.ellipsis,
                                style: subtitleButton,
                              ),
                            ],
                          ),
                          Switch(
                            value: state.containsModifier(modifier),
                            onChanged: (v) {
                              toggleModifier(setState, modifier);
                            },
                          )
                        ],
                      ),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}
