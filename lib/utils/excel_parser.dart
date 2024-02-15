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
import 'package:amt/models/enums.dart';
import 'package:amt/models/modifiers_state.dart';
import 'package:amt/models/mystical.dart';
import 'package:amt/models/roll.dart';
import 'package:amt/models/weapon.dart';
import 'package:amt/utils/json_utils.dart';
import 'package:excel/excel.dart';
import 'package:uuid/uuid.dart';

class ExcelParser {
  File? file;
  List<int>? bytes;
  late Excel excel;

  ExcelParser.fromFile(this.file);
  ExcelParser.fromBytes(this.bytes);

  Future<Character> parse() {
    if (file != null) {
      return _parseFile(file!);
    } else {
      return _parseBytes(bytes!);
    }
  }

  Future<Character> _parseFile(File file) async {
    var start = DateTime.now().millisecondsSinceEpoch;
    print("Start $start");
    var bytes = file.readAsBytesSync();

    return await Isolate.run(() async {
      excel = Excel.decodeBytes(bytes);
      print("Elapsed readAsBytesSync: ${DateTime.now().millisecondsSinceEpoch - start}");
      final character = _parseExcel();
      return character;
    });
  }

  Future<Character> _parseBytes(List<int> bytes) async {
    var start = DateTime.now().millisecondsSinceEpoch;
    print("Start $start");

    return await Isolate.run(() async {
      excel = Excel.decodeBytes(bytes);
      print("Elapsed decodeBytes: ${DateTime.now().millisecondsSinceEpoch - start}");

      var character = _parseExcel();

      return character;
    });
  }

  Character _parseExcel() {
    var attributes = _getAttributes();
    var skills = excel.points.getMapFromRange("M22", "Q77", indexTitles: 1, indexValues: 5);
    var basicData = _getBasicData();
    var combatData = _getAllCombatData();
    var mysticalData = _getMysticData();
    var resistances = _getResistances();

    final character = Character(
      uuid: Uuid().v4(),
      attributes: attributes,
      skills: skills,
      profile: basicData,
      combat: combatData,
      state: CharacterState(currentTurn: Roll.turn(), consumables: [], modifiers: ModifiersState()),
      ki: null,
      mystical: mysticalData,
      psychic: null,
      resistances: resistances,
    );

    print(character.getResumedSkills());
    print(character.attributes.toString());
    print(character.profile.toString());
    print(character.combat.toString());
    print(character.state.toString());
    print(character.mystical.toString());
    print(character.resistances.toString());

    return character;
  }

  CharacterResistances _getResistances() {
    final resistances = excel.principal.getMapFromRange("D57", "J62", indexTitles: 1, indexValues: 7);
    return CharacterResistances.fromJson(resistances);
  }

  AttributesList _getAttributes() {
    final attributes = excel.principal.getMapFromRange("D11", "H18", indexTitles: 1, indexValues: 4);
    return AttributesList.fromJson(attributes);
  }

  Mystical? _getMysticData() {
    final sheet = excel.mystic;

    if (!_hasPointsOnMistic()) {
      return null;
    }

    return Mystical(
      zeonRegeneration: sheet.intAt("J12"),
      act: sheet.intAt("L12"),
      zeon: sheet.intAt("K18"),
      paths: sheet.getMapFromRange("C15", "H25", indexTitles: 1, indexValues: 6),
      subPaths: sheet.getMapFromRange("C15", "H25", indexTitles: 1, indexValues: 3),
      metamagic: sheet.getMapFromRange("W53", "AB73", indexTitles: 1, indexValues: 6),
      spellsMaintained: sheet.getMapFromRange("Y12", "AC50", indexTitles: 5, indexValues: 1),
      spellsPurchased: sheet.getMapFromRange("AG12", "AK50", indexTitles: 5, indexValues: 1),
    );
  }

  CharacterProfile _getBasicData() {
    final sheet = excel.principal;
    return CharacterProfile(
      fatigue: sheet.intAt("N16"),
      hitPoints: sheet.intAt("N11"),
      regeneration: sheet.intAt("J11"),
      speed: sheet.intAt("J16"),
      name: sheet.stringAt("K4"),
      category: sheet.stringAt("K5"),
      level: sheet.stringAt("O6"),
      kind: sheet.stringAt("K7"),
      nature: sheet.intAt("AB14"),
      fumbleLevel: 3,
    );
  }

  CombatData _getAllCombatData() {
    var weaponsRanges = ["C27", "C34", "C41", "N27", "N34", "N41"];
    var rangedWeaponsRanges = ["C49", "C58", "N49", "N58"];

    List<Weapon> weapons = [];

    weapons.add(_getUnarmedCombatData());

    if (_hasPointsOnMistic()) weapons.add(_getMagicProjectionAsWeapon());
    if (_hasPointsOnPsychic()) weapons.add(_getPsychicProjectionAsWeapon());

    for (var weapon in weaponsRanges) {
      weapons.add(_getBaseCombatData(weapon));
    }

    for (var weapon in rangedWeaponsRanges) {
      weapons.add(_getRangedCombatData(weapon));
    }

    return CombatData(armour: _getArmourData(), weapons: weapons);
  }

