import 'package:amt/models/character/status_modifier.dart';
import 'package:amt/resources/modifiers.dart';
import 'package:flutter/material.dart';

class ModifiersCard extends StatelessWidget {
  final Set<StatusModifier> modifiers;
  final double aspectRatio;
  final Function(StatusModifier)? onSelected;

  ModifiersCard({
    required this.modifiers,
    this.aspectRatio = 0.4,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final style = theme.textTheme.bodySmall!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Expanded(
      flex: 1,
      child: SizedBox(
        height: 70,
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: GridView.count(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            crossAxisCount: 2,
            childAspectRatio: aspectRatio,
            children: [
              for (var modifier in modifiers)
                Tooltip(
                  message:
                      '${modifier.name}:\nAtaque: ${modifier.attack}\nEsquiva: ${modifier.dodge}\nParada: ${modifier.parry}\nTurno: ${modifier.turn}\nAccion: ${modifier.physicalAction}',
                  child: InkWell(
                    onTap: () =>
                        onSelected != null ? onSelected!(modifier) : null,
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
                ),
            ],
          ),
        ),
      ),
    );
  }
}
