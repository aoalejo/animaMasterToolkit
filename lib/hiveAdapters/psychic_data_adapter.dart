import 'package:amt/models/psychic_data.dart';
import 'package:hive/hive.dart';

class PsychicDataAdapter extends TypeAdapter<PsychicData> {
  @override
  final int typeId = 3;

  @override
  PsychicData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PsychicData(
      freeCvs: fields[0],
      disciplines: fields[1],
      patterns: fields[2],
      powers: fields[3],
      innate: fields[4],
    );
  }

  @override
  void write(BinaryWriter writer, PsychicData obj) {
    writer
      ..write(obj.freeCvs)
      ..write(obj.disciplines)
      ..write(obj.patterns)
      ..write(obj.powers)
      ..write(obj.innate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PsychicDataAdapter &&
          runtimeType == other.runtimeType &&
          hashCode == other.hashCode;
}
