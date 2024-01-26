// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mystical.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MysticalAdapter extends TypeAdapter<Mystical> {
  @override
  final int typeId = 10;

  @override
  Mystical read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Mystical(
      zeonRegeneration: fields[0] as int,
      act: fields[1] as int,
      zeon: fields[2] as int,
      paths: (fields[3] as Map).cast<String, String>(),
      subPaths: (fields[4] as Map).cast<String, String>(),
      metamagic: (fields[5] as Map).cast<String, String>(),
      spellsMaintained: (fields[6] as Map).cast<String, String>(),
      spellsPurchased: (fields[7] as Map).cast<String, String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Mystical obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.zeonRegeneration)
      ..writeByte(1)
      ..write(obj.act)
      ..writeByte(2)
      ..write(obj.zeon)
      ..writeByte(3)
      ..write(obj.paths)
      ..writeByte(4)
      ..write(obj.subPaths)
      ..writeByte(5)
      ..write(obj.metamagic)
      ..writeByte(6)
      ..write(obj.spellsMaintained)
      ..writeByte(7)
      ..write(obj.spellsPurchased);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MysticalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
