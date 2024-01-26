// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'psychic_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PsychicDataAdapter extends TypeAdapter<PsychicData> {
  @override
  final int typeId = 11;

  @override
  PsychicData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PsychicData(
      freeCvs: fields[0] as int,
      disciplines: (fields[1] as Map).cast<String, dynamic>(),
      patterns: (fields[2] as Map).cast<String, dynamic>(),
      powers: (fields[3] as Map).cast<String, dynamic>(),
      innate: (fields[4] as Map).cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, PsychicData obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.freeCvs)
      ..writeByte(1)
      ..write(obj.disciplines)
      ..writeByte(2)
      ..write(obj.patterns)
      ..writeByte(3)
      ..write(obj.powers)
      ..writeByte(4)
      ..write(obj.innate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PsychicDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
