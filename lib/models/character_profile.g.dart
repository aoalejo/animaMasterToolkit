// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character_profile.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CharacterProfileAdapter extends TypeAdapter<CharacterProfile> {
  @override
  final int typeId = 2;

  @override
  CharacterProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CharacterProfile(
      fatigue: fields[0] as int,
      hitPoints: fields[1] as int,
      regeneration: fields[2] as int,
      name: fields[3] as String,
      category: fields[4] as String,
      level: fields[5] as String,
      kind: fields[6] as String,
      speed: fields[7] as int,
      isNpc: fields[8] as bool?,
      image: fields[9] as String?,
      fumbleLevel: fields[10] as int?,
      nature: fields[11] as int?,
      uroboros: fields[12] as bool?,
      damageAccumulation: fields[13] as bool?,
      critLevel: fields[14] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, CharacterProfile obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.fatigue)
      ..writeByte(1)
      ..write(obj.hitPoints)
      ..writeByte(2)
      ..write(obj.regeneration)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.level)
      ..writeByte(6)
      ..write(obj.kind)
      ..writeByte(7)
      ..write(obj.speed)
      ..writeByte(8)
      ..write(obj.isNpc)
      ..writeByte(9)
      ..write(obj.image)
      ..writeByte(10)
      ..write(obj.fumbleLevel)
      ..writeByte(11)
      ..write(obj.nature)
      ..writeByte(12)
      ..write(obj.uroboros)
      ..writeByte(13)
      ..write(obj.damageAccumulation)
      ..writeByte(14)
      ..write(obj.critLevel);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is CharacterProfileAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
