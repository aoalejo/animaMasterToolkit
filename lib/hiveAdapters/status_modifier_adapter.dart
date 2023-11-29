import 'package:amt/models/character/status_modifier.dart';
import 'package:hive/hive.dart';

class StatusModifierAdapter extends TypeAdapter<StatusModifier> {
  @override
  final int typeId = 14;

  @override
  StatusModifier read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StatusModifier(
      name: fields[0],
      attack: fields[1],
      dodge: fields[2],
      parry: fields[3],
      turn: fields[4],
      physicalAction: fields[5],
    );
  }

  @override
  void write(BinaryWriter writer, StatusModifier obj) {
    writer
      ..write(obj.name)
      ..write(obj.attack)
      ..write(obj.dodge)
      ..write(obj.parry)
      ..write(obj.turn)
      ..write(obj.physicalAction);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StatusModifierAdapter &&
          runtimeType == other.runtimeType &&
          hashCode == other.hashCode;
}
