enum DefenseType { parry, dodge }

enum DamageTypes { fil, pen, con, fri, cal, ele, ene }

enum WeaponSize { normal, big, giant }

enum KnownType { known, similar, unknown }

enum ArmourLocation { complete, breastplate, camisole, head }

enum ConsumableType { hitPoints, fatigue, other }

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
