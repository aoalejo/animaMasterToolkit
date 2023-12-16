import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:amt/models/armour.dart';
import 'package:amt/models/character/character.dart';
import 'package:amt/models/enums.dart';
import 'package:amt/models/modifiers_state.dart';
import 'package:amt/presentation/states/combat_state.dart';
import 'package:enough_convert/windows.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

class CharactersPageState extends ChangeNotifier {
  List<Character> characters = [];
  var combatState = ScreenCombatState();
  String? errorMessage = "";
  int pageSelected = 0;

  late Box<Character> _box;

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

  addCharacter(Character character, {bool isNpc = false}) {
    if (isNpc) {
      var number =
          characters.where((element) => element.profile.isNpc ?? false).length +
              1;
      var newChar = character.copyWith(
        uuid: Uuid().v4(),
        isNpc: isNpc,
        number: number,
      );
      characters.add(newChar);
      _box.add(newChar);
    } else {
      characters.add(character);
      _box.add(character);
    }

    notifyListeners();
  }

  removeAllNPC() {
    for (var char in characters) {
      if (char.profile.isNpc == true) {
        char.delete();
      }
    }
    characters.removeWhere((element) => element.profile.isNpc == true);
    notifyListeners();
  }

  updatePageSelected(int index) {
    pageSelected = index;
    notifyListeners();
  }

  void updateAttackingModifiers(ModifiersState modifiers) {
    combatState.attack.attackingModifiers = modifiers;
    notifyListeners();
  }

  void updateDefenderModifiers(ModifiersState modifiers) {
    combatState.defense.defenderModifiers = modifiers;
    notifyListeners();
  }

  void removeDefendant() {
    combatState.defense.defendant = null;

    notifyListeners();
  }

  void removeAttacker() {
    combatState.attack.attacker = null;
    notifyListeners();
  }

  void updateCombatState({
    String? attackRoll,
    String? baseDamage,
    Character? attacking,
    Character? defendant,
    ModifiersState? attackingModifiers,
    ModifiersState? defenderModifiers,
    String? defenseRoll,
    String? armour,
    DefenseType? defenseType,
    Armour? selectedArmour,
    DamageTypes? damageType,
    String? criticalRoll,
    String? physicalResistanceBase,
    String? physicalResistanceRoll,
    String? damageDone,
    String? localizationRoll,
    String? modifierReduction,
    String? baseAttackModifiers,
    String? baseDefenseModifiers,
  }) {
    combatState.attack.attackModifier =
        baseAttackModifiers ?? combatState.attack.attackModifier;
    combatState.defense.baseDefenseModifiers =
        baseDefenseModifiers ?? combatState.defense.baseDefenseModifiers;

    combatState.critical.modifierReduction =
        modifierReduction ?? combatState.critical.modifierReduction;
    combatState.critical.localizationRoll =
        localizationRoll ?? combatState.critical.localizationRoll;

    combatState.critical.damageDone =
        damageDone ?? combatState.critical.damageDone;
    combatState.critical.physicalResistanceBase =
        physicalResistanceBase ?? combatState.critical.physicalResistanceBase;
    combatState.critical.criticalRoll =
        criticalRoll ?? combatState.critical.criticalRoll;
    combatState.critical.physicalResistanceRoll =
        physicalResistanceRoll ?? combatState.critical.physicalResistanceRoll;

    combatState.attack.attackRoll = attackRoll ?? combatState.attack.attackRoll;
    combatState.attack.damageModifier =
        baseDamage ?? combatState.attack.damageModifier;

    combatState.defense.defenseRoll =
        defenseRoll ?? combatState.defense.defenseRoll;
    combatState.defense.armourModifier =
        armour ?? combatState.defense.armourModifier;

    combatState.defense.defenseType =
        defenseType ?? combatState.defense.defenseType;

    combatState.attack.damageType = damageType ?? combatState.attack.damageType;

    combatState.attack.attacker = attacking ?? combatState.attack.attacker;
    combatState.defense.defendant = defendant ?? combatState.defense.defendant;

    combatState.attack.attackingModifiers =
        attackingModifiers ?? combatState.attack.attackingModifiers;
    combatState.defense.defenderModifiers =
        defenderModifiers ?? combatState.defense.defenderModifiers;

    notifyListeners();
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

    if (character.uuid == combatState.attack.attacker?.uuid) {
      var weapon = character.selectedWeapon();

      updateCombatState(
        baseDamage: weapon.damage.toString(),
      );
    }

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
