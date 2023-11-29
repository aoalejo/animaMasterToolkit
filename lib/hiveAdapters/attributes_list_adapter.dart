import 'package:amt/models/attributes_list.dart';
import 'package:hive/hive.dart';

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
      agility: fields[0],
      constitution: fields[1],
      dexterity: fields[2],
      strength: fields[3],
      intelligence: fields[4],
      perception: fields[5],
      might: fields[6],
      willpower: fields[7],
    );
  }

  @override
  void write(BinaryWriter writer, AttributesList obj) {
    writer
      ..write(obj.agility)
      ..write(obj.constitution)
      ..write(obj.dexterity)
      ..write(obj.strength)
      ..write(obj.intelligence)
      ..write(obj.perception)
      ..write(obj.might)
      ..write(obj.willpower);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AttributesListAdapter &&
          runtimeType == other.runtimeType &&
          hashCode == other.hashCode;
}
