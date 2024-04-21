import 'dart:math';

import 'package:flutter/cupertino.dart';

enum DotType {
  square, circle, diamond, icon
}

class Dot extends StatelessWidget {
  final double? radius;
  final Color? color;
  final DotType? type;
  final Icon? icon;

  Dot({this.radius, this.color, this.type, this.icon});

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: type == DotType.icon ?
      Icon(icon!.icon, color: color, size: 1.3 * radius!,)
          : new Transform.rotate(
        angle: type == DotType.diamond ? pi/4 : 0.0,
        child: Container(
          width: radius,
          height: radius,
          decoration: BoxDecoration(color: color, shape: type == DotType.circle? BoxShape.circle : BoxShape.rectangle),
        ),
      ),
    );
  }
}
