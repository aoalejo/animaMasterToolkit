import 'dart:convert';

import 'package:amt/models/character/status_modifier.dart';
import 'package:amt/models/enums.dart';

enum ModifiersType { attack, parry, dodge, turn, action }

extension ToModifiersType on DefenseType {
  ModifiersType toModifierType() {
    switch (this) {
      case DefenseType.parry:
        return ModifiersType.parry;
      case DefenseType.dodge:
        return ModifiersType.dodge;
    }
  }
}

class Modifiers {
  static List<StatusModifier> getSituationalModifiers(ModifiersType type) {
    var modifiers = <StatusModifier>[];

    final json = jsonDecode(_valuesSituational);

    if (json != null) {
      json.forEach((v) {
        modifiers.add(StatusModifier.fromJson(v));
      });
    }

    switch (type) {
      case ModifiersType.attack:
        modifiers = modifiers.where((element) => element.attack != 0).toList();
      case ModifiersType.parry:
        modifiers = modifiers.where((element) => element.parry != 0).toList();
      case ModifiersType.dodge:
        modifiers = modifiers.where((element) => element.dodge != 0).toList();
      case ModifiersType.turn:
        modifiers = modifiers.where((element) => element.turn != 0).toList();
      case ModifiersType.action:
        modifiers = modifiers.where((element) => element.physicalAction != 0).toList();
    }

    return modifiers;
  }

  static List<StatusModifier> getStatusModifiers() {
    final modifiers = <StatusModifier>[];

    final json = jsonDecode(_values);

    if (json != null) {
      json.forEach((v) {
        modifiers.add(StatusModifier.fromJson(v));
      });
    }

    return modifiers;
  }

  static const _valuesSituational = '''
[
  { "name": "Cuello (Apuntado)", "attack":"-80" },
{ "name": "Cabeza (Apuntado)", "attack":"-60" },
{ "name": "Codo (Apuntado)", "attack":"-60" },
{ "name": "Corazón (Apuntado)", "attack":"-60" },
{ "name": "Ingle (Apuntado)", "attack":"-60" },
{ "name": "Pie (Apuntado)", "attack":"-50" },
{ "name": "Mano (Apuntado)", "attack":"-40" },
{ "name": "Rodilla (Apuntado)", "attack":"-40" },
{ "name": "Abdomen (Apuntado)", "attack":"-20" },
{ "name": "Brazo (Apuntado)", "attack":"-20" },
{ "name": "Muslo (Apuntado)", "attack":"-20" },
{ "name": "Pantorrilla (Apuntado)", "attack":"-10" },
{ "name": "Torso (Apuntado)", "attack":"-10" },
{ "name": "Ojo (Apuntado)", "attack":"-100" },
{ "name": "Muñeca (Apuntado)", "attack":"-40" },
{ "name": "Hombro (Apuntado)", "attack":"-30" },
  {
    "name": "Flanco",
    "attack": -10,
    "parry": -30,
    "dodge": -30,
    "turn": 0,
    "type": 2,
    "physicalAction": 0
  },
  {
    "name": "De espalda",
    "attack": -30,
    "parry": -80,
    "dodge": -80,
    "turn": 0,
    "type": 2,
    "physicalAction": 0
  },
  {
    "name": "Sorprendido",
    "attack": 0,
    "parry": -90,
    "dodge": -90,
    "turn": 0,
    "type": 2,
    "physicalAction": -90
  },{
    "name": "Posición superior",
    "attack": 20,
    "parry": "-",
    "dodge": 0,
    "turn": 0,
    "type": 2,
    "physicalAction": 0
  },{
    "name": "Cargando",
    "attack": 10,
    "parry": -10,
    "dodge": -20,
    "turn": 0,
    "type": 2,
    "physicalAction": 0
  },
  {
    "name": "Desenfundar",
    "attack": -25,
    "parry": -25,
    "dodge": 0,
    "turn": 0,
    "type": 2,
    "physicalAction": -25
  },{
    "name": "Adversario pequeño",
    "attack": -10,
    "parry": 0,
    "dodge": 0,
    "turn": 0,
    "type": 2,
    "physicalAction": 0
  },
  {
    "name": "Adversario diminuto",
    "attack": -20,
    "parry": -10,
    "dodge": 0,
    "turn": 0,
    "type": 2,
    "physicalAction": 0
  },
  {
    "name": "1/4 TM",
    "attack": -10,
    "parry": 0,
    "dodge": 0,
    "turn": 0,
    "type": 0,
    "physicalAction": 0
  },
  {
    "name": "TM max",
    "attack": -50,
    "parry": 0,
    "dodge": 0,
    "turn": 0,
    "type": 0,
    "physicalAction": 0
  },{
    "name": "Blanco con covertura",
    "attack": -40,
    "parry": 0,
    "dodge": 0,
    "turn": 0,
    "type": 0,
    "physicalAction": 0
  },
  {
    "name": "Cambiar de blanco",
    "attack": -10,
    "parry": 0,
    "dodge": 0,
    "turn": 0,
    "type": 0,
    "physicalAction": 0
  },
  {
    "name": "blanco con TM >8",
    "attack": -20,
    "parry": 0,
    "dodge": 0,
    "turn": 0,
    "type": 0,
    "physicalAction": 0
  },
  {
    "name": "blanco con TM =10",
    "attack": -40,
    "parry": 0,
    "dodge": 0,
    "turn": 0,
    "type": 0,
    "physicalAction": 0
  },
  {
    "name": "blanco con TM >10",
    "attack": -60,
    "parry": 0,
    "dodge": 0,
    "turn": 0,
    "type": 0,
    "physicalAction": 0
  },
  {
    "name": "def. en mismo asalto",
    "attack": -40,
    "parry": 0,
    "dodge": 0,
    "turn": 0,
    "type": 0,
    "physicalAction": 0
  },
  {
    "name": "Blanco grande",
    "attack": 30,
    "parry": 0,
    "dodge": 0,
    "turn": 0,
    "type": 0,
    "physicalAction": 0
  },
  {
    "name": "Apuntar un turno",
    "attack": 10,
    "parry": 0,
    "dodge": 0,
    "turn": 0,
    "type": 0,
    "physicalAction": 0
  },
  {
    "name": "Apuntar dos turnos",
    "attack": 20,
    "parry": 0,
    "dodge": 0,
    "turn": 0,
    "type": 0,
    "physicalAction": 0
  },
  {
    "name": "Apuntar tres turnos",
    "attack": 30,
    "parry": 0,
    "dodge": 0,
    "turn": 0,
    "type": 0,
    "physicalAction": 0
  }
]
''';

