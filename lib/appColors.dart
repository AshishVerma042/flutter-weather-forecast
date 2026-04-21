import 'package:flutter/material.dart';

class AppColors {
  // Main deep purple tone used throughout backgrounds and containers
  static const Color primaryPurple = Color.fromARGB(100, 49, 29, 119);

  // Variants with different opacity (used in cards, overlays, etc.)
  static final Color primaryPurpleAlpha200 = primaryPurple.withAlpha(200);
  static final Color primaryPurpleAlpha250 = primaryPurple.withAlpha(250);
  static final Color primaryPurpleAlpha160 = primaryPurple.withAlpha(160);

  // Text colors
  static const Color onPrimary = Colors.white;
  static const Color onSecondary = Colors.white70;
  static const Color mutedText = Colors.white54;
  static const Color mutedText1 = Colors.white60;

  // Shadow and border colors
  static final Color boxShadow = primaryPurple.withAlpha(100);
  static final Color border = Color.fromARGB(210, 69, 29, 119);

  static final AppColors _appColors = AppColors._internal();
  factory AppColors() {
    return _appColors;
  }
  AppColors._internal();
}

AppColors appColors = AppColors();
