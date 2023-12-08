import 'package:amt/models/character/status_modifier.dart';
import 'package:amt/models/modifiers_state.dart';
import 'package:amt/presentation/TextFormFieldCustom.dart';
import 'package:amt/presentation/bottom_sheet_custom.dart';
import 'package:flutter/material.dart';
import 'package:function_tree/function_tree.dart';

class BottomSheetModifiers {
  static Future<void> show(
    BuildContext context,
    ModifiersState state,
    List<StatusModifier> allModifiersBase,
    void Function(ModifiersState) onModifiersChanged,
  ) {
    void toggleModifier(StateSetter setState, StatusModifier modifier) {
      setState(
        () => {
          if (state.containsModifier(modifier))
            {state.removeModifier(modifier)}
          else
            {state.add(modifier)},
          onModifiersChanged(state)
        },
      );
    }

    final theme = Theme.of(context);
    final subtitleButton = theme.textTheme.bodySmall;
    final allModifiers = allModifiersBase;
    // allModifiers.addAll(state.getAll());

    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return BottomSheetCustom(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'Modificadores afectando al personaje',
                        ),
                        Text(
                          state.totalModifierDescription(),
                          style: subtitleButton,
                        )
                      ],
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        var modifier = StatusModifier(name: "");
                        state.add(modifier);
                        Navigator.pop(context);

                        _showModifierCreator(
                          context,
                          modifier: modifier,
                          onEdit: (modifier) {
                            print(modifier);
                            state.removeModifier(modifier);
                            state.add(modifier);
                            onModifiersChanged(state);
                          },
                        );
                      },
                      icon: Icon(Icons.add)),
                  IconButton(
                      onPressed: () {
                        setState(() => state.clear());
                        onModifiersChanged(state);
                      },
                      icon: Icon(Icons.delete))
                ],
              ),
              children: [
                for (var modifier in allModifiers)
                  TextButton(
                    onPressed: () => {toggleModifier(setState, modifier)},
                    child: Padding(
                      padding: EdgeInsets.all(4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(modifier.name),
                              Text(
                                modifier.description(),
                                overflow: TextOverflow.ellipsis,
                                style: subtitleButton,
                              ),
                            ],
                          ),
                          Switch(
                            value: state.containsModifier(modifier),
                            onChanged: (v) {
                              toggleModifier(setState, modifier);
                            },
                          )
                        ],
                      ),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  static void _showModifierCreator(BuildContext context,
      {required StatusModifier modifier,
      required Function(StatusModifier) onEdit}) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return BottomSheetCustom(
          title: Text("Añadir modificador"),
          children: [
            TextFormFieldCustom(
              label: "Nombre",
              text: modifier.name,
              onChanged: (value) {
                modifier.name = value;
                onEdit(modifier);
              },
            ),
            SizedBox(
              height: 16,
            ),
            TextFormFieldCustom(
              label: "Ataque",
              text: modifier.attack.toString(),
              onChanged: (value) {
                modifier.attack = _parseInput(value);
                onEdit(modifier);
              },
            ),
            SizedBox(
              height: 16,
            ),
            TextFormFieldCustom(
              label: "Esquiva",
              text: modifier.dodge.toString(),
              onChanged: (value) {
                modifier.dodge = _parseInput(value);
                onEdit(modifier);
              },
            ),
            SizedBox(
              height: 16,
            ),
            TextFormFieldCustom(
              label: "Parada",
              text: modifier.parry.toString(),
              onChanged: (value) {
                modifier.parry = _parseInput(value);
                onEdit(modifier);
              },
            ),
            SizedBox(
              height: 16,
            ),
            TextFormFieldCustom(
              label: "Turno",
              text: modifier.turn.toString(),
              onChanged: (value) {
                modifier.turn = _parseInput(value);
                onEdit(modifier);
              },
            ),
            SizedBox(
              height: 16,
            ),
            TextFormFieldCustom(
              label: "Acciones",
              text: modifier.physicalAction.toString(),
              onChanged: (value) {
                modifier.physicalAction = _parseInput(value);
                onEdit(modifier);
              },
            ),
            SizedBox(
              height: 16,
            ),
          ],
        );
      },
    );
  }

  static int _parseInput(String value) {
    try {
      return value.interpret().toInt();
    } catch (e) {
      return 0;
    }
  }
}
