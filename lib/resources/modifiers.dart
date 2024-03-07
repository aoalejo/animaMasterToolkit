import 'package:amt/models/character_model/status_modifier.dart';
import 'package:amt/models/enums.dart';
import 'package:amt/utils/list_extension.dart';
import 'package:amt/utils/string_extension.dart';

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

    for (final element in _valuesSituational.jsonList) {
      modifiers.tryAdd(StatusModifier.fromJson(element));
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

    return modifiers.map((e) => e.pruneOthers(type)).toList()..sort((left, right) => left.name.compareTo(right.name));
  }

  static List<StatusModifier> getStatusModifiers() {
    final modifiers = <StatusModifier>[];

    for (final element in _values.jsonList) {
      modifiers.tryAdd(StatusModifier.fromJson(element));
    }

    modifiers.sort((left, right) => left.name.compareTo(right.name));

    return modifiers;
  }

  static const _valuesSituational = '''
[
    {
        "name": "Apuntado: Cuello",
        "attack": "-80"
    },
    {
        "name": "Apuntado: Cabeza",
        "attack": "-60"
    },
    {
        "name": "Apuntado: Codo",
        "attack": "-60"
    },
    {
        "name": "Apuntado: Corazón",
        "attack": "-60"
    },
    {
        "name": "Apuntado: Ingle",
        "attack": "-60"
    },
    {
        "name": "Apuntado: Pie",
        "attack": "-50"
    },
    {
        "name": "Apuntado: Mano",
        "attack": "-40"
    },
    {
        "name": "Apuntado: Rodilla",
        "attack": "-40"
    },
    {
        "name": "Apuntado: Abdomen",
        "attack": "-20"
    },
    {
        "name": "Apuntado: Brazo",
        "attack": "-20"
    },
    {
        "name": "Apuntado: Muslo",
        "attack": "-20"
    },
    {
        "name": "Apuntado: Pantorrilla",
        "attack": "-10"
    },
    {
        "name": "Apuntado: Torso",
        "attack": "-10"
    },
    {
        "name": "Apuntado: Ojo",
        "attack": "-100"
    },
    {
        "name": "Apuntado: Muñeca",
        "attack": "-40"
    },
    {
        "name": "Apuntado: Hombro",
        "attack": "-30"
    },
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
    },
    {
        "name": "Posición superior",
        "attack": 20,
        "parry": "-",
        "dodge": 0,
        "turn": 0,
        "type": 2,
        "physicalAction": 0
    },
    {
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
    },
    {
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
        "name": "A la defensiva",
        "attack": -30,
        "parry": 10,
        "dodge": 10,
        "turn": 0,
        "type": 2,
        "physicalAction": 0
    },
    {
        "name": "A la ofensiva",
        "attack": 10,
        "parry": -30,
        "dodge": -30,
        "turn": 0,
        "type": 2,
        "physicalAction": 0
    },
    {
        "name": "Proyectil Lanzado",
        "attack": 0,
        "parry": -50,
        "dodge": 0,
        "turn": 0,
        "type": 2,
        "physicalAction": 0
    },
    {
        "name": "Proyectil Disparado",
        "attack": 0,
        "parry": -80,
        "dodge": -30,
        "turn": 0,
        "type": 2,
        "physicalAction": 0
    },
    {
        "name": "Proyectil Disparado (maestria en defensa)",
        "attack": 0,
        "parry": -20,
        "dodge": 0,
        "turn": 0,
        "type": 2,
        "physicalAction": 0
    },
    {
        "name": "Proyectil Disparado (escudo)",
        "attack": 0,
        "parry": -30,
        "dodge": 0,
        "turn": 0,
        "type": 2,
        "physicalAction": 0
    },
    {
        "name": "Seraphite arcano",
        "attack": 0,
        "parry": -50,
        "dodge": -50,
        "turn": 0,
        "type": 2,
        "physicalAction": 0
    },
    {
        "name": "Seraphite base",
        "attack": 0,
        "parry": -30,
        "dodge": -30,
        "turn": 0,
        "type": 2,
        "physicalAction": 0
    },
    {
        "name": "Shephon base",
        "attack": 0,
        "parry": 60,
        "dodge": 60,
        "turn": 0,
        "type": 2,
        "physicalAction": 0
    },
    {
        "name": "Shephon arcano",
        "attack": 0,
        "parry": 100,
        "dodge": 100,
        "turn": 0,
        "type": 2,
        "physicalAction": 0
    },
    {
        "name": "Presa",
        "attack": -40,
        "parry": 0,
        "dodge": 0,
        "turn": 0,
        "type": 2,
        "physicalAction": 0
    },
    {
        "name": "Proyectil: Bocajarro",
        "attack": 30,
        "parry": 0,
        "dodge": 0,
        "turn": 0,
        "type": 2,
        "physicalAction": 0
    },
    {
        "name": "Proyectil: Apuntar por 1 turno",
        "attack": 10,
        "parry": 0,
        "dodge": 0,
        "turn": 0,
        "type": 2,
        "physicalAction": 0
    },
    {
        "name": "Proyectil: Apuntar por 2 turno",
        "attack": 20,
        "parry": 0,
        "dodge": 0,
        "turn": 0,
        "type": 2,
        "physicalAction": 0
    },
    {
        "name": "Proyectil: Apuntar por 3 turno",
        "attack": 30,
        "parry": 0,
        "dodge": 0,
        "turn": 0,
        "type": 2,
        "physicalAction": 0
    },
    {
        "name": "Proyectil: Blanco grande",
        "attack": 30,
        "parry": 0,
        "dodge": 0,
        "turn": 0,
        "type": 2,
        "physicalAction": 0
    },
    {
        "name": "Proyectil: Cambiar blanco",
        "attack": -10,
        "parry": 0,
        "dodge": 0,
        "turn": 0,
        "type": 2,
        "physicalAction": 0
    },
    {
        "name": "Proyectil: Defendió en este asalto",
        "attack": -40,
        "parry": 0,
        "dodge": 0,
        "turn": 0,
        "type": 2,
        "physicalAction": 0
    },
    {
        "name": "Proyectil: Se desplazó más de 1 / 4 del movimiento",
        "attack": -10,
        "parry": 0,
        "dodge": 0,
        "turn": 0,
        "type": 2,
        "physicalAction": 0
    },
    {
        "name": "Proyectil: El blanco se mueve a Vel. 10",
        "attack": -40,
        "parry": 0,
        "dodge": 0,
        "turn": 0,
        "type": 2,
        "physicalAction": 0
    },
    {
        "name": "Proyectil: El blanco se mueve a más de Vel. +10",
        "attack": -60,
        "parry": 0,
        "dodge": 0,
        "turn": 0,
        "type": 2,
        "physicalAction": 0
    },
    {
        "name": "Proyectil: El blanco se mueve a más de Vel. 8",
        "attack": -20,
        "parry": 0,
        "dodge": 0,
        "turn": 0,
        "type": 2,
        "physicalAction": 0
    },
    {
        "name": "Proyectil: El blanco tiene cobertura",
        "attack": -40,
        "parry": 0,
        "dodge": 0,
        "turn": 0,
        "type": 2,
        "physicalAction": 0
    },
    {
        "name": "Proyectil: Escasa visibilidad",
        "attack": -20,
        "parry": 0,
        "dodge": 0,
        "turn": 0,
        "type": 2,
        "physicalAction": 0
    },
    {
        "name": "Proyectil: Moviendose al máximo de velocidad",
        "attack": -50,
        "parry": 0,
        "dodge": 0,
        "turn": 0,
        "type": 2,
        "physicalAction": 0
    },
    {
        "name": "Proyectil: Atacar por encima del alcance efectivo del arma",
        "attack": -30,
        "parry": 0,
        "dodge": 0,
        "turn": 0,
        "type": 2,
        "physicalAction": 0
    }
]
''';

  static const _values = '''
[
    {
        "name": "4 puntos restantes de cansancio",
        "attack": "-10",
        "parry": -10,
        "dodge": -10,
        "turn": -10,
        "physicalAction": -10
    },
    {
        "name": "3 puntos restantes de cansancio",
        "attack": "-20",
        "parry": -20,
        "dodge": -20,
        "turn": -20,
        "physicalAction": -20
    },
    {
        "name": "2 puntos restantes de cansancio",
        "attack": "-40",
        "parry": -40,
        "dodge": -40,
        "turn": -40,
        "physicalAction": -40
    },
    {
        "name": "1 puntos restantes de cansancio",
        "attack": "-80",
        "parry": -80,
        "dodge": -80,
        "turn": -80,
        "physicalAction": -80
    },
    {
        "name": "0 puntos restantes de cansancio",
        "attack": "-120",
        "parry": -120,
        "dodge": -120,
        "turn": -120,
        "physicalAction": -120
    },
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
    },
    {
        "name": "Ataque total",
        "attack": 30,
        "parry": -200,
        "dodge": -200,
        "turn": 0,
        "type": 2,
        "physicalAction": 0
    },
    {
        "name": "Arma distinta / Desarmado",
        "attack": -60,
        "parry": 0,
        "dodge": 0,
        "turn": 0,
        "type": 2,
        "physicalAction": 0
    },
    {
        "name": "Arma mixta",
        "attack": -40,
        "parry": 0,
        "dodge": 0,
        "turn": 0,
        "type": 2,
        "physicalAction": 0
    },
    {
        "name": "Arma similar",
        "attack": -20,
        "parry": 0,
        "dodge": 0,
        "turn": 0,
        "type": 2,
        "physicalAction": 0
    },
    {
        "name": "Arma similar",
        "attack": -20,
        "parry": 0,
        "dodge": 0,
        "turn": 0,
        "type": 2,
        "physicalAction": 0
    },
    {
        "name": "Desarmar",
        "attack": -20,
        "parry": 0,
        "dodge": 0,
        "turn": 0,
        "type": 2,
        "physicalAction": 0
    },
    {
        "name": "Dolor",
        "attack": -40,
        "parry": -40,
        "dodge": -40,
        "turn": 0,
        "type": 2,
        "physicalAction": 0
    },
    {
        "name": "Dolor extremo",
        "attack": -60,
        "parry": -80,
        "dodge": -80,
        "turn": 0,
        "type": 2,
        "physicalAction": 0
    },
    {
        "name": "Miedo",
        "attack": -60,
        "parry": -60,
        "dodge": -60,
        "turn": 0,
        "type": 2,
        "physicalAction": -60
    }
]
''';
}
