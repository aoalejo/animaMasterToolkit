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
import 'package:amt/models/roll.dart';
import 'package:amt/models/weapon.dart';
import 'package:amt/utils/json_utils.dart';
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

  bool contains(List<String> column, String thisItem) {
    return column.contains(thisItem);
  }

/*
Public Sub exportJson()
    Dim rng As Range, json As String
    Dim intInFile As Integer
    
    json = "{"
    ' Set Attributes Block
    json = json & RangeToJson("Principal", "D11:H18", "A1", "D1", "Atributos")
    
    ' Set Skills Block
    json = json & "," & RangeToJson("Principal", "M22:Q77", "A1", "E1", "Habilidades")
    
    ' Set BasicData Block
    json = json & "," & getBasicData()
    
    ' Set Resistances Block
    json = json & "," & RangeToJson("Principal", "D57:J62", "A1", "G1", "Resistencias")
    
     ' Set Creature Powers Block
    json = json & "," & RangeToJson("Principal", "AB12:AH23", "A1", "E1", "PoderesDeCriatura")
    
    ' Set Elemental Habilities Block
    json = json & "," & RangeToJson("Principal", "AD12:AH69", "A1", "D1", "HabilidadesElementales")
    
    
    ' START Combat Section
    json = json & Replace(", 'Combate': {", "'", Chr(34))
    
    ' Set Weapons Tables Block
    json = json & RangeToJson("Combate", "AH11:AL16", "A1", "E1", "TablasDeArmas")
    
    ' Set Combat Styles Block
    json = json & "," & RangeToJson("Combate", "AB19:AQ28", "A1", "G1", "EstilosDeCombate")
    
    ' Set ArsMagnus Block
    json = json & "," & RangeToJson("Combate", "AB55:AQ64", "A1", "G1", "ArsMagnus")
    
    ' Set Combat Styles Block
    json = json & "," & RangeToJson("Combate", "AB31:AQ49", "A1", "E1", "ArtesMarciales")
    
    ' Set Combat Block
    json = json & ", " & getAllCombatData()
    
    ' END Combat Section
    
    json = json & "}"
    
    ' Set Ki Block
    json = json & Replace(", 'Ki': {", "'", Chr(34))
    
    json = json & RangeToJson("Ki", "C12:D23", "A1", "B1", "Acumulaciones")
    
    json = json & ", " & RangeToJson("Ki", "C35:F36", "A1", "D1", "Habilidades")
    
    json = json & "}"
    
    ' Set Elan Block
    
    json = json & ", " & RangeToJson("Elan", "C29:G49", "D1", "E1", "Elan")
    
    ' START Mistic Section
    
    If hasPointsOnMistic() Then
    
        json = json & Replace(", 'Misticos': {", "'", Chr(34))
        
        json = json & getMisticBasicData()
        
        json = json & ", " & RangeToJson("Místicos", "C15:H25", "A1", "F1", "Vias")
        
        json = json & ", " & RangeToJson("Místicos", "C15:H25", "A1", "C1", "SubVias")
        
        json = json & ", " & RangeToJson("Místicos", "W53:AB73", "A1", "F1", "Metamagia")
        
        json = json & ", " & RangeToJson("Místicos", "Y12:AC50", "E1", "A1", "Conjuros")
        
        json = json & ", " & RangeToJson("Místicos", "AG12:AK50", "E1", "A1", "Libres")
        
        json = json & "}"
    
    End If
    
    ' END Mistic Section
    
    ' START PSY Section
    
    If hasPointsOnMistic() Then
    
        json = json & Replace(", 'Psiquicos': {", "'", Chr(34))
        
        json = json & RangeToJson("Psíquicos", "C25:Q36", "A1", "D1", "Disciplinas")
        
        json = json & ", " & RangeToJson("Psíquicos", "C39:Q50", "A1", "D1", "Patrones")
        
        json = json & ", " & RangeToJson("Psíquicos", "V11:AB64", "A1", "G1", "Poderes")
        
        json = json & ", " & RangeToJson("Psíquicos", "AD17:AK62", "A1", "H1", "Innatos")
        
        
        json = json & "}"
        
    End If
    
    ' END PSY Section
    
    json = json & "}"
    
    Set wbA = ActiveWorkbook
    
    'get active workbook folder, if saved
    strPath = wbA.Path
    If strPath = "" Then
        strPath = Application.DefaultFilePath
    End If
    strPath = strPath & "\"
       
    'replace spaces and periods in character name
    strName = Replace(Range("ResumenNombre").Value, ".", "_")
    
    'create default name for savng file
    strFile = strName & ".json"
    strPathFile = strPath & strFile
    
    'use can enter name and
    ' select folder for file
    myFile = Application.GetSaveAsFilename _
        (InitialFileName:=strPathFile, _
        FileFilter:="Archivos Json (*.json), *.json", _
        Title:="Seleccione directorio y fichero donde guardar")
    
    intInFile = FreeFile
    
    Open myFile For Output As intInFile
        Print #intInFile, json
    Close intInFile
    
    
    Debug.Print json
End Sub
*/

