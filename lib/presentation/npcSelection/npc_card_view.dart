import 'dart:convert';

import 'package:amt/models/character/character.dart';
import 'package:amt/models/character_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags_x/flutter_tags_x.dart';

class CharacterNPCCard extends StatelessWidget {
  final Character character;
  final ThemeData theme;
  final Function(Character) onSelected;
  final Function(Character) onRemove;

  late final List<KeyValue> _skills;
  late final CharacterProfile _profile;
  late final List<KeyValue> _combat;
  late final List<KeyValue> _attributes;
  late final List<KeyValue> _resistances;

  CharacterNPCCard(
    this.character,
    this.theme, {
    required this.onSelected,
    required this.onRemove,
  }) {
    _skills = character.skills.list();
    _profile = character.profile;
    _combat = character.getCombatItems();
    _attributes = character.attributes.toKeyValue(abbreviated: true);
    _resistances = character.resistances.toKeyValue();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => onSelected(character),
                  icon: Icon(
                    Icons.add,
                  ),
                ),
                Expanded(
                    child: Text(
                  _profile.name,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )),
                IconButton(
                  onPressed: () => onRemove(character),
                  icon: Icon(
                    Icons.delete,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  height: 128,
                  width: 128,
                  child: Stack(
                    children: [
                      Card(
                        clipBehavior: Clip.hardEdge,
                        child: Image.memory(base64Decode(_profile.image ?? "")),
                      ),
                      Column(
                        children: [
                          Expanded(child: Container()),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _pill('Lv. ${_profile.level}'),
                                _pill(_profile.category),
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Tags(
                      spacing: 4,
                      runAlignment: WrapAlignment.start,
                      alignment: WrapAlignment.start,
                      itemCount: _combat.length,
                      itemBuilder: (int index) {
                        return ItemTags(
                          textStyle: theme.textTheme.bodySmall!,
                          pressEnabled: false,
                          index: index,
                          alignment: MainAxisAlignment.spaceBetween,
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 3),
                          borderRadius: BorderRadius.circular(8),
                          elevation: 1,
                          title:
                              "${_combat[index].key}: ${_combat[index].value}",
                        );
                      },
                    ),
                    Tags(
                      spacing: 4,
                      runAlignment: WrapAlignment.start,
                      alignment: WrapAlignment.start,
                      itemCount: _attributes.length,
                      itemBuilder: (int index) {
                        return ItemTags(
                          textStyle: theme.textTheme.bodySmall!,
                          pressEnabled: false,
                          index: index,
                          alignment: MainAxisAlignment.spaceBetween,
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 3),
                          borderRadius: BorderRadius.circular(8),
                          elevation: 1,
                          title:
                              "${_attributes[index].key}: ${_attributes[index].value}",
                        );
                      },
                    ),
                    Tags(
                      spacing: 4,
                      runAlignment: WrapAlignment.start,
                      alignment: WrapAlignment.start,
                      itemCount: _resistances.length,
                      itemBuilder: (int index) {
                        return ItemTags(
                          textStyle: theme.textTheme.bodySmall!,
                          pressEnabled: false,
                          index: index,
                          alignment: MainAxisAlignment.spaceBetween,
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 3),
                          borderRadius: BorderRadius.circular(8),
                          elevation: 1,
                          title:
                              "${_resistances[index].key}: ${_resistances[index].value}",
                        );
                      },
                    ),
                  ],
                )
              ],
            ),
            Expanded(
                child: SingleChildScrollView(
              child: Tags(
                spacing: 4,
                runSpacing: 6,
                runAlignment: WrapAlignment.start,
                alignment: WrapAlignment.start,
                itemCount: _skills.length,
                itemBuilder: (int index) {
                  return ItemTags(
                    textStyle: theme.textTheme.bodySmall!,
                    pressEnabled: false,
                    index: index,
                    alignment: MainAxisAlignment.spaceBetween,
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 3),
                    borderRadius: BorderRadius.circular(8),
                    elevation: 1,
                    title: "${_skills[index].key}: ${_skills[index].value}",
                  );
                },
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _pill(String text) {
    return Card(
      color: theme.primaryColor,
      child: Padding(
        padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
        child: Text(
          text,
          style: theme.textTheme.bodySmall!
              .copyWith(color: theme.colorScheme.onPrimary),
        ),
      ),
    );
  }
}
