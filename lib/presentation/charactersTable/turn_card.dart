import 'package:amt/models/character/character.dart';
import 'package:flutter/material.dart';

class TurnCard extends StatelessWidget {
  final Character character;
  final void Function(String) onChanged;

  TurnCard(this.character, {required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final inputStyle = InputDecoration(
      isDense: true,
      border: OutlineInputBorder(),
      contentPadding: EdgeInsets.all(8),
    );

    final style = theme.textTheme.bodySmall;

    final styleTotal = theme.textTheme.bodyLarge;

    return Tooltip(
      message: character.state.currentTurn.description,
      child: SizedBox(
        height: 100,
        child: Card(
          color: theme.colorScheme.primaryContainer,
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      "${character.selectedWeapon().turn.toString()} + ",
                      style: style,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      style: style,
                      decoration: inputStyle,
                      onChanged: onChanged,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                  ],
                ),
                Text(
                  character.state.currentTurn.roll.toString(),
                  style: styleTotal,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
