import 'package:flutter/material.dart';

class BottomSheetCustom extends StatelessWidget {
  final Widget title;
  final List<Widget> children;

  BottomSheetCustom({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    var midHeight = MediaQuery.of(context).size.height / 1.5;

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
