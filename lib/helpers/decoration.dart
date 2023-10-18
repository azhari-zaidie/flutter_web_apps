import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// rounded box decoration
Decoration boxDecorationWithRoundedCorners({
  Color backgroundColor = const Color(0xFF186094),
  BorderRadius? borderRadius,
  LinearGradient? gradient,
  BoxBorder? border,
  List<BoxShadow>? boxShadow,
  DecorationImage? decorationImage,
  BoxShape boxShape = BoxShape.rectangle,
}) {
  return BoxDecoration(
    color: backgroundColor,
    borderRadius:
        boxShape == BoxShape.circle ? null : (borderRadius ?? radius()),
    gradient: gradient,
    border: border,
    boxShadow: boxShadow,
    image: decorationImage,
    shape: boxShape,
  );
}

/// returns Radius
BorderRadius radius([double? radius]) {
  return BorderRadius.all(radiusCircular(radius ?? 8));
}

/// returns Radius
Radius radiusCircular([double? radius]) {
  return Radius.circular(radius ?? 8);
}

// returns custom Radius on each side
BorderRadius radiusOnly({
  double? topRight,
  double? topLeft,
  double? bottomRight,
  double? bottomLeft,
}) {
  return BorderRadius.only(
    topRight: radiusCircular(topRight ?? 0),
    topLeft: radiusCircular(topLeft ?? 0),
    bottomRight: radiusCircular(bottomRight ?? 0),
    bottomLeft: radiusCircular(bottomLeft ?? 0),
  );
}
