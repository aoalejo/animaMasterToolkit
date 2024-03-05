import 'package:flutter/material.dart';

class AMTBottomSheet extends StatelessWidget {
  final Widget title;
  final List<Widget> children;
  final List<Widget>? bottomRow;

  AMTBottomSheet({required this.title, required this.children, this.bottomRow});

  @override
  Widget build(BuildContext context) {
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
              child: title,
            ),
            SizedBox(
              height: midHeight - 160,
              child: ListView(children: children),
            ),
            SizedBox(
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(),
                  if (bottomRow != null)
                    ...bottomRow!
                  else
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
