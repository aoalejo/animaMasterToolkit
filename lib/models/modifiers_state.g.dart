// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'modifiers_state.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ModifiersStateAdapter extends TypeAdapter<ModifiersState> {
  @override
  final int typeId = 13;

  @override
  ModifiersState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ModifiersState()
      .._modifiers = (fields[0] as List).cast<StatusModifier>();
  }

  @override
  void write(BinaryWriter writer, ModifiersState obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj._modifiers);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModifiersStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
