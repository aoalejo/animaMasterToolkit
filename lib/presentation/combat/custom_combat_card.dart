import 'package:flutter/material.dart';

class CustomCombatCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final Widget? actionTitle;

  CustomCombatCard(
      {required this.title, required this.children, this.actionTitle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.hardEdge,
      color: theme.colorScheme.background,
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
                    SizedBox(width: 8),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleMedium!
                          .copyWith(color: theme.colorScheme.onPrimary),
                    ),
                    actionTitle ?? SizedBox(width: 8),
                  ],
                )),
          ),
          SizedBox(
            height: 8,
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: children,
            ),
          )
        ],
      ),
    );
  }
}