/*
Function hasPointsOnMistic() As Boolean
    If Worksheets("PDs").Range("M101").Value > 0 Then
        hasPointsOnMistic = True
    Else
        hasPointsOnMistic = False
    End If
End Function
*/

/*
Function hasPointsOnPsichiq() As Boolean
    If Worksheets("PDs").Range("M117").Value > 0 Then
        hasPointsOnPsichiq = True
    Else
        hasPointsOnPsichiq = False
    End If
End Function
*/

/*
Function getMisticBasicData() As String
    regen = "J12"
    act = "L12"
    zeon = "K18"
  
    items = "'regen': '" & Worksheets("Místicos").Range(regen) & "',"
    items = items & "'act': '" & Worksheets("Místicos").Range(act) & "',"
    items = items & "'zeon': '" & Worksheets("Místicos").Range(zeon) & "'"
    
    getMisticBasicData = Replace(items, "'", Chr(34))
    
End Function
*/

/*
Function getBasicData() As String
    cansancio = "N16"
    puntosDeVida = "N11"
    regeneracion = "J11"
    movimiento = "J16"
    
    nombre = "K4"
    categoria = "K5"
    nivel = "O6"
    clase = "K7"
    
    acumDanio = "Y13"
    creadoConMagia = "Y14"
    gnosis = "AB13"
    natura = "AB14"
    
    items = "'datosElementales': {"
    
    items = items & "'cansancio': '" & Worksheets("Principal").Range(cansancio) & "',"
    items = items & "'puntosDeVida': '" & Worksheets("Principal").Range(puntosDeVida) & "',"
    items = items & "'regeneracion': '" & Worksheets("Principal").Range(regeneracion) & "',"
    items = items & "'nombre': '" & Worksheets("Principal").Range(nombre) & "',"
    items = items & "'categoria': '" & Worksheets("Principal").Range(categoria) & "',"
    items = items & "'nivel': '" & Worksheets("Principal").Range(nivel) & "',"
    items = items & "'clase': '" & Worksheets("Principal").Range(clase) & "',"
    
    items = items & "'acumDanio': '" & Worksheets("Principal").Range(acumDanio) & "',"
    items = items & "'creadoConMagia': '" & Worksheets("Principal").Range(creadoConMagia) & "',"
    items = items & "'gnosis': '" & Worksheets("Principal").Range(gnosis) & "',"
    items = items & "'natura': '" & Worksheets("Principal").Range(natura) & "',"
    
    items = items & "'movimiento': '" & Worksheets("Principal").Range(movimiento) & "' }"
    
    getBasicData = Replace(items, "'", Chr(34))
End Function
*/

/*
Function getAllCombatData() As String
    Dim items As String, blocksWeaponsBase(5) As String, blocksWeaponsRanged(3) As String
    
    blocksWeaponsBase(0) = "C27:L32"
    blocksWeaponsBase(1) = "C34:L39"
    blocksWeaponsBase(2) = "C41:L46"
    blocksWeaponsBase(3) = "N27:W32"
    blocksWeaponsBase(4) = "N34:W39"
    blocksWeaponsBase(5) = "N41:W46"
    
    blocksWeaponsRanged(0) = "C49:L55"
    blocksWeaponsRanged(1) = "C58:L64"
    blocksWeaponsRanged(2) = "N49:W55"
    blocksWeaponsRanged(3) = "N58:W64"
    
    items = "'armas': ["
        
    items = items & getUnarmedCombatData()
     
    If hasPointsOnMistic() Then
        items = items & getMagicProjectionAsWeapon()
    End If
    
    If hasPointsOnPsichiq() Then
        items = items & getPsychicProjectionAsWeapon()
    End If
        
    For Each block In blocksWeaponsBase
        items = items & getBaseCombatData(Worksheets("Combate").Range(block))
    Next
        
    For Each block In blocksWeaponsRanged
        items = items & getRangedCombatData(Worksheets("Combate").Range(block))
    Next
    
    items = items & "]"
    
    items = items & getArmourData()
    
    getAllCombatData = Replace(items, "'", Chr(34))
End Function
*/

