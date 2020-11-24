import 'package:flutter/material.dart';

class ScrollColumn extends StatelessWidget {
  final double startHeight;
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final VerticalDirection verticalDirection;

  const ScrollColumn({
    Key key,
    this.startHeight = 0.0,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.verticalDirection = VerticalDirection.down,
    this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: this.startHeight),
        child: IntrinsicHeight(
          child: Column(
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
