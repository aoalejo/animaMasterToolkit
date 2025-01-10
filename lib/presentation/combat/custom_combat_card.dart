import 'package:flutter/material.dart';

class CustomCombatCard extends StatelessWidget {

  const CustomCombatCard({required this.title, required this.children, super.key, this.actionTitle, this.padding = 16});
  final String title;
  final List<Widget> children;
  final Widget? actionTitle;
  final double padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.hardEdge,
      color: theme.colorScheme.surface,
      elevation: 12,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: 10000,
            child: ColoredBox(
                color: theme.primaryColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 8),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleMedium!.copyWith(color: theme.colorScheme.onPrimary),
                    ),
                    actionTitle ?? const SizedBox(width: 8),
                  ],
                ),),
          ),
          const SizedBox(
            height: 8,
          ),
          Padding(
            padding: EdgeInsets.all(padding),
            child: Column(
              children: children,
            ),
          ),
        ],
      ),
    );
  }
}
