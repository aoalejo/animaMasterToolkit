import 'package:amt/utils/explained_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags_x/flutter_tags_x.dart';

class ExplainedTextContainer extends StatelessWidget {
  const ExplainedTextContainer({
    required this.info,
    required this.explanationsExpanded,
    required this.onExpanded,
    super.key,
    this.parent = '',
    this.hierarchy = 1,
  });

  final ExplainedText info;
  final int hierarchy;
  final Map<String, bool> explanationsExpanded;
  final void Function(String) onExpanded;
  final String parent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final titleForStatus = parent + info.title;
    final hasToBeExpanded = explanationsExpanded[titleForStatus] ?? false;

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
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Text(
                          info.text,
                          style: theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
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
                    padding: const EdgeInsets.all(4),
                    child: Text(
                      info.explanation,
                      style: theme.textTheme.bodySmall!.copyWith(fontStyle: FontStyle.italic, fontWeight: FontWeight.w600),
                    ),
                  ),
                if (hasToBeExpanded)
                  for (final explanation in info.explanations)
                    ExplainedTextContainer(
                      onExpanded: onExpanded,
                      explanationsExpanded: explanationsExpanded,
                      info: explanation,
                      hierarchy: hierarchy + 1,
                      parent: info.title,
                    ),
                if (hasToBeExpanded)
                  Padding(
                    padding: const EdgeInsets.all(4),
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
                          alignment: MainAxisAlignment.spaceBetween,
                          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 4),
                          borderRadius: BorderRadius.circular(8),
                          elevation: 1,
                          title: '${info.references[index].bookName} P${info.references[index].page}',
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
    if (hierarchy.isEven) {
      return theme.colorScheme.secondaryContainer;
    }

    return theme.cardColor;
  }
}