  ArmourData _getArmourData() {
    final sheet = excel.combat;

    return ArmourData(
      movementRestriction: sheet.intAt("E16"),
      naturalPenalty: sheet.intAt("H17"),
      requirement: sheet.intAt("H16"),
      physicalPenalty: sheet.intAt("S16"),
      finalNaturalPenalty: sheet.intAt("S17"),
      calculatedArmour: Armour(
        fil: sheet.intAt("I16"),
        con: sheet.intAt("J16"),
        pen: sheet.intAt("K16"),
        cal: sheet.intAt("L16"),
        ele: sheet.intAt("M16"),
        fri: sheet.intAt("N16"),
        ene: sheet.intAt("O16"),
      ),
      armours: _getArmours(),
    );
  }

  List<Armour> _getArmours() {
    final sheet = excel.combat;
    final range = sheet.valuesOn("C12", "S15");

    List<Armour> armours = [];

    for (var row in range) {
      if (row?[0] != '') {
        armours.add(Armour(
          name: row?[0],
          location: JsonUtils.armourLocation(row?[4]),
          quality: int.tryParse(row?[6]) ?? 0,
          fil: int.tryParse(row?[7]) ?? 0,
          con: int.tryParse(row?[8]) ?? 0,
          pen: int.tryParse(row?[9]) ?? 0,
          cal: int.tryParse(row?[10]) ?? 0,
          ele: int.tryParse(row?[11]) ?? 0,
          fri: int.tryParse(row?[12]) ?? 0,
          ene: int.tryParse(row?[13]) ?? 0,
          endurance: int.tryParse(row?[14]) ?? 0,
          presence: int.tryParse(row?[15]) ?? 0,
          movementRestriction: int.tryParse(row?[16]) ?? 0,
          enchanted: bool.tryParse(row?[17]),
        ));
      }
    }

    return armours;
  }

  Weapon _getMagicProjectionAsWeapon() {
    final sheet = excel.mystic;
    const rangeStart = "O12";

    return Weapon(
      name: 'Proyección Magica',
      turn: sheet.intInRange("A1", rangeStart),
      attack: sheet.intInRange("B1", rangeStart),
      defense: sheet.intInRange("C1", rangeStart),
      defenseType: DefenseType.parry,
      damage: 0,
      type: 'Místico',
      known: KnownType.known,
      size: WeaponSize.normal,
      principalDamage: DamageTypes.ene,
      secondaryDamage: DamageTypes.pen,
      endurance: 999,
      breakage: 0,
      presence: 0,
      quality: 0,
      variableDamage: true,
    );
  }

  Weapon _getPsychicProjectionAsWeapon() {
    final sheet = excel.psychic;
    const rangeStart = "O12";

    return Weapon(
      name: 'Proyección Psiquica',
      turn: sheet.intInRange("A1", rangeStart),
      attack: sheet.intInRange("B1", rangeStart),
      defense: sheet.intInRange("C1", rangeStart),
      defenseType: DefenseType.parry,
      damage: 0,
      type: 'Psiquica',
      known: KnownType.known,
      size: WeaponSize.normal,
      principalDamage: DamageTypes.ene,
      secondaryDamage: DamageTypes.pen,
      endurance: 999,
      breakage: 0,
      presence: 0,
      quality: 0,
      variableDamage: true,
    );
  }

  Weapon _getUnarmedCombatData() {
    final sheet = excel.combat;
    const rangeStart = "C20";

    return Weapon(
      name: sheet.stringInRange("A1", rangeStart),
      turn: sheet.intInRange("F2", rangeStart),
      attack: sheet.intInRange("G2", rangeStart),
      defense: sheet.intInRange("H3", rangeStart),
      defenseType: JsonUtils.defenseType(sheet.stringInRange("I2", rangeStart)),
      damage: sheet.intInRange("J2", rangeStart),
      type: 'desarmado',
      known: JsonUtils.knownType(sheet.stringInRange("A2", rangeStart)),
      size: WeaponSize.normal,
      principalDamage: JsonUtils.damage(sheet.stringInRange("A4", rangeStart)),
      secondaryDamage: JsonUtils.damage(sheet.stringInRange("B4", rangeStart)),
      endurance: sheet.intInRange("C4", rangeStart),
      breakage: sheet.intInRange("D4", rangeStart),
      presence: sheet.intInRange("E4", rangeStart),
      variableDamage: false,
    );
  }

