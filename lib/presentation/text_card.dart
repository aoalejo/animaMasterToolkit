import 'package:flutter/material.dart';

class TextCard extends StatelessWidget {
  final String? text;
  final double padding;

  TextCard(this.text, {this.padding = 8});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final style = theme.textTheme.bodySmall!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
        color: theme.colorScheme.primary,
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Text(
            text ?? "",
            style: style,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            textAlign: TextAlign.center,
          ),
        ));
  }
}
