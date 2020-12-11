import 'package:flutter/material.dart';

class ScrollRow extends StatelessWidget {
  final double startWidth;
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final VerticalDirection verticalDirection;

  const ScrollRow({
    Key key,
    this.startWidth = 0.0,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.verticalDirection = VerticalDirection.down,
    this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: this.startWidth),
        child: IntrinsicHeight(
          child: Row(
            mainAxisAlignment: this.mainAxisAlignment,
            crossAxisAlignment: this.crossAxisAlignment,
            verticalDirection: this.verticalDirection,
            children: this.children,
          ),
        ),
      ),
    );
  }
}
