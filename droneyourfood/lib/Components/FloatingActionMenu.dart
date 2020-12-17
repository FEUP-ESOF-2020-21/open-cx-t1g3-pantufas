import 'package:flutter/material.dart';
import 'package:droneyourfood/Components/ScrollColumn.dart';
import 'package:droneyourfood/Components/ScrollRow.dart';

class FloatingActionMenu extends StatefulWidget {
  // final bool startOpen;
  final bool isHorizontal;
  final bool buttonAtEnd;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final VerticalDirection verticalDirection;
  final List<Widget> children;

  const FloatingActionMenu({
    Key key,
    this.isHorizontal,
    this.buttonAtEnd,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.verticalDirection = VerticalDirection.down,
    this.children,
  }) : super(key: key);

  @override
  _FloatingActionMenuState createState() => _FloatingActionMenuState();
}

class _FloatingActionMenuState extends State<FloatingActionMenu> {
  bool _isOpen = false;

  void open() {
    setState(() {
      this._isOpen = true;
    });
  }

  void close() {
    setState(() {
      this._isOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Widget mainButton = FloatingActionButton(
      mini: true,
      child: Icon(this._isOpen ? Icons.close : Icons.add), // constructor
      onPressed: () {
        setState(() {
          this._isOpen = !this._isOpen;
        });
      },
    );

    Widget ret;
    if (this._isOpen) {
      List<Widget> newchildren;
      if (widget.buttonAtEnd)
        newchildren = widget.children + <Widget>[mainButton];
      else
        newchildren = <Widget>[mainButton] + widget.children;

      if (widget.isHorizontal)
        ret = ScrollRow(
          mainAxisAlignment: widget.mainAxisAlignment,
          crossAxisAlignment: widget.crossAxisAlignment,
          verticalDirection: widget.verticalDirection,
          children: newchildren,
        );
      else
        ret = ScrollColumn(
          mainAxisAlignment: widget.mainAxisAlignment,
          crossAxisAlignment: widget.crossAxisAlignment,
          verticalDirection: widget.verticalDirection,
          children: newchildren,
        );
    } else {
      ret = mainButton;
    }

    return ret;
  }
}
