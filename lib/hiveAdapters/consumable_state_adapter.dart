import 'package:amt/models/character/consumable_state.dart';
import 'package:amt/models/enums.dart';
import 'package:hive/hive.dart';

class ConsumableStateAdapter extends TypeAdapter<ConsumableState> {
  @override
  final int typeId = 12;

  @override
  ConsumableState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ConsumableState(
      name: fields[0],
      maxValue: fields[1],
      actualValue: fields[2],
      step: fields[3],
      description: fields[4],
      type: EnumConverter.from(fields[5], ConsumableType.values),
    );
  }

  @override
  void write(BinaryWriter writer, ConsumableState obj) {
    writer
      ..write(obj.name)
      ..write(obj.maxValue)
      ..write(obj.actualValue)
      ..write(obj.step)
      ..write(obj.description)
      ..write(obj.type.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConsumableStateAdapter &&
          runtimeType == other.runtimeType &&
          hashCode == other.hashCode;
}
