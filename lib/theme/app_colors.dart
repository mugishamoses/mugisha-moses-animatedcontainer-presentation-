import 'package:flutter/material.dart';

/// Every colour used in the app, so the dark look stays consistent.
abstract final class AppColors {
  static const background = Color(0xFF0B0B0C);
  static const surface = Color(0xFF161618);
  static const textPrimary = Colors.white;
  static const textSecondary = Color(0xFFA1A1A6);
  static const textTertiary = Color(0xFF6E6E73);

  /// Fill of the bar and the round +/× button (slightly see-through).
  static const glass = Color(0xD91C1C1E);

  /// Slightly darker fill used once the bar has become the panel.
  static const glassOpen = Color(0xEB19191B);

  /// Thin border around glass surfaces.
  static const glassBorder = Color(0x14FFFFFF);

  /// Highlight behind the active nav icon and behind each action tile.
  static const highlight = Color(0x14FFFFFF);
  static const tile = Color(0x0FFFFFFF);
  static const tilePressed = Color(0x24FFFFFF);

  /// Dark overlay behind the open panel.
  static const scrim = Color(0x8C000000);

  static const accent = Color(0xFFFF4D6D);
}

/// Sizes measured from the reference design (logical pixels).
abstract final class AppSizes {
  static const barHeight = 56.0;
  static const panelHeight = 236.0;
  static const panelRadius = 24.0;
  static const barSideMargin = 20.0;
  static const barBottomMargin = 16.0;
  static const toggleGap = 12.0;
  static const tileSize = 54.0;
  static const tileRadius = 15.0;
}
