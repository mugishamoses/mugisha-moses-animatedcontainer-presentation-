import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:parcel_tracker/main.dart';
import 'package:parcel_tracker/widgets/parcel_card.dart';

AnimatedContainer firstCard(WidgetTester tester) => tester.widget(
      find.byKey(const ValueKey('card-KGL-20481')),
    );

double firstCardHeight(WidgetTester tester) =>
    tester.getSize(find.byKey(const ValueKey('card-KGL-20481'))).height;

Future<void> pumpApp(WidgetTester tester) async {
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 2.5;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(const ParcelTrackerApp());
}

void main() {
  testWidgets('starts with the AnimatedContainer defaults', (tester) async {
    await pumpApp(tester);
    final card = firstCard(tester);
    expect(card.duration, const Duration(milliseconds: 300));
    expect(card.curve, Curves.linear);
    expect(card.decoration, isNull);
  });

  testWidgets('tapping a card expands it, tapping again collapses it',
      (tester) async {
    await pumpApp(tester);
    expect(firstCardHeight(tester), ParcelCard.collapsedHeight);

    await tester.tap(find.text('Wireless headphones'));
    await tester.pumpAndSettle();
    expect(firstCardHeight(tester), ParcelCard.expandedHeight);

    await tester.tap(find.text('Wireless headphones'));
    await tester.pumpAndSettle();
    expect(firstCardHeight(tester), ParcelCard.collapsedHeight);
  });

  testWidgets('the card is still mid-animation before duration ends',
      (tester) async {
    await pumpApp(tester);
    await tester.tap(find.text('Wireless headphones'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 150));
    final height = firstCardHeight(tester);
    expect(height, greaterThan(ParcelCard.collapsedHeight));
    expect(height, lessThan(ParcelCard.expandedHeight));
  });

  testWidgets('curve chip changes the curve', (tester) async {
    await pumpApp(tester);
    await tester.tap(find.text('bounceOut'));
    await tester.pump();
    expect(firstCard(tester).curve, Curves.bounceOut);
  });

  testWidgets('decoration switch adds a BoxDecoration', (tester) async {
    await pumpApp(tester);
    await tester.tap(find.byKey(const Key('decoration-switch')));
    await tester.pump();
    expect(firstCard(tester).decoration, isA<BoxDecoration>());
  });

  testWidgets('duration slider and Reset', (tester) async {
    await pumpApp(tester);
    await tester.drag(
        find.byKey(const Key('duration-slider')), const Offset(300, 0));
    await tester.pump();
    expect(firstCard(tester).duration.inMilliseconds, greaterThan(300));

    await tester.tap(find.byKey(const Key('reset')));
    await tester.pump();
    expect(firstCard(tester).duration, const Duration(milliseconds: 300));
    expect(firstCard(tester).curve, Curves.linear);
  });
}
