// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weapon.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WeaponAdapter extends TypeAdapter<Weapon> {
  @override
  final int typeId = 6;

  @override
  Weapon read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Weapon(
      name: fields[0] as String,
      turn: fields[9] as int,
      attack: fields[10] as int,
      defense: fields[11] as int,
      defenseType: fields[12] as DefenseType,
      damage: fields[13] as int,
      type: fields[1] as String?,
      known: fields[2] as KnownType?,
      size: fields[3] as WeaponSize?,
      principalDamage: fields[4] as DamageTypes?,
      secondaryDamage: fields[5] as DamageTypes?,
      endurance: fields[6] as int?,
      breakage: fields[7] as int?,
      presence: fields[8] as int?,
      quality: fields[14] as int?,
      characteristic: fields[15] as String?,
      warning: fields[16] as String?,
      ammunition: fields[17] as String?,
      special: fields[18] as String?,
      variableDamage: fields[19] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, Weapon obj) {
    writer
      ..writeByte(20)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.known)
      ..writeByte(3)
      ..write(obj.size)
      ..writeByte(4)
      ..write(obj.principalDamage)
      ..writeByte(5)
      ..write(obj.secondaryDamage)
      ..writeByte(6)
      ..write(obj.endurance)
      ..writeByte(7)
      ..write(obj.breakage)
      ..writeByte(8)
      ..write(obj.presence)
      ..writeByte(9)
      ..write(obj.turn)
      ..writeByte(10)
      ..write(obj.attack)
      ..writeByte(11)
      ..write(obj.defense)
      ..writeByte(12)
      ..write(obj.defenseType)
      ..writeByte(13)
      ..write(obj.damage)
      ..writeByte(14)
      ..write(obj.quality)
      ..writeByte(15)
      ..write(obj.characteristic)
      ..writeByte(16)
      ..write(obj.warning)
      ..writeByte(17)
      ..write(obj.ammunition)
      ..writeByte(18)
      ..write(obj.special)
      ..writeByte(19)
      ..write(obj.variableDamage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeaponAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