  static const _values = '''
[
{ "name": "4 puntos restantes de cansancio", "attack":"-10", "parry": -10, "dodge": -10, "turn": -10, "physicalAction": -10},
{ "name": "3 puntos restantes de cansancio", "attack":"-20", "parry": -20, "dodge": -20, "turn": -20, "physicalAction": -20},
{ "name": "2 puntos restantes de cansancio", "attack":"-40", "parry": -40, "dodge": -40, "turn": -40, "physicalAction": -40},
{ "name": "1 puntos restantes de cansancio", "attack":"-80", "parry": -80, "dodge": -80, "turn": -80, "physicalAction": -80},
{ "name": "0 puntos restantes de cansancio", "attack":"-120", "parry": -120, "dodge": -120, "turn": -120, "physicalAction": -120},
  {
    "name": "Ceguera parcial",
    "attack": -30,
    "parry": -30,
    "dodge": -15,
    "turn": 0,
    "type": 2,
    "physicalAction": -30
  },
  {
    "name": "Ceguera absoluta",
    "attack": -100,
    "parry": -80,
    "dodge": -80,
    "turn": 0,
    "type": 2,
    "physicalAction": -90
  },
  {
    "name": "Derribado",
    "attack": -30,
    "parry": -30,
    "dodge": -30,
    "turn": -10,
    "type": 2,
    "physicalAction": -30
  },
  {
    "name": "Parálisis menor",
    "attack": -20,
    "parry": -20,
    "dodge": -40,
    "turn": -20,
    "type": 2,
    "physicalAction": -40
  },
  {
    "name": "Parálisis parcial",
    "attack": -80,
    "parry": -80,
    "dodge": -80,
    "turn": -30,
    "type": 2,
    "physicalAction": -60
  },
  {
    "name": "Parálisis completa",
    "attack": -200,
    "parry": -200,
    "dodge": -200,
    "turn": -100,
    "type": 2,
    "physicalAction": -200
  },
  {
    "name": "Amenazado",
    "attack": -20,
    "parry": -120,
    "dodge": -120,
    "turn": -50,
    "type": 2,
    "physicalAction": -100
  },
  {
    "name": "Levitando",
    "attack": -20,
    "parry": -20,
    "dodge": -40,
    "turn": 0,
    "type": 2,
    "physicalAction": -60
  },
  {
    "name": "Vuelo tipo 7 a 14",
    "attack": 10,
    "parry": 10,
    "dodge": 10,
    "turn": 10,
    "type": 2,
    "physicalAction": 0
  },
  {
    "name": "Vuelo 15 o superior",
    "attack": 15,
    "parry": 10,
    "dodge": 20,
    "turn": 10,
    "type": 2,
    "physicalAction": 0
  },
 
  {
    "name": "Espacio reducido",
    "attack": -40,
    "parry": 0,
    "dodge": -40,
    "turn": 0,
    "type": 2,
    "physicalAction": -40
  },
  {
    "name": "Escasa visibilidad",
    "attack": -20,
    "parry": 0,
    "dodge": 0,
    "turn": 0,
    "type": 0,
    "physicalAction": 0
  },
  {
    "name": "Defensa total",
    "attack": -200,
    "parry": 30,
    "dodge": 30,
    "turn": 0,
    "type": 2,
    "physicalAction": 0
  }
]
''';
}
