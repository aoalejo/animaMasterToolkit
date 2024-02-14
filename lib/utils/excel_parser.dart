import 'dart:io';
import 'dart:isolate';

import 'package:amt/models/armour.dart';
import 'package:amt/models/armour_data.dart';
import 'package:amt/models/attributes_list.dart';
import 'package:amt/models/character/character.dart';
import 'package:amt/models/character/character_resistances.dart';
import 'package:amt/models/character/character_state.dart';
import 'package:amt/models/character_profile.dart';
import 'package:amt/models/combat_data.dart';
import 'package:amt/models/modifiers_state.dart';
import 'package:amt/models/roll.dart';
import 'package:excel/excel.dart';

class ExcelParser {
  static Future<Character> parseFile(File file) async {
    var start = DateTime.now().millisecondsSinceEpoch;
    print("Start $start");
    var bytes = file.readAsBytesSync();

    return await Isolate.run(() async {
      var excel = Excel.decodeBytes(bytes);
      print("Elapsed readAsBytesSync: ${DateTime.now().millisecondsSinceEpoch - start}");

      return _parseExcel(excel);
    });
  }

  static Character parseBytes(List<int> bytes) {
    var start = DateTime.now().millisecondsSinceEpoch;
    print("Start $start");

    var file = Excel.decodeBytes(bytes);

    print("Elapsed decodeBytes: ${DateTime.now().millisecondsSinceEpoch - start}");
    return _parseExcel(file);
  }

  static Character _parseExcel(Excel? excel) {
    var general = excel?['General'];
    print(general.toString());

    var name = general?.valueAt('F22');
    print(name);

    return Character(
        uuid: name ?? "",
        attributes: AttributesList.withDefault(6),
        skills: {},
        profile: CharacterProfile(name: name ?? ""),
        combat: CombatData(armour: ArmourData(calculatedArmour: Armour(), armours: []), weapons: []),
        state: CharacterState(currentTurn: Roll.turn(), consumables: [], modifiers: ModifiersState()),
        ki: null,
        mystical: null,
        psychic: null,
        resistances: CharacterResistances());
  }
}

extension on Sheet {
  String valueAt(String name) {
    return cell(CellIndex.indexByString(name)).toString();
  }
}
