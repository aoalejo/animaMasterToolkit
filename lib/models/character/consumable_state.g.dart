// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consumable_state.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ConsumableStateAdapter extends TypeAdapter<ConsumableState> {
  @override
  final int typeId = 12;

  @override
  ConsumableState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ConsumableState(
      name: fields[0] as String,
      maxValue: fields[1] as int,
      actualValue: fields[2] as int,
      step: fields[3] as int,
      description: fields[4] as String,
      type: fields[5] as ConsumableType,
    );
  }

  @override
  void write(BinaryWriter writer, ConsumableState obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.maxValue)
      ..writeByte(2)
      ..write(obj.actualValue)
      ..writeByte(3)
      ..write(obj.step)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConsumableStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
