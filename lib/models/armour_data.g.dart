// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'armour_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ArmourDataAdapter extends TypeAdapter<ArmourData> {
  @override
  final int typeId = 7;

  @override
  ArmourData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ArmourData(
      movementRestriction: fields[0] as int?,
      naturalPenalty: fields[1] as int?,
      requirement: fields[2] as int?,
      physicalPenalty: fields[3] as int?,
      finalNaturalPenalty: fields[4] as int?,
      calculatedArmour: fields[5] as Armour,
      armours: (fields[6] as List).cast<Armour>(),
    );
  }

  @override
  void write(BinaryWriter writer, ArmourData obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.movementRestriction)
      ..writeByte(1)
      ..write(obj.naturalPenalty)
      ..writeByte(2)
      ..write(obj.requirement)
      ..writeByte(3)
      ..write(obj.physicalPenalty)
      ..writeByte(4)
      ..write(obj.finalNaturalPenalty)
      ..writeByte(5)
      ..write(obj.calculatedArmour)
      ..writeByte(6)
      ..write(obj.armours);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ArmourDataAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
