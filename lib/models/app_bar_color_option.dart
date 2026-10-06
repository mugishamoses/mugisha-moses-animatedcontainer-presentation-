import 'package:flutter/material.dart';

/// Background colours offered for the AppBar, each paired with a foreground
/// colour that keeps the title and icons readable on top of it.
enum AppBarColorOption {
  /// Leaves both colours null, so the AppBar uses its Material 3 defaults.
  themeDefault('Default', null, null),
  mocha('Mocha', Color(0xFF3B2418), Colors.white),
  caramel('Caramel', Color(0xFFE0A458), Color(0xFF2B1A12)),
  matcha('Matcha', Color(0xFF4F6B3A), Colors.white);

  const AppBarColorOption(this.label, this.background, this.foreground);

  final String label;

  /// Passed to `AppBar.backgroundColor`.
  final Color? background;

  /// Passed to `AppBar.foregroundColor`.
  final Color? foreground;

  /// [background] as it would be written in source code, for example
  /// `Color(0xFF3B2418)`, or null when no colour is set.
  String? get backgroundCode {
    final color = background;
    if (color == null) return null;
    final hex = color.toARGB32().toRadixString(16).toUpperCase();
    return 'Color(0x${hex.padLeft(8, '0')})';
  }
}
