// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character_resistances.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CharacterResistancesAdapter extends TypeAdapter<CharacterResistances> {
  @override
  final int typeId = 21;

  @override
  CharacterResistances read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CharacterResistances(
      presence: fields[0] as int,
      physicalResistance: fields[1] as int,
      diseasesResistance: fields[2] as int,
      poisonResistance: fields[3] as int,
      magicalResistance: fields[4] as int,
      physicResistance: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, CharacterResistances obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.presence)
      ..writeByte(1)
      ..write(obj.physicalResistance)
      ..writeByte(2)
      ..write(obj.diseasesResistance)
      ..writeByte(3)
      ..write(obj.poisonResistance)
      ..writeByte(4)
      ..write(obj.magicalResistance)
      ..writeByte(5)
      ..write(obj.physicResistance);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharacterResistancesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
