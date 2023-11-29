import 'package:amt/models/character/character_ki.dart';
import 'package:hive/hive.dart';

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
      accumulationsPerAttribute: fields[0],
      maximumPerAttribute: fields[1],
      skills: fields[2],
      maximumAccumulation: fields[3],
      genericAccumulation: fields[4],
    );
  }

  @override
  void write(BinaryWriter writer, CharacterKi obj) {
    writer
      ..write(obj.accumulationsPerAttribute)
      ..write(obj.maximumPerAttribute)
      ..write(obj.skills)
      ..write(obj.maximumAccumulation)
      ..write(obj.genericAccumulation);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharacterKiAdapter &&
          runtimeType == other.runtimeType &&
          hashCode == other.hashCode;
}