/*
Function getArmourData() As String
    Dim items As String
    Set combatSheet = Worksheets("Combate")
    
    items = ", 'armadura': {"
    items = items & "'restriccionMov': '" & combatSheet.Range("E16").Value & "',"
    items = items & "'penNatural': '" & combatSheet.Range("H17").Value & "',"
    items = items & "'requisito': '" & combatSheet.Range("H16").Value & "',"
    items = items & "'penAccionFisica': '" & combatSheet.Range("S16").Value & "',"
    items = items & "'penNaturalFinal': '" & combatSheet.Range("S17").Value & "'"
                
    items = items & ", 'armaduraTotal': {"
    items = items & "'FIL': '" & combatSheet.Range("I16").Value & "',"
    items = items & "'CON': '" & combatSheet.Range("J16").Value & "',"
    items = items & "'PEN': '" & combatSheet.Range("K16").Value & "',"
    items = items & "'CAL': '" & combatSheet.Range("L16").Value & "',"
    items = items & "'ELE': '" & combatSheet.Range("M16").Value & "',"
    items = items & "'FRI': '" & combatSheet.Range("N16").Value & "',"
    items = items & "'ENE': '" & combatSheet.Range("O16").Value & "'}"
    
    items = items & getArmours() & "}"
    
    getArmourData = Replace(items, "'", Chr(34))

End Function
*/

  Armour getArmours(Sheet sheet) {
    const rangeStart = "O12:Q13";

    return Armour();
  }
/*
Function getArmours() As String
    Dim items As String, firstComma As String
    Dim row As Range
    
    Set rng = Worksheets("Combate").Range("C12:S15")
    
    items = ", 'armaduras': ["
          
    For Each row In rng.Rows
        
        If Not row.Range("A1").Value = "" Then
        
            items = items & firstComma & "{ 'nombre': '" & row.Range("A1").Value & "',"
            items = items & "'Localizacion': '" & row.Range("D1").Value & "',"
            items = items & "'calidad': '" & row.Range("F1").Value & "',"
            
            items = items & "'FIL': '" & row.Range("G1").Value & "',"
            items = items & "'CON': '" & row.Range("H1").Value & "',"
            items = items & "'PEN': '" & row.Range("I1").Value & "',"
            items = items & "'CAL': '" & row.Range("J1").Value & "',"
            items = items & "'ELE': '" & row.Range("K1").Value & "',"
            items = items & "'FRI': '" & row.Range("L1").Value & "',"
            items = items & "'ENE': '" & row.Range("M1").Value & "',"
            
            items = items & "'Entereza': '" & row.Range("N1").Value & "',"
            items = items & "'Presencia': '" & row.Range("O1").Value & "',"
            items = items & "'RestMov': '" & row.Range("P1").Value & "',"
            items = items & "'Enc': '" & row.Range("Q1").Value & "'}"
            
            firstComma = ", "
        
        End If
    Next

    items = items & "]"
    
    getArmours = Replace(items, "'", Chr(34))
End Function
*/

  Weapon getMagicProjectionAsWeapon(Sheet sheet) {
    const rangeStart = "O12:Q13";

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

  Weapon getPsychicProjectionAsWeapon(Sheet sheet) {
    const rangeStart = "O12:Q13";

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

  Weapon getUnarmedCombatData(Sheet sheet) {
    const rangeStart = "C20:L25";

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

  Weapon getBaseCombatData(String rangeStart, Sheet sheet) {
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

  Weapon getRangedCombatData(String rangeStart, Sheet sheet) {
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
}

extension on String {
  normalize() {
    var accChars = "ŠŽšžŸÀÁÂÃÄÅÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖÙÚÛÜÝàáâãäåçèéêëìíîïðñòóôõöùúûüýÿ";
    var regChars = "SZszYAAAAAACEEEEIIIIDNOOOOOUUUUYaaaaaaceeeeiiiidnooooouuuuyy";

    for (int i = 0; i > accChars.length; i++) {
      replaceAll(accChars[i], regChars[i]);
    }

    return this;
  }
}

extension on Sheet {
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

  List<String> valuesOn(String start, String end) {
    return selectRangeValues(
      CellIndex.indexByString(start),
      end: CellIndex.indexByString(end),
    ).map((e) => e.toString()).toList();
  }

  String valueAt(String name) {
    return cell(CellIndex.indexByString(name)).value.toString();
  }
}
