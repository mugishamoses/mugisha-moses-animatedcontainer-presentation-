import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:clipo/theme/app_colors.dart';

import 'helpers.dart';

void main() {
  testWidgets('starts as a closed pill with the polished settings', (
    tester,
  ) async {
    await pumpApp(tester);

    expect(barHeight(tester), AppSizes.barHeight);
    final container = barWidget(tester);
    expect(container.duration, const Duration(milliseconds: 350));
    expect(container.curve, Curves.easeOutBack);
    expect(container.decoration, isA<BoxDecoration>());
    expect(find.text('Trim'), findsOneWidget); // laid out but hidden
  });

  testWidgets('+ opens the panel and × closes it', (tester) async {
    await pumpApp(tester);

    await openPanel(tester);
    expect(barHeight(tester), AppSizes.panelHeight);
    expect(find.byTooltip('Close quick actions'), findsOneWidget);

    await tester.tap(find.byTooltip('Close quick actions'));
    await tester.pumpAndSettle();
    expect(barHeight(tester), AppSizes.barHeight);
  });

  testWidgets('the bar is between sizes while the animation runs', (
    tester,
  ) async {
    await pumpApp(tester);

    await tester.tap(find.byTooltip('Open quick actions'));
    await tester.pump(); // starts the animation
    await tester.pump(const Duration(milliseconds: 100));
    final height = barHeight(tester);
    expect(height, greaterThan(AppSizes.barHeight));
    expect(height, lessThan(AppSizes.panelHeight));

    await tester.pumpAndSettle();
  });

  testWidgets('decoration changes corner radius between pill and panel', (
    tester,
  ) async {
    await pumpApp(tester);
    BorderRadius radius() =>
        (barWidget(tester).decoration! as BoxDecoration).borderRadius!
            as BorderRadius;

    expect(radius().topLeft.x, AppSizes.barHeight / 2);
    await openPanel(tester);
    expect(radius().topLeft.x, AppSizes.panelRadius);
  });

  testWidgets('tapping outside the panel closes it', (tester) async {
    await pumpApp(tester);
    await openPanel(tester);

    await tester.tapAt(const Offset(200, 300));
    await tester.pumpAndSettle();
    expect(barHeight(tester), AppSizes.barHeight);
  });

  testWidgets('the back button closes the panel first', (tester) async {
    await pumpApp(tester);
    await openPanel(tester);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(barHeight(tester), AppSizes.barHeight);
  });

  testWidgets('an action closes the panel and confirms with a snackbar', (
    tester,
  ) async {
    await pumpApp(tester);
    await openPanel(tester);

    await tester.tap(find.text('Trim'));
    await tester.pumpAndSettle();
    expect(barHeight(tester), AppSizes.barHeight);
    expect(find.text('Trim tool opened · Beach day'), findsOneWidget);
  });

  testWidgets('nav icons switch the tab', (tester) async {
    await pumpApp(tester);
    expect(find.text('Recent projects'), findsOneWidget);

    await tester.tap(find.byTooltip('Inbox'));
    await tester.pumpAndSettle();
    expect(find.text('No messages yet'), findsOneWidget);
    expect(find.text('Recent projects'), findsNothing);
  });

  testWidgets('the first-run hint fades after the panel is opened', (
    tester,
  ) async {
    await pumpApp(tester);
    double hintOpacity() => tester
        .widget<AnimatedOpacity>(
          find.ancestor(
            of: find.text('Tap + for quick actions'),
            matching: find.byType(AnimatedOpacity),
          ),
        )
        .opacity;

    expect(hintOpacity(), 1);
    await openPanel(tester);
    expect(hintOpacity(), 0);
  });
}
