// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character_state.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CharacterStateAdapter extends TypeAdapter<CharacterState> {
  @override
  final int typeId = 3;

  @override
  CharacterState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CharacterState(
      currentTurn: fields[4] as Roll,
      consumables: (fields[2] as List).cast<ConsumableState>(),
      modifiers: fields[7] as ModifiersState,
      selectedWeaponIndex: fields[0] as int,
      hasAction: fields[1] as bool,
      notes: fields[3] as String,
      defenseNumber: fields[6] as int,
      turnModifier: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CharacterState obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.selectedWeaponIndex)
      ..writeByte(1)
      ..write(obj.hasAction)
      ..writeByte(2)
      ..write(obj.consumables)
      ..writeByte(3)
      ..write(obj.notes)
      ..writeByte(4)
      ..write(obj.currentTurn)
      ..writeByte(5)
      ..write(obj.turnModifier)
      ..writeByte(6)
      ..write(obj.defenseNumber)
      ..writeByte(7)
      ..write(obj.modifiers);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharacterStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
