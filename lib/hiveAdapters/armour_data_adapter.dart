import 'package:amt/models/armour_data.dart';
import 'package:hive/hive.dart';

class ArmourDataAdapter extends TypeAdapter<ArmourData> {
  @override
  final int typeId = 0;

  @override
  ArmourData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ArmourData(
      movementRestriction: fields[0],
      naturalPenalty: fields[1],
      requirement: fields[2],
      physicalPenalty: fields[3],
      finalNaturalPenalty: fields[4],
      calculatedArmour: fields[5],
      armours: fields[6],
    );
  }

  @override
  void write(BinaryWriter writer, ArmourData obj) {
    writer
      ..write(obj.movementRestriction)
      ..write(obj.naturalPenalty)
      ..write(obj.requirement)
      ..write(obj.physicalPenalty)
      ..write(obj.finalNaturalPenalty)
      ..write(obj.calculatedArmour)
      ..write(obj.armours);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArmourDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
