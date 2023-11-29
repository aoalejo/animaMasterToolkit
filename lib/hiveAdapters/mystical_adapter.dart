import 'package:amt/models/mystical.dart';
import 'package:hive/hive.dart';

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
      zeonRegeneration: fields[0],
      act: fields[1],
      zeon: fields[2],
      paths: fields[3],
      subPaths: fields[4],
      metamagic: fields[5],
      spellsMaintained: fields[6],
      spellsPurchased: fields[7],
    );
  }

  @override
  void write(BinaryWriter writer, Mystical obj) {
    writer
      ..write(obj.zeonRegeneration)
      ..write(obj.act)
      ..write(obj.zeon)
      ..write(obj.paths)
      ..write(obj.subPaths)
      ..write(obj.metamagic)
      ..write(obj.spellsMaintained)
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
