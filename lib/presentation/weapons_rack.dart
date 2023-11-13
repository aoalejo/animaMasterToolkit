import 'package:amt/models/weapon.dart';
import 'package:flutter/material.dart';

class WeaponsRack extends StatelessWidget {
  final Function() onEdit;
  final Function(Weapon) onSelect;
  final List<Weapon> weapons;
  final Weapon selectedWeapon;

  WeaponsRack({
    required this.weapons,
    required this.selectedWeapon,
    required this.onEdit,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final style = theme.textTheme.bodySmall!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    final titleStyle = theme.textTheme.titleSmall;
    final subtitleButton = theme.textTheme.bodySmall;
    final subtitleButtonOnPrimary = theme.textTheme.bodySmall!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return GestureDetector(
      onTap: () => {
        showModalBottomSheet<void>(
          context: context,
          builder: (BuildContext context) {
            return Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Selección/Edición de arma', style: titleStyle),
                  Column(
                    children: [
                      for (var weapon in weapons)
                        TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor: weapon == selectedWeapon
                                  ? theme.colorScheme.primary
                                  : null,
                              foregroundColor: weapon == selectedWeapon
                                  ? theme.colorScheme.onPrimary
                                  : null),
                          onPressed: () => {
                            onSelect(weapon),
                            Navigator.pop(context),
                          },
                          child: Padding(
                            padding: EdgeInsets.all(4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(weapon.name),
                                    Text(
                                      weapon.description(),
                                      style: weapon == selectedWeapon
                                          ? subtitleButtonOnPrimary
                                          : subtitleButton,
                                    ),
                                  ],
                                ),
                                IconButton(
                                  onPressed: () => {
                                    Navigator.pop(context),
                                    showModalBottomSheet<void>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Padding(
                                              padding: EdgeInsets.all(16),
                                              child: Text("TO DO"));
                                        }),
                                  },
                                  icon: Icon(Icons.edit),
                                )
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(),
                      ElevatedButton(
                        child: const Text('Guardar'),
                        onPressed: () => Navigator.pop(context),
                      ),
                      ElevatedButton(
                        child: const Text('Cancelar'),
                        onPressed: () => Navigator.pop(context),
                      ),
                      SizedBox(),
                    ],
                  ),
                ],
              ),
            );
          },
        )
      },
      child: Tooltip(
        textAlign: TextAlign.start,
        message: selectedWeapon.description(lineBreak: true),
        child: Card(
          color: theme.colorScheme.primary,
          child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(
                    child: Text(
                      selectedWeapon.name,
                      style: style,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    Icons.info,
                    color: theme.colorScheme.onPrimary,
                    size: 18,
                  )
                ],
              )),
        ),
      ),
    );
  }
}
