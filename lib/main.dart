import 'dart:convert';
import 'dart:io';

import 'package:amt/models/character/character.dart';
import 'package:amt/presentation/actions_card.dart';
import 'package:amt/presentation/consumible_card.dart';
import 'package:amt/presentation/modifiers_card.dart';
import 'package:amt/presentation/text_card.dart';
import 'package:amt/presentation/turn_card.dart';
import 'package:amt/presentation/weapons_rack.dart';
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
                                item.state.turnModifier =
                                    newValue.interpret().toInt(),
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
                                    consumible.actualValue =
                                        actual.interpret().toInt();
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
                                    consumible.maxValue =
                                        max.interpret().toInt();
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
                                    onChangeModifiers: (modifiers) {
                                      item.state.modifiers = modifiers;
                                      appState.updateCharacter(item);
                                    },
                                    modifiers:
                                        ValueNotifier(item.state.modifiers),
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
}
