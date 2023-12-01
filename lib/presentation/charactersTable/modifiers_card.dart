import 'package:amt/models/character/status_modifier.dart';
import 'package:flutter/material.dart';

class ModifiersCard extends StatelessWidget {
  final List<StatusModifier> modifiers;
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

    return SizedBox(
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
                    '${modifier.name}:\n${modifier.description(separator: "\n")}',
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
    );
  }
}
