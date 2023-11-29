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
        return "Parada";
      case DefenseType.dodge:
        return "Esquiva";
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

class EnumConverter {
  static T from<T extends Enum>(String name, List<T> types) {
    for (var type in types) {
      if (type.name == name) {
        return type;
      }
    }
    return types.first;
  }
}
