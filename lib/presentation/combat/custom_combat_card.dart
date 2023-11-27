import 'package:flutter/material.dart';

class CustomCombatCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  CustomCombatCard({required this.title, required this.children});

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
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium!
                    .copyWith(color: theme.colorScheme.onPrimary),
              ),
            ),
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
