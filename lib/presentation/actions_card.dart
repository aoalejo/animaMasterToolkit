import 'package:amt/models/character/status_modifier.dart';
import 'package:amt/presentation/bottom_sheet_custom.dart';
import 'package:amt/resources/modifiers.dart';
import 'package:amt/utils/assets.dart';
import 'package:flutter/material.dart';

class ActionsCard extends StatelessWidget {
  final void Function() onAtack;
  final void Function() onParry;
  final void Function() onDodge;
  final void Function(Set<StatusModifier>) onChangeModifiers;
  final ValueNotifier<Set<StatusModifier>> modifiers;

  ActionsCard({
    required this.onAtack,
    required this.onParry,
    required this.onDodge,
    required this.onChangeModifiers,
    required this.modifiers,
  });

  _toggleModifier(StatusModifier selectedModifier) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (modifiers.value.contains(selectedModifier)) {
        modifiers.value.remove(selectedModifier);
        modifiers.value = modifiers.value;
        print("Removed modifier ${selectedModifier.name}");
      } else {
        modifiers.value.add(selectedModifier);
        modifiers.value = modifiers.value;

        print("added modifier ${selectedModifier.name}");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final subtitleButton = theme.textTheme.bodySmall;
    final subtitleButtonOnPrimary = theme.textTheme.bodySmall!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return SizedBox(
      height: 70,
      width: 100,
      child: Card(
        color: theme.colorScheme.primary,
        clipBehavior: Clip.hardEdge,
        child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          children: [
            Tooltip(
              message: "Atacar",
              child: InkWell(onTap: onAtack, child: Assets.attack),
            ),
            Tooltip(
              message: "Parada",
              child: InkWell(onTap: onParry, child: Assets.parry),
            ),
            Tooltip(
              message: "Esquiva",
              child: InkWell(onTap: onDodge, child: Assets.dodging),
            ),
            Tooltip(
              message: "Cambiar modificadores",
              child: InkWell(
                  onTap: () {
                    showModalBottomSheet<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return ValueListenableBuilder<Set<StatusModifier>>(
                          valueListenable: modifiers,
                          builder: (context, snapshot, child) {
                            return BottomSheetCustom(
                              text: 'Selección/Edición de arma',
                              children: [
                                for (var modifier in Modifiers.getModifiers())
                                  TextButton(
                                    style: TextButton.styleFrom(
                                        backgroundColor:
                                            snapshot.contains(modifier)
                                                ? theme.colorScheme.primary
                                                : null,
                                        foregroundColor:
                                            snapshot.contains(modifier)
                                                ? theme.colorScheme.onPrimary
                                                : null),
                                    onPressed: () =>
                                        {_toggleModifier(modifier)},
                                    child: Padding(
                                      padding: EdgeInsets.all(4),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(modifier.name),
                                              Text(
                                                modifier.description(),
                                                style: snapshot
                                                        .contains(modifier)
                                                    ? subtitleButtonOnPrimary
                                                    : subtitleButton,
                                              ),
                                            ],
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
                  },
                  child: Assets.anatomy),
            ),
          ],
        ),
      ),
    );
  }
}
