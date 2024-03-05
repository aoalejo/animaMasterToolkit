import 'dart:convert';

import 'package:amt/models/armour.dart';

class Armours {
  static List<Armour> getPresetArmours() {
    final modifiers = <Armour>[];

    final json = jsonDecode(_presets);

    if (json != null) {
      json.forEach((v) {
        modifiers.add(Armour.fromJson(v));
      });
    }

    return modifiers;
  }

  static const _presets = '''
[
  {
   "nombre": "Sin armadura",
   "FIL": 0,
   "CON": 0,
   "PEN": 0,
   "CAL": 0,
   "ELE": 0,
   "FRI": 0,
   "ENE": 0
 },
 {
   "nombre": "Acolchada",
   "FIL": 1,
   "CON": 1,
   "PEN": 1,
   "CAL": 1,
   "ELE": 2,
   "FRI": 2,
   "ENE": 0
 },
 {
   "nombre": "Cuero",
   "FIL": 1,
   "CON": 0,
   "PEN": 2,
   "CAL": 1,
   "ELE": 2,
   "FRI": 1,
   "ENE": 0
 },
 {
   "nombre": "Gabardina armada",
   "FIL": 1,
   "CON": 0,
   "PEN": 2,
   "CAL": 1,
   "ELE": 2,
   "FRI": 2,
   "ENE": 0
 },
 {
   "nombre": "Piel",
   "FIL": 2,
   "CON": 1,
   "PEN": 2,
   "CAL": 1,
   "ELE": 2,
   "FRI": 2,
   "ENE": 0
 },
 {
   "nombre": "Completa de cuero",
   "FIL": 1,
   "CON": 0,
   "PEN": 2,
   "CAL": 1,
   "ELE": 2,
   "FRI": 1,
   "ENE": 0
 },
 {
   "nombre": "Cuero endurecido",
   "FIL": 2,
   "CON": 2,
   "PEN": 2,
   "CAL": 2,
   "ELE": 2,
   "FRI": 2,
   "ENE": 0
 },
 {
   "nombre": "Cuero tachonado",
   "FIL": 3,
   "CON": 1,
   "PEN": 2,
   "CAL": 2,
   "ELE": 1,
   "FRI": 2,
   "ENE": 0
 },
 {
   "nombre": "Mallas",
   "FIL": 4,
   "CON": 2,
   "PEN": 1,
   "CAL": 2,
   "ELE": 0,
   "FRI": 1,
   "ENE": 0
 },
 {
   "nombre": "Peto",
   "FIL": 4,
   "CON": 5,
   "PEN": 4,
   "CAL": 1,
   "ELE": 0,
   "FRI": 1,
   "ENE": 0
 },
 {
   "nombre": "Piezas",
   "FIL": 4,
   "CON": 3,
   "PEN": 2,
   "CAL": 3,
   "ELE": 2,
   "FRI": 2,
   "ENE": 0
 },
 {
   "nombre": "Anillas",
   "FIL": 4,
   "CON": 3,
   "PEN": 1,
   "CAL": 2,
   "ELE": 0,
   "FRI": 1,
   "ENE": 0
 },
 {
   "nombre": "Semicompleta",
   "FIL": 4,
   "CON": 4,
   "PEN": 4,
   "CAL": 2,
   "ELE": 0,
   "FRI": 1,
   "ENE": 1
 },
 {
   "nombre": "Escamas",
   "FIL": 4,
   "CON": 4,
   "PEN": 4,
   "CAL": 3,
   "ELE": 0,
   "FRI": 3,
   "ENE": 1
 },
 {
   "nombre": "Placas",
   "FIL": 5,
   "CON": 4,
   "PEN": 5,
   "CAL": 3,
   "ELE": 0,
   "FRI": 3,
   "ENE": 1
 },
 {
   "nombre": "Completa",
   "FIL": 5,
   "CON": 5,
   "PEN": 5,
   "CAL": 4,
   "ELE": 0,
   "FRI": 4,
   "ENE": 2
 },
 {
   "nombre": "Completa pesada",
   "FIL": 6,
   "CON": 6,
   "PEN": 6,
   "CAL": 4,
   "ELE": 0,
   "FRI": 4,
   "ENE": 2
 },
 {
   "nombre": "De campaña pesada",
   "FIL": 7,
   "CON": 7,
   "PEN": 7,
   "CAL": 4,
   "ELE": 0,
   "FRI": 4,
   "ENE": 2
 }
]
''';
}
