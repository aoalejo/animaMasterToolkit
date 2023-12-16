import 'dart:convert';

import 'package:amt/models/attributes_list.dart';
import 'package:amt/models/character/character.dart';
import 'package:amt/models/character_profile.dart';
import 'package:amt/utils/Int+Extension.dart';
import 'package:amt/utils/Key_value.dart';
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

  CharacterNPCCard(
    this.character,
    this.theme, {
    required this.onSelected,
    required this.onRemove,
  }) {
    _skills = character.skills.list();
    _profile = character.profile;
    _combat = character.getCombatItems();
    _combat.add(KeyValue(
        key: "Presencia", value: character.resistances.presence.toString()));
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
                color: (_attributes[i].toInt() * 10)
                    .percentageColor(lastTransparent: false),
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
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 4),
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
          style: theme.textTheme.bodySmall!
              .copyWith(color: theme.colorScheme.onPrimary),
        ),
      ),
    );
  }
}
