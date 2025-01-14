import 'package:amt/models/character_model/status_modifier.dart';
import 'package:amt/utils/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags_x/flutter_tags_x.dart';

class ModifiersCard extends StatelessWidget {
  const ModifiersCard({
    required this.modifiers,
    super.key,
    this.onSelected,
  });
  final List<StatusModifier> modifiers;
  final void Function(StatusModifier)? onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final style = theme.textTheme.bodySmall!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      clipBehavior: Clip.antiAlias,
      color: theme.colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: IntrinsicHeight(
          child: Tags(
            spacing: 2,
            runSpacing: 4,
            alignment: WrapAlignment.start,
            runAlignment: WrapAlignment.start,
            itemCount: modifiers.length,
            itemBuilder: (int index) {
              return Tooltip(
                message: '${modifiers[index].name}:\n${modifiers[index].description(separator: "\n")}',
                child: ItemTags(
                  textStyle: style,
                  pressEnabled: false,
                  index: index,
                  removeButton: ItemTagsRemoveButton(
                    icon: Icons.delete,
                    backgroundColor: theme.colorScheme.surface,
                    color: theme.colorScheme.primary,
                    onRemoved: () {
                      onSelected?.call(modifiers[index]);
                      return true;
                    },
                  ),
                  activeColor: theme.colorScheme.primary,
                  alignment: MainAxisAlignment.spaceBetween,
                  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                  borderRadius: BorderRadius.circular(8),
                  elevation: 1,
                  title: modifiers[index].name.abbreviated,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
