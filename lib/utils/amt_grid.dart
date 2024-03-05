import 'package:flutter/material.dart';

class AMTGrid<T> extends StatelessWidget {
  final List<T> elements;
  final int columns;
  final Widget Function(T, int) builder;
  final Widget Function()? lastElementBuilder;

  const AMTGrid({
    super.key,
    required this.elements,
    required this.columns,
    required this.builder,
    this.lastElementBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        for (int index = 0; index < elements.length; index = index + columns)
          Row(
            children: [
              for (int element = 0; element < columns; element = element + 1)
                elements.length > index + element
                    ? Expanded(
                        child: builder(elements[index + element], index + element),
                      )
                    : elements.length == index + element && lastElementBuilder != null
                        ? Expanded(
                            child: lastElementBuilder!(),
                          )
                        : Expanded(
                            child: Container(),
                          )
            ],
          ),
        if (elements.length % columns == 0 && lastElementBuilder != null)
          IntrinsicHeight(
            child: lastElementBuilder!(),
          )
      ],
    );
  }
}
