import 'package:amt/utils/explained_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags_x/flutter_tags_x.dart';

class ExplainedTextContainer extends StatelessWidget {
  final ExplainedText info;
  final int hierarchy;
  final Map<String, bool> explanationsExpanded;
  final Function(String) onExpanded;
  final String parent;

  ExplainedTextContainer({
    required this.info,
    required this.explanationsExpanded,
    required this.onExpanded,
    this.parent = "",
    this.hierarchy = 1,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    String titleForStatus = parent + info.title;
    bool hasToBeExpanded = explanationsExpanded[titleForStatus] ?? false;

    return Card(
      clipBehavior: Clip.hardEdge,
      color: _colorForHierarchy(theme, hierarchy),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                        child: Padding(
                      padding: EdgeInsets.all(6),
                      child: Text(
                        info.text,
                        style: theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                      ),
                    )),
                    if (info.explanation.isNotEmpty || info.explanations.isNotEmpty)
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        onPressed: () {
                          onExpanded(titleForStatus);
                        },
                        icon: Icon(
                          hasToBeExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                        ),
                      ),
                  ],
                ),
                if (hasToBeExpanded)
                  Padding(
                    padding: EdgeInsets.all(4),
                    child: Text(
                      info.explanation,
                      style: theme.textTheme.bodySmall!.copyWith(fontStyle: FontStyle.italic, fontWeight: FontWeight.w600),
                    ),
                  ),
                if (hasToBeExpanded)
                  for (var explanation in info.explanations)
                    ExplainedTextContainer(
                      onExpanded: onExpanded,
                      explanationsExpanded: explanationsExpanded,
                      info: explanation,
                      hierarchy: hierarchy + 1,
                      parent: info.title,
                    ),
                if (hasToBeExpanded)
                  Padding(
                    padding: EdgeInsets.all(4),
                    child: Tags(
                      spacing: 2,
                      runSpacing: 4,
                      alignment: WrapAlignment.start,
                      runAlignment: WrapAlignment.start,
                      itemCount: info.references.length,
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
                          title: "${info.references[index].bookName} P${info.references[index].page}",
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _colorForHierarchy(ThemeData theme, int hierarchy) {
    if (hierarchy % 2 == 0) {
      return theme.colorScheme.secondaryContainer;
    }

    return theme.cardColor;
  }
}
