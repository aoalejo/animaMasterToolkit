import 'package:amt/models/character/character.dart';
import 'package:hive/hive.dart';

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
      uuid: fields[0],
      attributes: fields[1],
      skills: fields[2],
      profile: fields[3],
      state: fields[4],
      combat: fields[5],
      ki: fields[6],
      mystical: fields[7],
      psychic: fields[8],
    );
  }

  @override
  void write(BinaryWriter writer, Character obj) {
    writer
      ..writeString(obj.uuid)
      ..write(obj.attributes)
      ..writeMap(obj.skills)
      ..write(obj.profile)
      ..write(obj.state)
      ..write(obj.combat)
      ..write(obj.ki)
      ..write(obj.mystical)
      ..write(obj.psychic);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharacterAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
