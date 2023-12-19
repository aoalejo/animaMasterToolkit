import 'package:amt/models/character/character.dart';
import 'package:amt/models/enums.dart';
import 'package:amt/presentation/text_form_field_custom.dart';
import 'package:amt/utils/Key_value.dart';
import 'package:flutter/material.dart';
import 'package:function_tree/function_tree.dart';

class ShowCharacterInfo {
  static call(BuildContext context, Character character, {required Function(Character) onRemove}) {
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

    return showModalBottomSheet(
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
                                  Navigator.pop(context);

                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text("Borrar personaje"),
                                          content: Text("Seguro que desea borrar ${character.profile.name}?"),
                                          actions: [
                                            OutlinedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                onRemove(character);
                                              },
                                              child: Text("Borrar"),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text("Cancelar"),
                                            )
                                          ],
                                        );
                                      });
                                },
                                icon: Row(children: [
                                  Text(
                                    "Eliminar!",
                                    style: theme.textTheme.bodyMedium!.copyWith(color: Colors.red),
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
                      child: Column(
                        children: [
                          for (var row in _table(
                            "Atributo",
                            attributes,
                            theme,
                            search,
                            diffDivisor: 10,
                          ))
                            row,
                          for (var row in _table("Resistencias", resistances, theme, search)) row,
                          for (var row in _table("Habilidad", skills, theme, search)) row,
                          for (var row in _table("Vias", paths, theme, search)) row,
                          for (var row in _table("Sub-Vias", subPaths, theme, search)) row,
                          for (var row in _table("Meta-magia", metamagic, theme, search)) row,
                          for (var row in _table("Hechizos mantenidos", spellsMaintained, theme, search)) row,
                          for (var row in _table("Hechizos comprados", spellsPurchased, theme, search)) row,
                          for (var row in _table("habilidades de Ki", kiSkills, theme, search)) row,
                          for (var row in _table("Disciplinas", disciplines, theme, search)) row,
                          for (var row in _table("Innatos", innate, theme, search)) row,
                          for (var row in _table("Patrones", patterns, theme, search)) row,
                          for (var row in _table("Poderes", powers, theme, search)) row,
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  static Widget _row(
    List<StringFlex> values, {
    bool title = false,
    bool odd = false,
    required ThemeData theme,
  }) {
    return Card(
      color: title
          ? theme.colorScheme.primary
          : odd
              ? theme.colorScheme.secondaryContainer
              : theme.colorScheme.background,
      child: SizedBox(
        height: 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (var value in values)
              Expanded(
                flex: value.flex,
                child: Text(
                  value.text,
                  textAlign: TextAlign.center,
                  style: value.flex == 1
                      ? theme.textTheme.bodySmall!.copyWith(color: title ? theme.colorScheme.onPrimary : theme.colorScheme.onBackground)
                      : theme.textTheme.bodyLarge!.copyWith(color: title ? theme.colorScheme.onPrimary : theme.colorScheme.onBackground),
                ),
              ),
          ],
        ),
      ),
    );
  }

  static List<Widget> _table(
    String name,
    List<KeyValue>? list,
    ThemeData theme,
    String search, {
    List<DifficultyEnum> difficulties = SecondaryDifficulties.values,
    int diffDivisor = 1,
  }) {
    if (list == null) return [];

    var listFiltered = search.isEmpty ? list : list.where((element) => element.key.toLowerCase().contains(search.toLowerCase())).toList();

    if (listFiltered.isEmpty) return [];

    return [
      _row([
        StringFlex(name, flex: 4),
        StringFlex("Valor", flex: 2),
        for (var diff in difficulties) StringFlex("${diff.abbreviated}\n(${(diff.difficulty / diffDivisor).toStringAsFixed(0)})", flex: 1)
      ], theme: theme, title: true),
      for (var i = 0; i < listFiltered.length; i++)
        _row([
          StringFlex(listFiltered[i].key, flex: 4),
          StringFlex(listFiltered[i].value, flex: 2),
          for (var diff in difficulties) StringFlex(_differenceTo(listFiltered[i].value, diff.difficulty ~/ diffDivisor), flex: 1),
        ], theme: theme, odd: i % 2 == 0)
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

  static Color _colorForBackground(ThemeData theme, KeyValue value, List<KeyValue> values) {
    return values.indexOf(value) % 2 == 0 ? theme.colorScheme.onPrimary : theme.colorScheme.primaryContainer;
  }
}

class StringFlex {
  final String text;
  final int flex;

  StringFlex(this.text, {required this.flex});
}
