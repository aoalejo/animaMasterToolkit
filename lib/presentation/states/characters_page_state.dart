import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:amt/models/character/character.dart';
import 'package:amt/models/enums.dart';
import 'package:amt/models/modifiers_state.dart';
import 'package:amt/models/rules/rules.dart';
import 'package:amt/presentation/states/combat_state.dart';
import 'package:amt/utils/cloud_excel_parser.dart';
import 'package:amt/utils/string_extension.dart';
import 'package:enough_convert/windows.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/web.dart';
import 'package:uuid/uuid.dart';

class CharactersPageState extends ChangeNotifier {
  CharactersPageState() {
    initAsync();
  }
  List<Character> characters = [];
  ScreenCombatState combatState = ScreenCombatState();
  String? errorMessage = '';
  int pageSelected = 0;
  bool isLoading = false;
  String? message;

  double sheetsLoadingPercentaje = -1;

  Map<String, bool> explanationsExpanded = {};

  late Box<Character> _box;

  void stepSheetLoading() {
    if (sheetsLoadingPercentaje > 0.9) {
      sheetsLoadingPercentaje = sheetsLoadingPercentaje + 0.0010;
    } else if (sheetsLoadingPercentaje > 0.75) {
      sheetsLoadingPercentaje = sheetsLoadingPercentaje + 0.0025;
    } else if (sheetsLoadingPercentaje > 0.5) {
      sheetsLoadingPercentaje = sheetsLoadingPercentaje + 0.0050;
    } else {
      sheetsLoadingPercentaje = sheetsLoadingPercentaje + 0.0100;
    }
    notifyListeners();
  }

  void updateSheetLoading(double value) {
    sheetsLoadingPercentaje = value;
    notifyListeners();
  }

  void showLoading({String? message}) {
    this.message = message;
    isLoading = true;
    notifyListeners();
  }

  void hideLoading({String? message}) {
    this.message = null;
    isLoading = false;
    notifyListeners();
  }

  Future<void> initAsync() async {
    try {
      _box = await Hive.openBox('characters');
      characters.addAll(_box.values.toList());
      notifyListeners();
    } catch (e) {
      await Hive.deleteBoxFromDisk('characters');
      _box = await Hive.openBox('characters');
    }
  }

  toggleExplanationStatus(String name) {
    if (explanationsExpanded.containsKey(name)) {
      explanationsExpanded[name] = !explanationsExpanded[name]!;
    } else {
      explanationsExpanded[name] = true;
    }
    notifyListeners();
  }

  addCharacter(Character character, {bool isNpc = false}) {
    // Numbering, get all characters with # in the name:
    var maxValue = 0;
    for (final element in characters.where(
      (element) => element.nameNormalized() == character.nameNormalized(),
    )) {
      final split = element.profile.name.split('#');
      final value = int.tryParse(split.last);
      maxValue = max(value ?? 0, maxValue);
    }

    if (isNpc) {
      final newChar = character.copyWith(
        uuid: const Uuid().v4(),
        isNpc: isNpc,
        number: maxValue + 1,
      );
      characters.add(newChar);
      _box.add(newChar);
    } else {
      if (maxValue > 0) {
        character.profile.name = '${character.profile.name} #${maxValue + 1}';
      }

      characters.add(character);
      _box.add(character);
    }

    notifyListeners();
  }