  Weapon _getBaseCombatData(String rangeStart) {
    final sheet = excel.combat;

    return Weapon(
      name: sheet.stringInRange("B1", rangeStart),
      turn: sheet.intInRange("F3", rangeStart),
      attack: sheet.intInRange("G3", rangeStart),
      defense: sheet.intInRange("H3", rangeStart),
      defenseType: JsonUtils.defenseType(sheet.stringInRange("I3", rangeStart)),
      damage: sheet.intInRange("J3", rangeStart),
      type: sheet.stringInRange("A2", rangeStart),
      known: JsonUtils.knownType(sheet.stringInRange("A3", rangeStart)),
      size: JsonUtils.weaponSize(sheet.stringInRange("D3", rangeStart)),
      principalDamage: JsonUtils.damage(sheet.stringInRange("A5", rangeStart)),
      secondaryDamage: JsonUtils.damage(sheet.stringInRange("B5", rangeStart)),
      endurance: sheet.intInRange("C5", rangeStart),
      breakage: sheet.intInRange("D5", rangeStart),
      presence: sheet.intInRange("E5", rangeStart),
      quality: sheet.intInRange("H5", rangeStart),
      characteristic: sheet.stringInRange("A6", rangeStart),
      warning: sheet.stringInRange("I6", rangeStart),
      special: sheet.stringInRange("H6", rangeStart),
      variableDamage: false,
    );
  }

  Weapon _getRangedCombatData(String rangeStart) {
    final sheet = excel.combat;

    return Weapon(
      name: sheet.stringInRange("C1", rangeStart),
      turn: sheet.intInRange("F2", rangeStart),
      attack: sheet.intInRange("G2", rangeStart),
      defense: sheet.intInRange("H2", rangeStart),
      defenseType: JsonUtils.defenseType(sheet.stringInRange("I2", rangeStart)),
      damage: sheet.intInRange("J2", rangeStart),
      type: sheet.stringInRange("A1", rangeStart),
      known: JsonUtils.knownType(sheet.stringInRange("A3", rangeStart)),
      size: JsonUtils.weaponSize(sheet.stringInRange("D3", rangeStart)),
      principalDamage: JsonUtils.damage(sheet.stringInRange("A5", rangeStart)),
      secondaryDamage: JsonUtils.damage(sheet.stringInRange("B5", rangeStart)),
      endurance: sheet.intInRange("C5", rangeStart),
      breakage: sheet.intInRange("D5", rangeStart),
      presence: sheet.intInRange("E5", rangeStart),
      quality: sheet.intInRange("H5", rangeStart),
      characteristic: sheet.stringInRange("A6", rangeStart),
      warning: sheet.stringInRange("I6", rangeStart),
      ammunition: sheet.stringInRange("C2", rangeStart),
      special: sheet.stringInRange("H6", rangeStart),
      variableDamage: false,
    );
  }

  bool _hasPointsOnMistic() {
    return (excel.points.intAt("M101") > 0);
  }

  bool _hasPointsOnPsychic() {
    return (excel.points.intAt("M117") > 0);
  }
}

extension on Sheet {
  Map<String, String> getMapFromRange(
    String start,
    String end, {
    required int indexTitles,
    required int indexValues,
  }) {
    final values = valuesOn(start, end);
    var result = <String, String>{};

    for (var element in values) {
      result[element?[indexTitles]] = element?[indexValues];
    }

    return result;
  }

  int intInRange(String name, String referenceStr) {
    var reference = CellIndex.indexByString(referenceStr);
    var objective = CellIndex.indexByString(name);

    var index = CellIndex.indexByColumnRow(
      columnIndex: reference.columnIndex + objective.columnIndex,
      rowIndex: reference.rowIndex + objective.rowIndex,
    );

    return int.tryParse(cell(index).value.toString()) ?? 0;
  }

  String stringInRange(String name, String referenceStr) {
    var reference = CellIndex.indexByString(referenceStr);
    var objective = CellIndex.indexByString(name);

    var index = CellIndex.indexByColumnRow(
      columnIndex: reference.columnIndex + objective.columnIndex,
      rowIndex: reference.rowIndex + objective.rowIndex,
    );

    return cell(index).value.toString();
  }

  List<List<dynamic>?> valuesOn(String start, String end) {
    final values = selectRange(
      CellIndex.indexByString(start),
      end: CellIndex.indexByString(end),
    );

    for (var row in values) {
      var rowStr = "";
      row?.forEach((cell) {
        final value = cell?.value;
        rowStr = "$rowStr\t$value";
      });
      print(rowStr);
    }

    return values;
  }

  int intAt(String coordinate) {
    return int.tryParse(stringAt(coordinate)) ?? 0;
  }

  String stringAt(String coordinate) {
    return cell(CellIndex.indexByString(coordinate)).value.toString();
  }
}

extension on Excel {
  Sheet get combat => this["Combate"];
  Sheet get points => this["PDs"];
  Sheet get principal => this["Principal"];
  Sheet get mystic => this["Místicos"];
  Sheet get psychic => this["Psíquicos"];
}
