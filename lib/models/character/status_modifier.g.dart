// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'status_modifier.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StatusModifierAdapter extends TypeAdapter<StatusModifier> {
  @override
  final int typeId = 14;

  @override
  StatusModifier read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StatusModifier(
      name: fields[0] as String,
      attack: fields[1] as int,
      dodge: fields[2] as int,
      parry: fields[3] as int,
      turn: fields[4] as int,
      physicalAction: fields[5] as int,
      isOfCritical: fields[6] as bool?,
      midValue: fields[7] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, StatusModifier obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.attack)
      ..writeByte(2)
      ..write(obj.dodge)
      ..writeByte(3)
      ..write(obj.parry)
      ..writeByte(4)
      ..write(obj.turn)
      ..writeByte(5)
      ..write(obj.physicalAction)
      ..writeByte(6)
      ..write(obj.isOfCritical)
      ..writeByte(7)
      ..write(obj.midValue);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is StatusModifierAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
