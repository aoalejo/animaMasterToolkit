import 'package:amt/models/character/status_modifier.dart';
import 'package:amt/models/modifiers_state.dart';
import 'package:amt/presentation/bottom_sheet_custom.dart';
import 'package:flutter/material.dart';

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
}
