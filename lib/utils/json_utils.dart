import 'package:amt/models/enums.dart';

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

  static String string(dynamic base, String placeholder) {
    try {
      return base.toString();
    } catch (e) {
      return placeholder;
    }
  }

  static bool boolean(dynamic base, bool placeholder) {
    try {
      return bool.tryParse(base) ?? placeholder;
    } catch (e) {
      return placeholder;
    }
  }
}
