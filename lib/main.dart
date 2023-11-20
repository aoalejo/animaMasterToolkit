import 'dart:convert';
import 'dart:io';

import 'package:amt/models/character/character.dart';
import 'package:amt/models/modifier_state.dart';
import 'package:amt/models/roll.dart';
import 'package:amt/presentation/bottom_sheet_modifiers.dart';
import 'package:amt/presentation/charactersTable/characters_table.dart';
import 'package:amt/presentation/charactersTable/modifiers_card.dart';
import 'package:amt/resources/modifiers.dart';
import 'package:amt/utils/assets.dart';
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
      create: (context) => CharactersPageState(),
      child: MaterialApp(
        title: 'Personajes',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrangeAccent),
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

class CombatState {
  var attackRoll = "";
  var baseDamage = "";
  var baseAttack = "";

  int attackingCharacter = 0;
  int defendantCharacter = 0;

  ModifiersState attackingModifiers = ModifiersState();
  ModifiersState defenderModifiers = ModifiersState();

  int finalAttackValue() {
    var roll = 0;
    var attack = 0;

    try {
      roll = attackRoll.interpret().toInt();
    } catch (e) {
      // Defaults to 0
    }

    try {
      attack = baseAttack.interpret().toInt();
    } catch (e) {
      // Defaults to 0
    }

    return attackingModifiers.getAllModifiersForType(ModifiersType.attack) +
        roll +
        attack;
  }
}

class CharactersPageState extends ChangeNotifier {
  var characters = <Character>[];
  var combatState = CombatState();

  void updateAttackingModifiers(ModifiersState modifiers) {
    combatState.attackingModifiers = modifiers;
    notifyListeners();
  }

  void updateDefenderModifiers(ModifiersState modifiers) {
    combatState.defenderModifiers = modifiers;
    notifyListeners();
  }

  void updateCombatState({
    String? attackRoll,
    String? baseDamage,
    String? baseAttack,
    int? attackingCharacter,
    int? defendantCharacter,
    ModifiersState? attackingModifiers,
    ModifiersState? defenderModifiers,
  }) {
    combatState.attackRoll = attackRoll ?? combatState.attackRoll;
    combatState.baseDamage = baseDamage ?? combatState.baseDamage;
    combatState.baseAttack = baseAttack ?? combatState.baseAttack;

    combatState.attackingCharacter =
        attackingCharacter ?? combatState.attackingCharacter;
    combatState.defendantCharacter =
        defendantCharacter ?? combatState.defendantCharacter;

    combatState.attackingModifiers =
        attackingModifiers ?? combatState.attackingModifiers;
    combatState.defenderModifiers =
        defenderModifiers ?? combatState.defenderModifiers;

    notifyListeners();
  }

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
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<CharactersPageState>();
    var theme = Theme.of(context);
    var screenSize = MediaQuery.of(context).size;
    var height = screenSize.height - 50;
    var isLandscape = screenSize.width > screenSize.height;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        title: Text("Personajes"),
        backgroundColor: theme.primaryColor,
        foregroundColor: theme.colorScheme.onPrimary,
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
        key: Key("ContainerKey"),
        color: theme.colorScheme.background,
        child: Align(
          alignment: Alignment.topLeft,
          child: Flex(
            direction: isLandscape ? Axis.horizontal : Axis.vertical,
            children: [
              SizedBox(
                height: isLandscape ? height : height / 1.5,
                width: isLandscape ? screenSize.width / 2 : screenSize.width,
                child: CharactersTable(),
              ),
              SizedBox(
                height: isLandscape ? height : height / 3,
                width: isLandscape ? screenSize.width / 2 : screenSize.width,
                child: CombatSection(
                  isLandscape: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CombatSection extends StatelessWidget {
  final bool isLandscape;
  CombatSection({required this.isLandscape});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var appState = context.watch<CharactersPageState>();

    return ColoredBox(
      color: theme.colorScheme.primaryContainer,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Flex(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _createCard(
              "Ataque",
              theme,
              [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 40,
                            child: TextFormFieldCustom(
                              inputType: TextInputType.number,
                              text: appState.combatState.attackRoll,
                              label: "Tirada de ataque",
                              suffixIcon: IconButton(
                                onPressed: () {
                                  appState.updateCombatState(
                                      attackRoll: Roll.roll().roll.toString());
                                },
                                icon: SizedBox.square(
                                  dimension: 24,
                                  child: Assets.diceRoll,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            height: 40,
                            child: TextFormFieldCustom(
                              key: Key("TextFormFieldBaseAttack"),
                              inputType: TextInputType.number,
                              label: "Ataque base",
                              text: appState.combatState.baseAttack,
                              onChanged: (value) =>
                                  appState.updateCombatState(baseAttack: value),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Flexible(
                      flex: 1,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 40,
                            child: TextFormFieldCustom(
                              onChanged: (value) {
                                appState.updateCombatState(baseDamage: value);
                              },
                              text: appState.combatState.baseDamage,
                              label: "Daño base",
                              inputType: TextInputType.number,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            height: 40,
                            child: TextButton(
                              onPressed: () {
                                BottomSheetModifiers.show(
                                    context,
                                    appState.combatState.attackingModifiers,
                                    Modifiers.getSituationalModifiers(
                                        ModifiersType.attack), (newModifiers) {
                                  appState
                                      .updateAttackingModifiers(newModifiers);
                                });
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    "Situacionales",
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    appState.combatState.attackingModifiers
                                        .totalAttackingDescription(),
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
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: 8000,
                  child: Row(
                    children: [
                      ModifiersCard(
                        aspectRatio: 0.2,
                        modifiers:
                            appState.combatState.attackingModifiers.getAll(),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                  child: Text(
                    "Resultado del ataque: ${appState.combatState.finalAttackValue()}",
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
            //_createCard("Defensa", theme, []),
          ],
        ),
      ),
    );
  }

  Widget _createCard(String title, ThemeData theme, List<Widget> children) {
    return Card(
      clipBehavior: Clip.hardEdge,
      color: theme.colorScheme.background,
      elevation: 12,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: 10000,
            child: ColoredBox(
              color: theme.primaryColor,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium!
                    .copyWith(color: theme.colorScheme.onPrimary),
              ),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: children,
            ),
          )
        ],
      ),
    );
  }
}

class TextFormFieldCustom extends StatelessWidget {
  final String? text;
  final String? label;
  final TextInputType? inputType;
  final void Function(String)? onChanged;
  final Widget? suffixIcon;

  const TextFormFieldCustom({
    super.key,
    this.text,
    this.label,
    this.inputType,
    this.onChanged,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      controller: TextEditingController.fromValue(
        TextEditingValue(
          text: text ?? "",
          selection: TextSelection.collapsed(
            offset: text?.length ?? 0,
          ),
        ),
      ),
      textInputAction: TextInputAction.done,
      keyboardType: inputType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.all(8),
        suffixIcon: suffixIcon,
      ),
    );
  }
}
