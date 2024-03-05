import 'package:hive/hive.dart';

part 'enums.g.dart';

@HiveType(typeId: 15)
enum DefenseType {
  @HiveField(0)
  parry,
  @HiveField(1)
  dodge;

  String get displayable {
    switch (this) {
      case DefenseType.parry:
        return 'Parada';
      case DefenseType.dodge:
        return 'Esquiva';
    }
  }
}

@HiveType(typeId: 16)
enum DamageTypes {
  @HiveField(0)
  fil,
  @HiveField(1)
  pen,
  @HiveField(2)
  con,
  @HiveField(3)
  fri,
  @HiveField(4)
  cal,
  @HiveField(5)
  ele,
  @HiveField(6)
  ene
}

@HiveType(typeId: 17)
enum WeaponSize {
  @HiveField(0)
  normal,
  @HiveField(1)
  big,
  @HiveField(2)
  giant
}

@HiveType(typeId: 18)
enum KnownType {
  @HiveField(0)
  known,
  @HiveField(1)
  similar,
  @HiveField(2)
  unknown
}

@HiveType(typeId: 19)
enum ArmourLocation {
  @HiveField(0)
  complete,
  @HiveField(1)
  breastplate,
  @HiveField(2)
  camisole,
  @HiveField(3)
  head
}

@HiveType(typeId: 20)
enum ConsumableType {
  @HiveField(1)
  hitPoints,
  @HiveField(2)
  fatigue,
  @HiveField(0)
  other
}

abstract class DifficultyEnum {
  int get difficulty;
  String get displayable;
  String get abbreviated;
}

enum PrimaryDifficulties implements DifficultyEnum {
  simple(6),
  normal(10),
  complex(15),
  extreme(20);

  @override
  final int difficulty;

  @override
  String get displayable {
    switch (this) {
      case PrimaryDifficulties.simple:
        return 'Simple';
      case PrimaryDifficulties.normal:
        return 'Normal';
      case PrimaryDifficulties.complex:
        return 'Complejo';
      case PrimaryDifficulties.extreme:
        return 'Extremo';
    }
  }

  @override
  String get abbreviated {
    switch (this) {
      case PrimaryDifficulties.simple:
        return 'SMP';
      case PrimaryDifficulties.normal:
        return 'NOR';
      case PrimaryDifficulties.complex:
        return 'COM';
      case PrimaryDifficulties.extreme:
        return 'EXT';
    }
  }

  const PrimaryDifficulties(this.difficulty);
}

enum SecondaryDifficulties implements DifficultyEnum {
  routine(20),
  easy(40),
  medium(80),
  hard(120),
  veryHard(140),
  absurd(180),
  almostImpossible(240),
  impossible(280),
  inhumane(320),
  zen(440);

  @override
  final int difficulty;

  @override
  String get displayable {
    switch (this) {
      case SecondaryDifficulties.routine:
        return 'Rutinario';
      case SecondaryDifficulties.easy:
        return 'Fácil';
      case SecondaryDifficulties.medium:
        return 'Media';
      case SecondaryDifficulties.hard:
        return 'Dificil';
      case SecondaryDifficulties.veryHard:
        return 'Muy Dificil';
      case SecondaryDifficulties.absurd:
        return 'Absurdo';
      case SecondaryDifficulties.almostImpossible:
        return 'Casi Imposible';
      case SecondaryDifficulties.impossible:
        return 'Imposible';
      case SecondaryDifficulties.inhumane:
        return 'Inhumano';
      case SecondaryDifficulties.zen:
        return 'Zen';
    }
  }

  @override
  String get abbreviated {
    switch (this) {
      case SecondaryDifficulties.routine:
        return 'RUT';
      case SecondaryDifficulties.easy:
        return 'FAC';
      case SecondaryDifficulties.medium:
        return 'MED';
      case SecondaryDifficulties.hard:
        return 'DIF';
      case SecondaryDifficulties.veryHard:
        return 'MDF';
      case SecondaryDifficulties.absurd:
        return 'ABS';
      case SecondaryDifficulties.almostImpossible:
        return 'CIM';
      case SecondaryDifficulties.impossible:
        return 'IMP';
      case SecondaryDifficulties.inhumane:
        return 'UNH';
      case SecondaryDifficulties.zen:
        return 'ZEN';
    }
  }

  const SecondaryDifficulties(this.difficulty);
}

class EnumConverter {
  static T from<T extends Enum>(String name, List<T> types) {
    for (final type in types) {
      if (type.name == name) {
        return type;
      }
    }
    return types.first;
  }
}
