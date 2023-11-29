import 'package:amt/utils/assets.dart';
import 'package:flutter/material.dart';

class ActionsCard extends StatelessWidget {
  final void Function() onAttack;
  final void Function() onParry;
  final void Function() onDodge;
  final void Function() onChangeModifiers;

  ActionsCard({
    required this.onAttack,
    required this.onParry,
    required this.onDodge,
    required this.onChangeModifiers,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
              child: InkWell(onTap: onAttack, child: Assets.attack),
            ),
            Tooltip(
              message: "Cambiar modificadores",
              child: InkWell(onTap: onChangeModifiers, child: Assets.anatomy),
            ),
            Tooltip(
              message: "Parada",
              child: InkWell(onTap: onParry, child: Assets.parry),
            ),
            Tooltip(
              message: "Esquiva",
              child: InkWell(onTap: onDodge, child: Assets.dodging),
            ),
          ],
        ),
      ),
    );
  }
}