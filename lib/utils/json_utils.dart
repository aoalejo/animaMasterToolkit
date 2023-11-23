enum DefenseType { parry, dodge }

extension DefenseTypeDesc on DefenseType {
  String name() {
    switch (this) {
      case DefenseType.parry:
        return "Parada";
      case DefenseType.dodge:
        return "Esquiva";
    }
  }
}

enum DamageTypes { fil, pen, con, fri, cal, ele, ene }

extension DamageTypesDesc on DamageTypes {
  String name() {
    switch (this) {
      case DamageTypes.fil:
        return "Fil";
      case DamageTypes.pen:
        return "Pen";
      case DamageTypes.con:
        return "Con";
      case DamageTypes.fri:
        return "Fri";
      case DamageTypes.cal:
        return "Cal";
      case DamageTypes.ele:
        return "Ele";
      case DamageTypes.ene:
        return "Ene";
    }
  }
}

enum WeaponSize { normal, big, giant }

enum KnownType { known, similar, unknown }

enum ArmourLocation { complete, breastplate, camisole, head }

class JsonUtils {
  static ArmourLocation armourLocation(String? base) {
    switch (base?.toUpperCase()) {
      case "completa":
        return ArmourLocation.complete;
      case "peto":
        return ArmourLocation.breastplate;
      case "camisola":
        return ArmourLocation.camisole;
      case "cabeza":
        return ArmourLocation.head;
    }
    return ArmourLocation.complete;
  }

  static DamageTypes damage(String? base) {
    switch (base?.toUpperCase()) {
      case "FIL":
        return DamageTypes.fil;
      case "PEN":
        return DamageTypes.pen;
      case "CON":
        return DamageTypes.con;
      case "FRI":
        return DamageTypes.fri;
      case "CAL":
        return DamageTypes.cal;
      case "ELE":
        return DamageTypes.ele;
      case "ENE":
        return DamageTypes.ene;
    }

    return DamageTypes.fil;
  }

  static WeaponSize weaponSize(String? base) {
    switch (base?.toLowerCase()) {
      case "normal":
        return WeaponSize.normal;
      case "enorme":
        return WeaponSize.big;
      case "gigante":
        return WeaponSize.giant;
    }

    return WeaponSize.normal;
  }

  static DefenseType defenseType(String? base) {
    switch (base?.toLowerCase()) {
      case "par":
        return DefenseType.parry;
      case "esq":
        return DefenseType.dodge;
    }

    return DefenseType.dodge;
  }

  static KnownType knownType(String? base) {
    switch (base?.toLowerCase()) {
      case "conocida":
        return KnownType.known;
      case "similar":
        return KnownType.similar;
      case "distinta":
        return KnownType.unknown;
    }

    return KnownType.known;
  }

  static int integer(dynamic base, int placeholder) {
    try {
      return int.parse(base.toString());
    } catch (e) {
      return placeholder;
    }
  }
}
