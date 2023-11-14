import 'package:flutter/material.dart';

class BottomSheetCustom extends StatelessWidget {
  final String text;
  final List<Widget> children;

  BottomSheetCustom({required this.text, required this.children});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleStyle = theme.textTheme.titleSmall;
    var midHeight = MediaQuery.of(context).size.height / 2;

    return SizedBox(
      height: midHeight,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              height: 40,
              child: Text(text, style: titleStyle),
            ),
            SizedBox(
              height: midHeight - 120,
              child: ListView(children: children),
            ),
            SizedBox(
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(),
                  ElevatedButton(
                    child: const Text('Cerrar'),
                    onPressed: () => Navigator.pop(context),
                  ),
                  SizedBox(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
