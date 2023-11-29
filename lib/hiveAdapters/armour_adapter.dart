import 'package:amt/models/armour.dart';
import 'package:amt/models/enums.dart';
import 'package:hive/hive.dart';

class ArmourAdapter extends TypeAdapter<Armour> {
  @override
  final int typeId = 8;

  @override
  Armour read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Armour(
      name: fields[0],
      location: EnumConverter.from(fields[1], ArmourLocation.values),
      quality: fields[2],
      fil: fields[3] as int,
      con: fields[4],
      pen: fields[5],
      cal: fields[6],
      ele: fields[7],
      fri: fields[8],
      ene: fields[9],
      endurance: fields[10],
      presence: fields[11],
      movementRestriction: fields[12],
      enchanted: fields[13],
    );
  }

  @override
  void write(BinaryWriter writer, Armour obj) {
    writer
      ..writeString(obj.name ?? '')
      ..writeString(obj.location?.name ?? '')
      ..writeInt(obj.quality ?? 0)
      ..writeInt(obj.fil)
      ..writeInt(obj.con)
      ..writeInt(obj.pen)
      ..writeInt(obj.cal)
      ..writeInt(obj.ele)
      ..writeInt(obj.fri)
      ..writeInt(obj.ene)
      ..writeInt(obj.endurance ?? 0)
      ..writeInt(obj.presence ?? 0)
      ..writeInt(obj.movementRestriction ?? 0)
      ..writeBool(obj.enchanted ?? false);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArmourAdapter &&
          runtimeType == other.runtimeType &&
          hashCode == other.hashCode;
}
