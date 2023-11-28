import 'package:amt/models/roll.dart';
import 'package:hive/hive.dart';

class RollAdapter extends TypeAdapter<Roll> {
  @override
  final int typeId = 4;

  @override
  Roll read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Roll(
      roll: fields[0],
      description: fields[1],
      rolls: fields[2],
    );
  }

  @override
  void write(BinaryWriter writer, Roll obj) {
    writer
      ..write(obj.roll)
      ..write(obj.description)
      ..write(obj.rolls);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Roll &&
          runtimeType == other.runtimeType &&
          hashCode == other.hashCode;
}
