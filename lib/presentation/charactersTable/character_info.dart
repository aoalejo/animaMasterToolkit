import 'package:amt/models/character/character.dart';
import 'package:amt/presentation/TextFormFieldCustom.dart';
import 'package:amt/presentation/text_card.dart';
import 'package:flutter/material.dart';

class ShowCharacterInfo {
  static call(BuildContext context, Character character) {
    var theme = Theme.of(context);
    var skills = character.skills.list();
    var attributes = character.attributes.toKeyValue();

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
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SizedBox(
              height: 500,
              width: 400,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                        height: 60,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: TextFormFieldCustom(
                                    text: search,
                                    onChanged: (value) => {
                                          setState(
                                            () => search = value,
                                          )
                                        }),
                              ),
                              IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(Icons.close))
                            ],
                          ),
                        )),
                    SizedBox(
                      height: 440,
                      width: 400,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Table(
                            columnWidths: const <int, TableColumnWidth>{
                              0: FractionColumnWidth(0.7),
                              1: FractionColumnWidth(0.3),
                            },
                            children: [
                              for (var row in _table(
                                  "Atributo", attributes, theme, search))
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
    String search,
  ) {
    var textTitle = theme.textTheme.bodyLarge!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    var textItem = theme.textTheme.bodyLarge!.copyWith(
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
        ])
    ];
  }

  static Color _colorForBackground(
      ThemeData theme, KeyValue value, List<KeyValue> values) {
    return values.indexOf(value) % 2 == 0
        ? theme.colorScheme.onPrimary
        : theme.colorScheme.primaryContainer;
  }
}
