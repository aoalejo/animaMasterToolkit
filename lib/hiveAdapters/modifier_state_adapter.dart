import 'package:amt/models/modifier_state.dart';
import 'package:hive/hive.dart';

class ModifiersStateAdapter extends TypeAdapter<ModifiersState> {
  @override
  final int typeId = 4;

  @override
  ModifiersState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    var state = ModifiersState();

    state.setAll(fields[0]);
    return state;
  }

  @override
  void write(BinaryWriter writer, ModifiersState obj) {
    writer.write(obj.getAll());
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModifiersStateAdapter &&
          runtimeType == other.runtimeType &&
          hashCode == other.hashCode;
}
