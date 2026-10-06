import 'package:flutter_test/flutter_test.dart';

import 'package:brew_lane/main.dart';

void main() {
  testWidgets('shows the café menu', (tester) async {
    await tester.pumpWidget(const BrewLaneApp());

    expect(find.text('What are you craving?'), findsOneWidget);
    expect(find.text('Espresso'), findsOneWidget);
    expect(find.text('RWF 1,500'), findsOneWidget);
  });
}
