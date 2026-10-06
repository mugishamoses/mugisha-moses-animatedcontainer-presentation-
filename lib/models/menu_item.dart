import 'package:flutter/widgets.dart';

/// One drink or snack on the café menu.
@immutable
class MenuItem {
  const MenuItem({
    required this.name,
    required this.description,
    required this.priceRwf,
    required this.icon,
  });

  final String name;
  final String description;

  /// Price in Rwandan francs. RWF has no minor unit, so an int is exact.
  final int priceRwf;

  final IconData icon;
}

/// Formats a franc amount with thousands separators, e.g. `RWF 2,500`.
String formatRwf(int amount) {
  final digits = amount.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    final digitsLeft = digits.length - i;
    if (i > 0 && digitsLeft % 3 == 0) {
      buffer.write(',');
    }
    buffer.write(digits[i]);
  }
  return 'RWF $buffer';
}
