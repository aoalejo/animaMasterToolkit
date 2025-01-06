// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enums.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DefenseTypeAdapter extends TypeAdapter<DefenseType> {
  @override
  final int typeId = 15;

  @override
  DefenseType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return DefenseType.parry;
      case 1:
        return DefenseType.dodge;
      default:
        return DefenseType.parry;
    }
  }

  @override
  void write(BinaryWriter writer, DefenseType obj) {
    switch (obj) {
      case DefenseType.parry:
        writer.writeByte(0);
      case DefenseType.dodge:
        writer.writeByte(1);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is DefenseTypeAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}

class DamageTypesAdapter extends TypeAdapter<DamageTypes> {
  @override
  final int typeId = 16;

  @override
  DamageTypes read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return DamageTypes.fil;
      case 1:
        return DamageTypes.pen;
      case 2:
        return DamageTypes.con;
      case 3:
        return DamageTypes.fri;
      case 4:
        return DamageTypes.cal;
      case 5:
        return DamageTypes.ele;
      case 6:
        return DamageTypes.ene;
      default:
        return DamageTypes.fil;
    }
  }

  @override
  void write(BinaryWriter writer, DamageTypes obj) {
    switch (obj) {
      case DamageTypes.fil:
        writer.writeByte(0);
      case DamageTypes.pen:
        writer.writeByte(1);
      case DamageTypes.con:
        writer.writeByte(2);
      case DamageTypes.fri:
        writer.writeByte(3);
      case DamageTypes.cal:
        writer.writeByte(4);
      case DamageTypes.ele:
        writer.writeByte(5);
      case DamageTypes.ene:
        writer.writeByte(6);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is DamageTypesAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}

class WeaponSizeAdapter extends TypeAdapter<WeaponSize> {
  @override
  final int typeId = 17;

  @override
  WeaponSize read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return WeaponSize.normal;
      case 1:
        return WeaponSize.big;
      case 2:
        return WeaponSize.giant;
      default:
        return WeaponSize.normal;
    }
  }

  @override
  void write(BinaryWriter writer, WeaponSize obj) {
    switch (obj) {
      case WeaponSize.normal:
        writer.writeByte(0);
      case WeaponSize.big:
        writer.writeByte(1);
      case WeaponSize.giant:
        writer.writeByte(2);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is WeaponSizeAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}

class KnownTypeAdapter extends TypeAdapter<KnownType> {
  @override
  final int typeId = 18;

  @override
  KnownType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return KnownType.known;
      case 1:
        return KnownType.similar;
      case 2:
        return KnownType.unknown;
      default:
        return KnownType.known;
    }
  }

  @override
  void write(BinaryWriter writer, KnownType obj) {
    switch (obj) {
      case KnownType.known:
        writer.writeByte(0);
      case KnownType.similar:
        writer.writeByte(1);
      case KnownType.unknown:
        writer.writeByte(2);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) => identical(this, other) || other is KnownTypeAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}

class ArmourLocationAdapter extends TypeAdapter<ArmourLocation> {
  @override
  final int typeId = 19;

  @override
  ArmourLocation read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ArmourLocation.complete;
      case 1:
        return ArmourLocation.breastplate;
      case 2:
        return ArmourLocation.camisole;
      case 3:
        return ArmourLocation.head;
      default:
        return ArmourLocation.complete;
    }
  }

  @override
  void write(BinaryWriter writer, ArmourLocation obj) {
    switch (obj) {
      case ArmourLocation.complete:
        writer.writeByte(0);
      case ArmourLocation.breastplate:
        writer.writeByte(1);
      case ArmourLocation.camisole:
        writer.writeByte(2);
      case ArmourLocation.head:
        writer.writeByte(3);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ArmourLocationAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}

class ConsumableTypeAdapter extends TypeAdapter<ConsumableType> {
  @override
  final int typeId = 20;

  @override
  ConsumableType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 1:
        return ConsumableType.hitPoints;
      case 2:
        return ConsumableType.fatigue;
      case 0:
        return ConsumableType.other;
      default:
        return ConsumableType.hitPoints;
    }
  }

  @override
  void write(BinaryWriter writer, ConsumableType obj) {
    switch (obj) {
      case ConsumableType.hitPoints:
        writer.writeByte(1);
      case ConsumableType.fatigue:
        writer.writeByte(2);
      case ConsumableType.other:
        writer.writeByte(0);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ConsumableTypeAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
