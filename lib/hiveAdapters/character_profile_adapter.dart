import 'package:amt/models/character_profile.dart';
import 'package:hive/hive.dart';

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
      fatigue: fields[0],
      hitPoints: fields[1],
      regeneration: fields[2],
      name: fields[3],
      category: fields[4],
      level: fields[5],
      kind: fields[6],
      speed: fields[7],
    );
  }

  @override
  void write(BinaryWriter writer, CharacterProfile obj) {
    writer
      ..write(obj.fatigue)
      ..write(obj.hitPoints)
      ..write(obj.regeneration)
      ..write(obj.name)
      ..write(obj.category)
      ..write(obj.level)
      ..write(obj.kind)
      ..write(obj.speed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharacterProfileAdapter &&
          runtimeType == other.runtimeType &&
          hashCode == other.hashCode;
}
