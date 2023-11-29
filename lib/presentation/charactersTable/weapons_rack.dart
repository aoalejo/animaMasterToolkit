import 'package:amt/models/weapon.dart';
import 'package:amt/presentation/TextFormFieldCustom.dart';
import 'package:amt/presentation/bottom_sheet_custom.dart';
import 'package:flutter/material.dart';
import 'package:function_tree/function_tree.dart';

class WeaponsRack extends StatelessWidget {
  final Function(Weapon) onEdit;
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

    final subtitleButton = theme.textTheme.bodySmall;
    final subtitleButtonOnPrimary = theme.textTheme.bodySmall!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return GestureDetector(
      onTap: () => {
        showModalBottomSheet<void>(
          context: context,
          builder: (BuildContext context) {
            return BottomSheetCustom(
                title: Text('Selección/Edición de arma'),
                children: [
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
                                    _showWeaponEditor(context,
                                        weapon: weapon, onEdit: onEdit)
                                  },
                                  icon: Icon(Icons.edit),
                                )
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ]);
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

  void _showWeaponEditor(BuildContext context,
      {required Weapon weapon, required Function(Weapon) onEdit}) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return BottomSheetCustom(
          title: Text("Modificar ${weapon.name}"),
          children: [
            TextFormFieldCustom(
              label: "Nombre",
              text: weapon.name,
              onChanged: (value) {
                weapon.name = value;
                onEdit(weapon);
              },
            ),
            SizedBox(
              height: 16,
            ),
            TextFormFieldCustom(
              label: "Daño base",
              text: weapon.damage.toString(),
              onChanged: (value) {
                weapon.damage = _parseInput(value);
                onEdit(weapon);
              },
            ),
            SizedBox(
              height: 16,
            ),
            TextFormFieldCustom(
              label: "Defensa",
              text: weapon.defense.toString(),
              onChanged: (value) {
                weapon.defense = _parseInput(value);
                onEdit(weapon);
              },
            ),
            SizedBox(
              height: 16,
            ),
            TextFormFieldCustom(
              label: "Turno",
              text: weapon.turn.toString(),
              onChanged: (value) {
                weapon.turn = _parseInput(value);
                onEdit(weapon);
              },
            ),
          ],
        );
      },
    );
  }

  int _parseInput(String value) {
    try {
      return value.interpret().toInt();
    } catch (e) {
      return 0;
    }
  }
}