  removeAllNPC() {
    for (final char in characters) {
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
    combatState.attack.modifiers = modifiers;
    notifyListeners();
  }

  void updateDefenderModifiers(ModifiersState modifiers) {
    combatState.defense.modifiers = modifiers;
    notifyListeners();
  }

  void removeDefendant() {
    combatState.defense.character = null;

    notifyListeners();
  }

  void removeAttacker() {
    combatState.attack.character = null;
    notifyListeners();
  }

  void updateCombatState({
    String? attackRoll,
    String? damageModifier,
    Character? attacking,
    Character? defendant,
    ModifiersState? attackingModifiers,
    ModifiersState? defenderModifiers,
    String? defenseRoll,
    String? armourModifier,
    DefenseType? defenseType,
    DamageTypes? damageType,
    String? criticalRoll,
    String? physicalResistanceBase,
    String? physicalResistanceRoll,
    String? damageDone,
    String? localizationRoll,
    String? modifierReduction,
    String? baseAttackModifiers,
    String? baseDefenseModifiers,
    SurpriseType? surprise,
  }) {
    combatState.attack.attack = baseAttackModifiers ?? combatState.attack.attack;
    combatState.defense.defense = baseDefenseModifiers ?? combatState.defense.defense;

    combatState.critical.modifierReduction = modifierReduction ?? combatState.critical.modifierReduction;
    combatState.critical.localizationRoll = localizationRoll ?? combatState.critical.localizationRoll;

    combatState.critical.damageDone = damageDone ?? combatState.critical.damageDone;
    combatState.critical.physicalResistanceBase = physicalResistanceBase ?? combatState.critical.physicalResistanceBase;
    combatState.critical.criticalRoll = criticalRoll ?? combatState.critical.criticalRoll;
    combatState.critical.physicalResistanceRoll = physicalResistanceRoll ?? combatState.critical.physicalResistanceRoll;

    combatState.attack.roll = attackRoll ?? combatState.attack.roll;
    combatState.attack.damage = damageModifier ?? combatState.attack.damage;

    combatState.defense.roll = defenseRoll ?? combatState.defense.roll;
    combatState.defense.armour = armourModifier ?? combatState.defense.armour;

    combatState.defense.defenseType = defenseType ?? combatState.defense.defenseType;

    combatState.attack.damageType = damageType ?? combatState.attack.damageType;

    combatState.attack.character = attacking ?? combatState.attack.character;
    combatState.defense.character = defendant ?? combatState.defense.character;

    combatState.attack.modifiers = attackingModifiers ?? combatState.attack.modifiers;
    combatState.defense.modifiers = defenderModifiers ?? combatState.defense.modifiers;

    combatState.surpriseType = surprise ?? combatState.surpriseType;

    notifyListeners();
  }

  void removeCharacter(Character character) {
    characters.remove(character);
    character.delete();
    notifyListeners();
  }

  void rollTurns() {
    for (final character in characters) {
      final allModifiers = character.state.modifiers.getAll();

      for (final element in allModifiers) {
        if (element.isOfCritical ?? false) {
          element.attack = min(element.attack + 5, element.midValue ?? 0);
          element.dodge = min(element.dodge + 5, element.midValue ?? 0);
          element.parry = min(element.parry + 5, element.midValue ?? 0);
          element.physicalAction = min(element.physicalAction + 5, element.midValue ?? 0);
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
    for (final character in characters) {
      for (final consumable in character.state.consumables) {
        consumable.actualValue = consumable.maxValue;
      }
      character.save();
    }
    notifyListeners();
  }

  void updateCharacter(Character? character) {
    if (character == null) return;

    final index = characters.indexWhere((element) => element.uuid == character.uuid);

    characters[index] = character;

    notifyListeners();
    character.save();
  }

  Future parseCharacters(FilePickerResult? filesPicked, Function(double) onUpdated) async {
    Logger().d('result: ${filesPicked?.count}');

    try {
      if (filesPicked != null) {
        var counter = 0;
        final total = filesPicked.files.length;

        if (filesPicked.files.first.bytes != null) {
          // For web
          for (final element in filesPicked.files) {
            onUpdated(counter / total);
            Logger().d('Progress: $counter / $total');

            if (element.extension == 'json') {
              final jsonFile = const Windows1252Codec().decode(element.bytes!.toList());
              final character = Character.fromJson(jsonFile.jsonMap);
              if (character != null) addCharacter(character);
            } else {
              final character = CloudExcelParser.fromBytes(element.bytes!.toList());
              final characterDecoded = await character.parse();

              if (characterDecoded != null) addCharacter(characterDecoded);
            }

            counter = counter + 1;
          }
        } else {
          // For desktop
          final files = filesPicked.paths.map((path) => File(path ?? '')).toList();

          for (final file in files) {
            onUpdated(counter / total);
            Logger().d('Progress: $counter / $total');

            final extension = file.path.split('.').last;
            if (extension == 'json') {
              final json = await file.readAsString(encoding: const Windows1252Codec());
              final character = Character.fromJson(json.jsonMap);
              if (character != null) addCharacter(character);
            } else {
              final character = CloudExcelParser.fromFile(file);
              final characterDecoded = await character.parse();

              if (characterDecoded != null) addCharacter(characterDecoded);
            }
            counter = counter + 1;
          }
        }
      } else {
        errorMessage = '$errorMessage Error leyendo archivos';
      }
    } catch (e) {
      errorMessage = '$errorMessage $e';
    }
    onUpdated(-1);
  }

  Future<FilePickerResult?> getCharacters() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json', 'xlsm', 'xlsx'],
      allowMultiple: true,
    );

    if (result?.files.isEmpty ?? true) {
      errorMessage = '$errorMessage Sin archivos encontrados';
    }

    return result;
  }
}
