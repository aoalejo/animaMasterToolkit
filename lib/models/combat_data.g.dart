// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'combat_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CombatDataAdapter extends TypeAdapter<CombatData> {
  @override
  final int typeId = 5;

  @override
  CombatData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CombatData(
      armour: fields[1] as ArmourData,
      weapons: (fields[0] as List).cast<Weapon>(),
    );
  }

  @override
  void write(BinaryWriter writer, CombatData obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.weapons)
      ..writeByte(1)
      ..write(obj.armour);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CombatDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
