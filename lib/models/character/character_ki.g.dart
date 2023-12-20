// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character_ki.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CharacterKiAdapter extends TypeAdapter<CharacterKi> {
  @override
  final int typeId = 9;

  @override
  CharacterKi read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CharacterKi(
      accumulationsPerAttribute: fields[0] as AttributesList,
      maximumPerAttribute: fields[1] as AttributesList,
      skills: (fields[2] as Map).cast<String, dynamic>(),
      maximumAccumulation: fields[3] as int,
      genericAccumulation: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, CharacterKi obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.accumulationsPerAttribute)
      ..writeByte(1)
      ..write(obj.maximumPerAttribute)
      ..writeByte(2)
      ..write(obj.skills)
      ..writeByte(3)
      ..write(obj.maximumAccumulation)
      ..writeByte(4)
      ..write(obj.genericAccumulation);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is CharacterKiAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
