import 'dart:convert';
import 'dart:io';

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
  var characters = <Character>[];
  var combatState = ScreenCombatState();

  late Box<Character> _box;

  CharactersPageState() {
    initAsync();
  }

  void initAsync() async {
    print("openBox");
    _box = await Hive.openBox('characters');
    print("opened box characters");
    characters = _box.values.toList();
    notifyListeners();
    print("characters");
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
    Weapon? selectedWeapon,
    Armour? selectedArmour,
    DamageTypes? damageType,
  }) {
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
    character.delete();
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

  void resetConsumables() {
    for (Character character in characters) {
      for (var consumable in character.state.consumables) {
        consumable.actualValue = consumable.maxValue;
      }
    }

    notifyListeners();
  }

  void updateCharacter(Character character) {
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

    if (result != null) {
      try {
        // For web
        List<String> files = result.files
            .map((file) => Windows1252Codec().decode(file.bytes!.toList()))
            .toList();

        for (var file in files) {
          var character = Character.fromJson(jsonDecode(file));
          characters.add(character);
          _box.add(character);
        }
      } catch (e) {
        // For desktop
        List<File> files =
            result.paths.map((path) => File(path ?? "")).toList();

        for (var file in files) {
          final json = await file.readAsString(encoding: Windows1252Codec());
          var character = Character.fromJson(jsonDecode(json));
          characters.add(character);
          _box.add(character);
        }
      }
    }

    notifyListeners();
  }
}