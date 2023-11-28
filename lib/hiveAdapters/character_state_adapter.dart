import 'package:amt/models/character/character_state.dart';
import 'package:hive/hive.dart';

class CharacterStateAdapter extends TypeAdapter<CharacterState> {
  @override
  final int typeId = 3;

  @override
  CharacterState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CharacterState(
      selectedWeaponIndex: fields[0],
      hasAction: fields[1],
      consumables: fields[2],
      notes: fields[3],
      currentTurn: fields[4],
      turnModifier: fields[5],
      defenseNumber: fields[6],
      modifiers: fields[7],
    );
  }

  @override
  void write(BinaryWriter writer, CharacterState obj) {
    writer
      ..write(obj.selectedWeaponIndex)
      ..write(obj.hasAction)
      ..write(obj.consumables)
      ..write(obj.notes)
      ..write(obj.currentTurn)
      ..write(obj.turnModifier)
      ..write(obj.defenseNumber)
      ..write(obj.modifiers);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharacterState &&
          runtimeType == other.runtimeType &&
          hashCode == other.hashCode;
}
