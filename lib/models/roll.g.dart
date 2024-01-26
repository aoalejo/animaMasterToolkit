// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'roll.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RollAdapter extends TypeAdapter<Roll> {
  @override
  final int typeId = 4;

  @override
  Roll read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Roll(
      description: fields[1] as String,
      roll: fields[0] as int,
      rolls: (fields[2] as List).cast<int>(),
    );
  }

  @override
  void write(BinaryWriter writer, Roll obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.roll)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.rolls);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RollAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
