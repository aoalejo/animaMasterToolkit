import 'package:amt/models/enums.dart';
import 'package:amt/models/weapon.dart';
import 'package:hive/hive.dart';

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
      name: fields[0],
      type: fields[1],
      known: EnumConverter.from(fields[2], KnownType.values),
      size: EnumConverter.from(fields[3], WeaponSize.values),
      principalDamage: EnumConverter.from(fields[4], DamageTypes.values),
      secondaryDamage: EnumConverter.from(fields[5], DamageTypes.values),
      endurance: fields[6],
      breakage: fields[7],
      presence: fields[8],
      turn: fields[9],
      attack: fields[10],
      defense: fields[11],
      defenseType: EnumConverter.from(fields[12], DefenseType.values),
      damage: fields[13],
      quality: fields[14],
      characteristic: fields[15],
      warning: fields[16],
      ammunition: fields[17],
      special: fields[18],
    );
  }

  @override
  void write(BinaryWriter writer, Weapon obj) {
    writer
      ..write(obj.name)
      ..write(obj.type)
      ..write(obj.known?.name)
      ..write(obj.size?.name)
      ..write(obj.principalDamage)
      ..write(obj.secondaryDamage)
      ..write(obj.endurance)
      ..write(obj.breakage)
      ..write(obj.presence)
      ..write(obj.turn)
      ..write(obj.attack)
      ..write(obj.defense)
      ..write(obj.defenseType.name)
      ..write(obj.damage)
      ..write(obj.quality)
      ..write(obj.characteristic)
      ..write(obj.warning)
      ..write(obj.ammunition)
      ..write(obj.special);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeaponAdapter &&
          runtimeType == other.runtimeType &&
          hashCode == other.hashCode;
}
