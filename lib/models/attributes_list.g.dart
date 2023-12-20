// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attributes_list.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AttributesListAdapter extends TypeAdapter<AttributesList> {
  @override
  final int typeId = 1;

  @override
  AttributesList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AttributesList(
      agility: fields[0] as int,
      constitution: fields[1] as int,
      dexterity: fields[2] as int,
      strength: fields[3] as int,
      intelligence: fields[4] as int,
      perception: fields[5] as int,
      might: fields[6] as int,
      willpower: fields[7] as int,
    );
  }

  @override
  void write(BinaryWriter writer, AttributesList obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.agility)
      ..writeByte(1)
      ..write(obj.constitution)
      ..writeByte(2)
      ..write(obj.dexterity)
      ..writeByte(3)
      ..write(obj.strength)
      ..writeByte(4)
      ..write(obj.intelligence)
      ..writeByte(5)
      ..write(obj.perception)
      ..writeByte(6)
      ..write(obj.might)
      ..writeByte(7)
      ..write(obj.willpower);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AttributesListAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
