import 'package:flutter_test/flutter_test.dart';

import 'package:brew_lane/models/menu_item.dart';

void main() {
  test('formatRwf groups thousands with commas', () {
    expect(formatRwf(0), 'RWF 0');
    expect(formatRwf(500), 'RWF 500');
    expect(formatRwf(1500), 'RWF 1,500');
    expect(formatRwf(15500), 'RWF 15,500');
    expect(formatRwf(1234567), 'RWF 1,234,567');
  });
}
