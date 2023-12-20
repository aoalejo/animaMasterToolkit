// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'armour.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

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
      name: fields[0] as String?,
      location: fields[1] as ArmourLocation?,
      quality: fields[2] as int?,
      fil: fields[3] as int,
      con: fields[4] as int,
      pen: fields[5] as int,
      cal: fields[6] as int,
      ele: fields[7] as int,
      fri: fields[8] as int,
      ene: fields[9] as int,
      endurance: fields[10] as int?,
      presence: fields[11] as int?,
      movementRestriction: fields[12] as int?,
      enchanted: fields[13] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, Armour obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.location)
      ..writeByte(2)
      ..write(obj.quality)
      ..writeByte(3)
      ..write(obj.fil)
      ..writeByte(4)
      ..write(obj.con)
      ..writeByte(5)
      ..write(obj.pen)
      ..writeByte(6)
      ..write(obj.cal)
      ..writeByte(7)
      ..write(obj.ele)
      ..writeByte(8)
      ..write(obj.fri)
      ..writeByte(9)
      ..write(obj.ene)
      ..writeByte(10)
      ..write(obj.endurance)
      ..writeByte(11)
      ..write(obj.presence)
      ..writeByte(12)
      ..write(obj.movementRestriction)
      ..writeByte(13)
      ..write(obj.enchanted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ArmourAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
