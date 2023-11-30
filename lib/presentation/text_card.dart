import 'package:flutter/material.dart';

class TextCard extends StatelessWidget {
  final String? text;
  final double padding;
  final Color? background;
  final Color? foreground;
  final TextStyle? style;
  final int? maxLines;

  TextCard(
    this.text, {
    this.padding = 8,
    this.background,
    this.foreground,
    this.style,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      color: background ?? theme.colorScheme.primary,
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Text(
          text ?? "",
          style: style ??
              theme.textTheme.bodySmall!.copyWith(
                color: foreground ?? theme.colorScheme.onPrimary,
              ),
          overflow: TextOverflow.ellipsis,
          maxLines: maxLines ?? 1,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
