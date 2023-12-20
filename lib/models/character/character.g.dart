// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CharacterAdapter extends TypeAdapter<Character> {
  @override
  final int typeId = 0;

  @override
  Character read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Character(
      uuid: fields[0] as String,
      attributes: fields[1] as AttributesList,
      skills: (fields[2] as Map).cast<String, dynamic>(),
      profile: fields[3] as CharacterProfile,
      combat: fields[5] as CombatData,
      state: fields[4] as CharacterState,
      ki: fields[6] as CharacterKi?,
      mystical: fields[7] as Mystical?,
      psychic: fields[8] as PsychicData?,
      resistances: fields[9] as CharacterResistances,
    );
  }

  @override
  void write(BinaryWriter writer, Character obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.uuid)
      ..writeByte(1)
      ..write(obj.attributes)
      ..writeByte(2)
      ..write(obj.skills)
      ..writeByte(3)
      ..write(obj.profile)
      ..writeByte(4)
      ..write(obj.state)
      ..writeByte(5)
      ..write(obj.combat)
      ..writeByte(6)
      ..write(obj.ki)
      ..writeByte(7)
      ..write(obj.mystical)
      ..writeByte(8)
      ..write(obj.psychic)
      ..writeByte(9)
      ..write(obj.resistances);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CharacterAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
