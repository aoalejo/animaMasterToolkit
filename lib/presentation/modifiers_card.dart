import 'package:amt/models/character/status_modifier.dart';
import 'package:flutter/material.dart';

class ModifiersCard extends StatelessWidget {
  final Set<StatusModifier> modifiers;

  ModifiersCard({
    required this.modifiers,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final style = theme.textTheme.bodySmall!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Expanded(
      child: SizedBox(
        height: 70,
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: GridView.count(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            crossAxisCount: 2,
            childAspectRatio: 0.4,
            children: [
              for (var modifier in modifiers)
                Tooltip(
                  message:
                      '${modifier.name}:\nAtaque: ${modifier.attack}\nEsquiva: ${modifier.dodge}\nParada: ${modifier.parry}\nTurno: ${modifier.turn}\nAccion: ${modifier.physicalAction}',
                  child: Card(
                    color: theme.colorScheme.primary,
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                        child: Text(
                          modifier.name,
                          style: style,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
