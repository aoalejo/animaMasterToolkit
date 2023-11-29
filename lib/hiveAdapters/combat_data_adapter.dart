import 'package:amt/models/combat_data.dart';
import 'package:hive/hive.dart';

class CombatDataAdapter extends TypeAdapter<CombatData> {
  @override
  final int typeId = 5;

  @override
  CombatData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CombatData(
      weapons: fields[0],
      armour: fields[1],
    );
  }

  @override
  void write(BinaryWriter writer, CombatData obj) {
    writer
      ..write(obj.weapons)
      ..write(obj.armour);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CombatDataAdapter &&
          runtimeType == other.runtimeType &&
          hashCode == other.hashCode;
}
