import 'package:flutter/material.dart';

class InputBorders {
InputBorders._();

static const border = OutlineInputBorder(
  borderRadius: Radiuses.r8,
  borderSide: BorderSide(
    color: ColorPalette.strokeGrey,
    width: 0.8,
  ),
);

static const enabled = OutlineInputBorder(
  borderRadius: Radiuses.r8,
  borderSide: BorderSide(
    color: ColorPalette.strokeGrey,
    width: 0.8,
  ),
);

static const error = OutlineInputBorder(
  borderRadius: Radiuses.r8,
  borderSide: BorderSide(
    color: ColorPalette.red,
    width: 0.8,
  ),
);

static const success = OutlineInputBorder(
  borderRadius: Radiuses.r8,
  borderSide: BorderSide(
    color: ColorPalette.greenDark,
    width: 0.8,
  ),
);

static const focused = OutlineInputBorder(
  borderRadius: Radiuses.r8,
  borderSide: BorderSide(
    color: ColorPalette.blueLight,
    width: 0.8,
  ),
);
}

class ColorPalette {
  ColorPalette._();

  static const blueLight = Color(0xFF5599FB);
  static const greenDark = Color(0xFF219653);
  static const red = Color(0xFFFF0033);
  static const strokeGrey = Color(0xFFB4B4B4);
}

class Radiuses {
  Radiuses._();

  static const r8 = BorderRadius.all(Radius.circular(8));
}
