import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:clipo/theme/app_colors.dart';

import 'helpers.dart';

String codeLine(WidgetTester tester) => tester
    .widget<RichText>(
      find.descendant(
        of: find.byKey(const Key('code-line')),
        matching: find.byType(RichText),
      ),
    )
    .text
    .toPlainText();

void main() {
  testWidgets('reset shows the Flutter defaults', (tester) async {
    await pumpApp(tester);
    await openPlayground(tester);

    await tester.tap(find.byKey(const Key('reset')));
    await tester.pump();

    final container = barWidget(tester);
    expect(container.curve, Curves.linear);
    expect(container.decoration, isNull);
    expect(codeLine(tester), contains('curve: Curves.linear'));
    expect(codeLine(tester), contains('decoration: null'));
  });

  testWidgets('polished restores the tuned values', (tester) async {
    await pumpApp(tester);
    await openPlayground(tester);

    await tester.tap(find.byKey(const Key('reset')));
    await tester.tap(find.byKey(const Key('polished')));
    await tester.pump();

    expect(barWidget(tester).curve, Curves.easeOutBack);
    expect(barWidget(tester).decoration, isA<BoxDecoration>());
  });

  testWidgets('duration slider changes the duration', (tester) async {
    await pumpApp(tester);
    await openPlayground(tester);

    await tester.drag(
      find.byKey(const Key('duration-slider')),
      const Offset(400, 0),
    );
    await tester.pump();

    final ms = barWidget(tester).duration.inMilliseconds;
    expect(ms, greaterThan(350));
    expect(codeLine(tester), contains('duration: ${ms}ms'));
  });

  testWidgets('curve cards change the curve', (tester) async {
    await pumpApp(tester);
    await openPlayground(tester);

    await tester.tap(find.byKey(const Key('curve-bounceOut')));
    await tester.pump();
    expect(barWidget(tester).curve, Curves.bounceOut);

    await tester.tap(find.byKey(const Key('curve-easeInOut')));
    await tester.pump();
    expect(barWidget(tester).curve, Curves.easeInOut);
  });

  testWidgets('decoration cards switch between null and BoxDecoration', (
    tester,
  ) async {
    await pumpApp(tester);
    await openPlayground(tester);

    await tester.tap(find.byKey(const Key('decoration-null')));
    await tester.pump();
    expect(barWidget(tester).decoration, isNull);

    await tester.tap(find.byKey(const Key('decoration-box')));
    await tester.pump();
    expect(barWidget(tester).decoration, isA<BoxDecoration>());
  });

  testWidgets('replay opens the bar and then closes it again', (tester) async {
    await pumpApp(tester);
    await openPlayground(tester);

    await tester.tap(find.byKey(const Key('replay')));
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pump(const Duration(milliseconds: 400));
    expect(barHeight(tester), AppSizes.panelHeight);

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    expect(barHeight(tester), AppSizes.barHeight);
  });
}
