import 'package:flutter/material.dart';

import 'package:clipo/theme/app_colors.dart';

ThemeData buildAppTheme() {
  final base = ThemeData(
    brightness: Brightness.dark,
    fontFamily: 'Inter',
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: const ColorScheme.dark(
      primary: Colors.white,
      onPrimary: Colors.black,
      secondary: AppColors.accent,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
    ),
    splashFactory: NoSplash.splashFactory,
    highlightColor: Colors.transparent,
  );

  return base.copyWith(
    textTheme: base.textTheme.apply(
      bodyColor: AppColors.textPrimary,
      displayColor: AppColors.textPrimary,
    ),
    snackBarTheme: const SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Color(0xFF2C2C2E),
      contentTextStyle: TextStyle(
        fontFamily: 'Inter',
        color: Colors.white,
        fontWeight: FontWeight.w500,
      ),
      shape: StadiumBorder(),
    ),
    sliderTheme: const SliderThemeData(
      activeTrackColor: Colors.white,
      inactiveTrackColor: Color(0x33FFFFFF),
      thumbColor: Colors.white,
      overlayColor: Color(0x1FFFFFFF),
      trackHeight: 6,
    ),
  );
}
