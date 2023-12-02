import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:amt/models/armour.dart';
import 'package:amt/models/character/character.dart';
import 'package:amt/models/enums.dart';
import 'package:amt/models/modifiers_state.dart';
import 'package:amt/models/weapon.dart';
import 'package:amt/presentation/states/combat_state.dart';
import 'package:enough_convert/windows.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CharactersPageState extends ChangeNotifier {
  List<Character> characters = [];
  var combatState = ScreenCombatState();
  String? errorMessage = "";
  int pageSelected = 0;

  late Box<Character> _box;

  updatePageSelected(int index) {
    pageSelected = index;
    notifyListeners();
  }

  CharactersPageState() {
    initAsync();
  }

  void initAsync() async {
    try {
      _box = await Hive.openBox('characters');
      characters.addAll(_box.values.toList());
      notifyListeners();
    } catch (e) {
      Hive.deleteBoxFromDisk('characters');
      _box = await Hive.openBox('characters');
    }
  }

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
    String? attackingCharacter,
    String? defendantCharacter,
    ModifiersState? attackingModifiers,
    ModifiersState? defenderModifiers,
    String? defenseRoll,
    String? armour,
    String? baseDefense,
    DefenseType? defenseType,
    int? defenseNumber,
    int? attackerTurn,
    int? defenseTurn,
    Weapon? selectedWeapon,
    Armour? selectedArmour,
    DamageTypes? damageType,
    String? criticalRoll,
    String? physicalResistanceBase,
    String? physicalResistanceRoll,
    String? damageDone,
    int? actualHitPoints,
    String? localizationRoll,
    String? modifierReduction,
  }) {
    combatState.modifierReduction =
        modifierReduction ?? combatState.modifierReduction;
    combatState.localizationRoll =
        localizationRoll ?? combatState.localizationRoll;
    combatState.actualHitPoints =
        actualHitPoints ?? combatState.actualHitPoints;

    combatState.damageDone = damageDone ?? combatState.damageDone;
    combatState.physicalResistanceBase =
        physicalResistanceBase ?? combatState.physicalResistanceBase;
    combatState.criticalRoll = criticalRoll ?? combatState.criticalRoll;
    combatState.physicalResistanceRoll =
        physicalResistanceRoll ?? combatState.physicalResistanceRoll;

    combatState.attackRoll = attackRoll ?? combatState.attackRoll;
    combatState.baseDamage = baseDamage ?? combatState.baseDamage;
    combatState.baseAttack = baseAttack ?? combatState.baseAttack;

    combatState.defenseRoll = defenseRoll ?? combatState.defenseRoll;
    combatState.armour = armour ?? combatState.armour;
    combatState.baseDefense = baseDefense ?? combatState.baseDefense;

    combatState.defenseType = defenseType ?? combatState.defenseType;

    combatState.selectedArmour = selectedArmour ?? combatState.selectedArmour;
    combatState.selectedWeapon = selectedWeapon ?? combatState.selectedWeapon;
    combatState.damageType = damageType ?? combatState.damageType;

    if (damageType != null) {
      combatState.armour =
          combatState.selectedArmour.armourFor(damageType).toString();
    }

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
      return characters.firstWhere(
          (element) => element.uuid == combatState.attackingCharacter);
    } catch (e) {
      return null;
    }
  }

  Character? characterDefending() {
    try {
      return characters.firstWhere(
          (element) => element.uuid == combatState.defendantCharacter);
    } catch (e) {
      return null;
    }
  }

  void removeCharacter(Character character) {
    characters.remove(character);
    character.delete();
    notifyListeners();
  }

  void rollTurns() {
    for (Character character in characters) {
      var allModifiers = character.state.modifiers.getAll();

      for (var element in allModifiers) {
        if (element.isOfCritical ?? false) {
          element.attack = min(element.attack + 5, element.midValue ?? 0);
          element.dodge = min(element.dodge + 5, element.midValue ?? 0);
          element.parry = min(element.parry + 5, element.midValue ?? 0);
          element.physicalAction =
              min(element.physicalAction + 5, element.midValue ?? 0);
          element.turn = min(element.turn + 5, element.midValue ?? 0);
        }
      }

      // character.state.modifiers.clear();
      character.state.modifiers.setAll(allModifiers);

      character.rollInitiative();
      character.state.hasAction = true;
      character.state.defenseNumber = 1;
    }

    characters.sort(Character.initiativeSort);
    notifyListeners();
  }

  void resetConsumables() {
    for (Character character in characters) {
      for (var consumable in character.state.consumables) {
        consumable.actualValue = consumable.maxValue;
      }
    }

    notifyListeners();
  }

  void updateCharacter(Character? character) {
    if (character == null) return;

    int index =
        characters.indexWhere((element) => element.uuid == character.uuid);

    characters[index] = character;

    notifyListeners();
    character.save();
  }

  void getCharacters() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
      allowMultiple: true,
    );

    if (result?.files.isEmpty ?? true) {
      errorMessage = "$errorMessage Sin archivos encontrados";
    }

    try {
      if (result != null) {
        if (result.files.first.bytes != null) {
          // For web
          List<String> files = result.files
              .map((file) => Windows1252Codec().decode(file.bytes!.toList()))
              .toList();

          for (var file in files) {
            var character = Character.fromJson(jsonDecode(file));
            characters.add(character);
            _box.add(character);
          }
        } else {
          // For desktop
          List<File> files =
              result.paths.map((path) => File(path ?? "")).toList();

          for (var file in files) {
            final json = await file.readAsString(encoding: Windows1252Codec());
            var character = Character.fromJson(jsonDecode(json));
            print(character.toString());
            characters.add(character);
            print("character added");

            _box.add(character);
          }
        }
      } else {
        errorMessage = "$errorMessage Error leyendo archivos";
      }
    } catch (e) {
      errorMessage = "$errorMessage ${e.toString()}";
    }

    notifyListeners();
  }
}
