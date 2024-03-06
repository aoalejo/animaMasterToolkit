import 'package:amt/models/character/status_modifier.dart';
import 'package:amt/models/modifiers_state.dart';
import 'package:amt/presentation/components/components.dart';
import 'package:flutter/material.dart';
import 'package:function_tree/function_tree.dart';
import 'package:logger/web.dart';

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
          if (state.containsModifier(modifier)) {state.removeModifier(modifier)} else {state.add(modifier)},
          onModifiersChanged(state),
        },
      );
    }

    final theme = Theme.of(context);
    final subtitleButton = theme.textTheme.bodySmall;
    final allModifiers = allModifiersBase;

    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AMTBottomSheet(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        const Text(
                          'Modificadores afectando al personaje',
                        ),
                        Text(
                          state.totalModifierDescription(),
                          style: subtitleButton,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      final modifier = StatusModifier(name: '');
                      state.add(modifier);
                      Navigator.pop(context);

                      _showModifierCreator(
                        context,
                        modifier: modifier,
                        onEdit: (modifier) {
                          Logger().d(modifier);
                          state.removeModifier(modifier);
                          state.add(modifier);
                          onModifiersChanged(state);
                        },
                      );
                    },
                    icon: const Icon(Icons.add),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() => state.clear());
                      onModifiersChanged(state);
                    },
                    icon: const Icon(Icons.delete),
                  ),
                ],
              ),
              children: [
                for (final modifier in allModifiers)
                  TextButton(
                    onPressed: () => {toggleModifier(setState, modifier)},
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
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
                          ),
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

  static void _showModifierCreator(BuildContext context, {required StatusModifier modifier, required Function(StatusModifier) onEdit}) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return AMTBottomSheet(
          title: const Text('Añadir modificador'),
          children: [
            AMTTextFormField(
              label: 'Nombre',
              text: modifier.name,
              onChanged: (value) {
                modifier.name = value;
                onEdit(modifier);
              },
            ),
            const SizedBox(
              height: 16,
            ),
            AMTTextFormField(
              label: 'Ataque',
              text: modifier.attack.toString(),
              onChanged: (value) {
                modifier.attack = _parseInput(value);
                onEdit(modifier);
              },
            ),
            const SizedBox(
              height: 16,
            ),
            AMTTextFormField(
              label: 'Esquiva',
              text: modifier.dodge.toString(),
              onChanged: (value) {
                modifier.dodge = _parseInput(value);
                onEdit(modifier);
              },
            ),
            const SizedBox(
              height: 16,
            ),
            AMTTextFormField(
              label: 'Parada',
              text: modifier.parry.toString(),
              onChanged: (value) {
                modifier.parry = _parseInput(value);
                onEdit(modifier);
              },
            ),
            const SizedBox(
              height: 16,
            ),
            AMTTextFormField(
              label: 'Turno',
              text: modifier.turn.toString(),
              onChanged: (value) {
                modifier.turn = _parseInput(value);
                onEdit(modifier);
              },
            ),
            const SizedBox(
              height: 16,
            ),
            AMTTextFormField(
              label: 'Acciones',
              text: modifier.physicalAction.toString(),
              onChanged: (value) {
                modifier.physicalAction = _parseInput(value);
                onEdit(modifier);
              },
            ),
            const SizedBox(
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
