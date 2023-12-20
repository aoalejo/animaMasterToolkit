import 'dart:convert';

import 'package:amt/models/attributes_list.dart';
import 'package:amt/models/character/character.dart';
import 'package:amt/models/character_profile.dart';
import 'package:amt/utils/int_extension.dart';
import 'package:amt/utils/key_value.dart';
import 'package:fl_chart/fl_chart.dart';
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
  late final List<int> _attributes;

  final String _placeholder =
      "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";

  CharacterNPCCard(
    this.character,
    this.theme, {
    required this.onSelected,
    required this.onRemove,
  }) {
    _skills = character.skills.list();
    _profile = character.profile;
    _combat = character.getCombatItems();
    _combat.add(KeyValue(key: "Presencia", value: character.resistances.presence.toString()));
    _attributes = character.attributes.orderedList();
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.transparent,
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 0,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.toY.round().toString(),
              const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      );

  Widget getTitles(double value, TitleMeta meta) {
    String text = AttributesList.names()[value.toInt()];

    return SideTitleWidget(
      axisSide: value.toInt() % 2 == 0 ? AxisSide.bottom : AxisSide.top,
      space: 4,
      child: Text(text, style: theme.textTheme.bodySmall),
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            getTitlesWidget: getTitles,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  FlBorderData get borderData => FlBorderData(
        show: false,
      );

  List<BarChartGroupData> get barGroups => [
        for (var i = 0; i < _attributes.length; i++)
          BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: _attributes[i].toDouble(),
                color: (_attributes[i].toInt() * 10).percentageColor(lastTransparent: false),
              )
            ],
            showingTooltipIndicators: [0],
          )
      ];

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
                  '${_profile.name} (${_profile.category})',
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
                        child: Image.memory(base64Decode(_profile.image?.isEmpty ?? true ? _placeholder : _profile.image!)),
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
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                SizedBox(
                  width: 128,
                  height: 128,
                  child: BarChart(
                    BarChartData(
                      barTouchData: barTouchData,
                      titlesData: titlesData,
                      borderData: borderData,
                      barGroups: barGroups,
                      gridData: FlGridData(show: false),
                      alignment: BarChartAlignment.spaceBetween,
                      maxY: 20,
                    ),
                  ),
                ),
                SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Tags(
                    spacing: 2,
                    runSpacing: 4,
                    alignment: WrapAlignment.start,
                    runAlignment: WrapAlignment.start,
                    itemCount: _combat.length,
                    itemBuilder: (int index) {
                      return ItemTags(
                        textStyle: theme.textTheme.bodySmall!,
                        pressEnabled: false,
                        index: index,
                        activeColor: Colors.black54,
                        textActiveColor: Colors.white,
                        alignment: MainAxisAlignment.spaceBetween,
                        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 4),
                        borderRadius: BorderRadius.circular(8),
                        elevation: 1,
                        title: "${_combat[index].key}: ${_combat[index].value}",
                      );
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 8,
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
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 4),
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
          style: theme.textTheme.bodySmall!.copyWith(color: theme.colorScheme.onPrimary),
        ),
      ),
    );
  }
}
