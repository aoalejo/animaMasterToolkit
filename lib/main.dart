import 'dart:convert';
import 'dart:io';

import 'package:amt/models/armour.dart';
import 'package:amt/models/armour_data.dart';
import 'package:amt/models/attributes_list.dart';
import 'package:amt/models/character/character.dart';
import 'package:amt/models/character_profile.dart';
import 'package:amt/models/combat_data.dart';
import 'package:amt/models/modifier_state.dart';
import 'package:amt/models/roll.dart';
import 'package:amt/presentation/TextFormFieldCustom.dart';
import 'package:amt/presentation/bottom_sheet_modifiers.dart';
import 'package:amt/presentation/charactersTable/characters_table.dart';
import 'package:amt/presentation/charactersTable/modifiers_card.dart';
import 'package:amt/resources/modifiers.dart';
import 'package:amt/utils/assets.dart';
import 'package:amt/utils/json_utils.dart';
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

  var defenseRoll = "";
  var armour = "";
  var baseDefense = "";

  var finalTurnAttacker = 0;
  var finalTurnDefense = 0;

  var defenseType = DefenseType.parry;
  var defenseNumber = 0;

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

  int finalDefenseValue() {
    var roll = 0;
    var defense = 0;
    var numberOfDefensesModifier = 0;
    var surpriseModifier = isSurprised() ? -150 : 0;

    try {
      roll = defenseRoll.interpret().toInt();
    } catch (e) {
      // Defaults to 0
    }

    try {
      defense = baseDefense.interpret().toInt();
    } catch (e) {
      // Defaults to 0
    }

    switch (defenseNumber) {
      case 1:
        numberOfDefensesModifier = -30;
      case 2:
        numberOfDefensesModifier = -50;
      case 3:
        numberOfDefensesModifier = -70;
      case 4:
        numberOfDefensesModifier = -90;
    }

    return defenderModifiers.getAllModifiersForDefense(defenseType) +
        roll +
        defense +
        numberOfDefensesModifier +
        surpriseModifier;
  }

  bool isSurprised() {
    return finalTurnAttacker - 150 >= finalTurnDefense;
  }

  int calculateDamage() {
    var attack = finalAttackValue();
    var defense = finalDefenseValue();

    var difference = attack - defense;

    var baseDamageCalc = 0;
    var armourType = 0;

    try {
      baseDamageCalc = baseDamage.interpret().toInt();
    } catch (e) {
      // Defaults to 0
    }

    try {
      armourType = armour.interpret().toInt();
    } catch (e) {
      // Defaults to 0
    }

    return ((baseDamageCalc - armourType * 10) * (difference / 100)).toInt();
  }

  String combatTotal() {
    var attack = finalAttackValue();
    var defense = finalDefenseValue();

    var difference = attack - defense;

    if (difference > 0) {
      return "Diferencia: $difference ${isSurprised() ? "(+80: ${difference + 80} Sorprendido!)" : ""}, Daño causado: ${calculateDamage()} ";
    } else {
      return "Diferencia: $difference ${isSurprised() ? "(+80: ${difference + 80} Sorprendido!)" : ""}, Contraataca con:  ${-difference ~/ 2}";
    }
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
    String? defenseRoll,
    String? armour,
    String? baseDefense,
    DefenseType? defenseType,
    int? defenseNumber,
    int? attackerTurn,
    int? defenseTurn,
  }) {
    combatState.attackRoll = attackRoll ?? combatState.attackRoll;
    combatState.baseDamage = baseDamage ?? combatState.baseDamage;
    combatState.baseAttack = baseAttack ?? combatState.baseAttack;

    combatState.defenseRoll = defenseRoll ?? combatState.defenseRoll;
    combatState.armour = armour ?? combatState.armour;
    combatState.baseDefense = baseDefense ?? combatState.baseDefense;

    combatState.defenseType = DefenseType.parry;

    combatState.attackingCharacter =
        attackingCharacter ?? combatState.attackingCharacter;
    combatState.defendantCharacter =
        defendantCharacter ?? combatState.defendantCharacter;

    combatState.attackingModifiers =
        attackingModifiers ?? combatState.attackingModifiers;
    combatState.defenderModifiers =
        defenderModifiers ?? combatState.defenderModifiers;

    combatState.defenseNumber = defenseNumber ?? combatState.defenseNumber;

    combatState.finalTurnAttacker =
        attackerTurn ?? combatState.finalTurnAttacker;

    combatState.finalTurnDefense = defenseTurn ?? combatState.finalTurnDefense;

    notifyListeners();
  }

  Character? characterAttacking() {
    try {
      return characters[combatState.attackingCharacter];
    } catch (e) {
      return null;
    }
  }

  Character? characterDefending() {
    try {
      return characters[combatState.defendantCharacter];
    } catch (e) {
      return null;
    }
  }

  void removeCharacter(Character character) {
    characters.remove(character);
    notifyListeners();
  }

  void rollTurns() {
    for (Character character in characters) {
      character.rollInitiative();
      character.state.hasAction = true;
      character.state.defenseNumber = 0;
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
                height: isLandscape ? height : height / 3,
                width: isLandscape ? screenSize.width / 1.5 : screenSize.width,
                child: CharactersTable(),
              ),
              SizedBox(
                height: isLandscape ? height : height / 1.5, // 3
                width: isLandscape ? screenSize.width / 3 : screenSize.width,
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
              "${appState.characterAttacking()?.profile.name} Ataca (Total: ${appState.combatState.finalAttackValue()})",
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
              ],
            ),

            // Defense roll
            _createCard(
              "${appState.characterDefending()?.profile.name} ${appState.combatState.defenseType.name()} (Total: ${appState.combatState.finalDefenseValue()})",
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
                              text: appState.combatState.defenseRoll,
                              label: "Tirada de defensa",
                              suffixIcon: IconButton(
                                onPressed: () {
                                  appState.updateCombatState(
                                      defenseRoll: Roll.roll().roll.toString());
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
                              label: "Defensa base",
                              text: appState.combatState.baseDefense,
                              onChanged: (value) => appState.updateCombatState(
                                  baseDefense: value),
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
                                appState.updateCombatState(armour: value);
                              },
                              text: appState.combatState.armour,
                              label: "Tabla de armadura",
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
                                var combat = appState.combatState;
                                BottomSheetModifiers.show(
                                    context,
                                    combat.defenderModifiers,
                                    Modifiers.getSituationalModifiers(
                                        combat.defenseType.toModifierType()),
                                    (newModifiers) {
                                  appState.updateCombatState(
                                      defenderModifiers: newModifiers);
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
                                    appState.combatState.defenderModifiers
                                        .getAllModifiersForDefense(
                                            appState.combatState.defenseType)
                                        .toString(),
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
                  height: 60,
                  child: Row(
                    children: [
                      Text(
                          "Cantidad de defensas: (${appState.combatState.defenseNumber + 1})"),
                      Expanded(
                        child: Slider(
                          value: appState.combatState.defenseNumber.toDouble(),
                          max: 4,
                          divisions: 5,
                          label:
                              "Defensa n° ${appState.combatState.defenseNumber + 1}",
                          onChanged: (value) {
                            appState.updateCombatState(
                              defenseNumber: value.toInt(),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),

            // Total
            _createCard(
              "Resultado",
              theme,
              [
                Text(
                  appState.combatState.combatTotal(),
                ),
              ],
            ),
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
