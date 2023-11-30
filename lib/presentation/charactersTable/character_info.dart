import 'package:amt/models/character/character.dart';
import 'package:amt/models/enums.dart';
import 'package:amt/presentation/TextFormFieldCustom.dart';
import 'package:amt/presentation/text_card.dart';
import 'package:flutter/material.dart';
import 'package:function_tree/function_tree.dart';

class ShowCharacterInfo {
  static call(
    BuildContext context,
    Character character,
    Function(Character) onRemove,
  ) {
    var theme = Theme.of(context);
    var skills = character.skills.list();
    var attributes = character.attributes.toKeyValue();
    var resistances = character.resistances.toKeyValue();

    // Optional lists:

    // Mystical
    var paths = character.mystical?.paths.list();
    var subPaths = character.mystical?.subPaths.list();
    var metamagic = character.mystical?.metamagic.list();
    var spellsMaintained = character.mystical?.spellsMaintained.list();
    var spellsPurchased = character.mystical?.spellsPurchased.list(
      interchange: true,
    );

    // Ki
    var kiSkills = character.ki?.skills.list();

    // Psychic
    var disciplines = character.psychic?.disciplines.list();
    var innate = character.psychic?.innate.list();
    var patterns = character.psychic?.patterns.list();
    var powers = character.psychic?.powers.list();

    var search = "";

    return showBottomSheet(
      context: context,
      constraints: BoxConstraints.tight(Size(1200, 600)),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SizedBox(
              height: 600,
              width: 1200,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      height: 120,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(character.profile.name),
                                IconButton(
                                  onPressed: () {
                                    onRemove(character);
                                    Navigator.pop(context);
                                  },
                                  icon: Row(children: [
                                    Text(
                                      "Eliminar!",
                                      style: theme.textTheme.bodyMedium!
                                          .copyWith(color: Colors.red),
                                    ),
                                    Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    )
                                  ]),
                                ),
                                IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(Icons.close),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: TextFormFieldCustom(
                                      text: search,
                                      suffixIcon: Icon(Icons.search),
                                      onChanged: (value) => {
                                            setState(
                                              () => search = value,
                                            )
                                          }),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 480,
                      width: 1200,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Table(
                            columnWidths: const <int, TableColumnWidth>{
                              0: FractionColumnWidth(0.3),
                              1: FractionColumnWidth(0.1),
                              2: FractionColumnWidth(0.05),
                              3: FractionColumnWidth(0.05),
                              4: FractionColumnWidth(0.05),
                              5: FractionColumnWidth(0.05),
                              6: FractionColumnWidth(0.05),
                              7: FractionColumnWidth(0.05),
                              8: FractionColumnWidth(0.05),
                              9: FractionColumnWidth(0.05),
                              10: FractionColumnWidth(0.05),
                              11: FractionColumnWidth(0.05),
                            },
                            children: [
                              for (var row in _table(
                                "Atributo",
                                attributes,
                                theme,
                                search,
                                diffDivisor: 10,
                              ))
                                row,
                              for (var row in _table(
                                  "Resistencias", resistances, theme, search))
                                row,
                              for (var row
                                  in _table("Habilidad", skills, theme, search))
                                row,
                              for (var row
                                  in _table("Vias", paths, theme, search))
                                row,
                              for (var row in _table(
                                  "Sub-Vias", subPaths, theme, search))
                                row,
                              for (var row in _table(
                                  "Meta-magia", metamagic, theme, search))
                                row,
                              for (var row in _table("Hechizos mantenidos",
                                  spellsMaintained, theme, search))
                                row,
                              for (var row in _table("Hechizos comprados",
                                  spellsPurchased, theme, search))
                                row,
                              for (var row in _table(
                                  "habilidades de Ki", kiSkills, theme, search))
                                row,
                              for (var row in _table(
                                  "Disciplinas", disciplines, theme, search))
                                row,
                              for (var row
                                  in _table("Innatos", innate, theme, search))
                                row,
                              for (var row in _table(
                                  "Patrones", patterns, theme, search))
                                row,
                              for (var row
                                  in _table("Poderes", powers, theme, search))
                                row,
                            ],
                          ),
                        ),
                      ),
                    )
                  ]),
            );
          },
        );
      },
    );
  }

  static List<TableRow> _table(
    String name,
    List<KeyValue>? list,
    ThemeData theme,
    String search, {
    List<DifficultyEnum> difficulties = SecondaryDifficulties.values,
    int diffDivisor = 1,
  }) {
    var textTitle = theme.textTheme.bodyLarge!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    var textTitleSecondary = theme.textTheme.labelSmall!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    var textItem = theme.textTheme.bodyLarge!.copyWith(
      color: theme.colorScheme.primary,
    );

    var textItemSecondary = theme.textTheme.bodySmall!.copyWith(
      color: theme.colorScheme.primary,
    );

    if (list == null) return [];

    var listFiltered = search.isEmpty
        ? list
        : list.where((element) =>
            element.key.toLowerCase().contains(search.toLowerCase()));

    if (listFiltered.isEmpty) return [];

    return [
      TableRow(children: [
        TextCard(
          name,
          style: textTitle,
        ),
        TextCard(
          "Valor",
          style: textTitle,
        ),
        for (var diff in difficulties)
          TextCard(
            "${diff.abbreviated}\n(${diff.difficulty / diffDivisor})",
            maxLines: 2,
            style: textTitleSecondary,
          ),
      ]),
      for (var value in listFiltered)
        TableRow(children: [
          TextCard(
            value.key,
            background: _colorForBackground(theme, value, list),
            style: textItem,
          ),
          TextCard(
            value.value,
            background: _colorForBackground(theme, value, list),
            style: textItem,
          ),
          for (var diff in difficulties)
            TextCard(
              _differenceTo(value.value, diff.difficulty ~/ diffDivisor),
              background: _colorForBackground(theme, value, list),
              style: textItemSecondary,
            ),
        ])
    ];
  }

  static String _differenceTo(String value, int difficulty) {
    try {
      var numericValue = difficulty - value.interpret().toInt();

      if (numericValue > 0) {
        return numericValue.toString();
      } else {
        return "-";
      }
    } catch (e) {
      return "-";
    }
  }

  static Color _colorForBackground(
      ThemeData theme, KeyValue value, List<KeyValue> values) {
    return values.indexOf(value) % 2 == 0
        ? theme.colorScheme.onPrimary
        : theme.colorScheme.primaryContainer;
  }
}
