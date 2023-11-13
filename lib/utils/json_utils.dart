enum DefenceType { parry, dodge }

enum DamageTypes { fil, pen, con, fri, cal, ele, ene }

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

  static DefenceType defenseType(String? base) {
    switch (base?.toLowerCase()) {
      case "par":
        return DefenceType.parry;
      case "esq":
        return DefenceType.dodge;
    }

    return DefenceType.dodge;
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

  static int integer(String? base, int placeholder) {
    try {
      return int.parse(base ?? placeholder.toString());
    } catch (e) {
      return placeholder;
    }
  }
}
