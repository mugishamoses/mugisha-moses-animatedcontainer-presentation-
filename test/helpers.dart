import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:clipo/main.dart';

/// Pumps the app on a phone-sized screen.
Future<void> pumpApp(WidgetTester tester) async {
  tester.view.physicalSize = const Size(393 * 3, 852 * 3);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(const ClipoApp());
  await tester.pumpAndSettle();
}

final Finder bar = find.byKey(const Key('morphing-bar'));

/// The AnimatedContainer widget itself, to read its properties.
AnimatedContainer barWidget(WidgetTester tester) => tester.widget(bar);

double barHeight(WidgetTester tester) => tester.getSize(bar).height;

Future<void> openPanel(WidgetTester tester) async {
  await tester.tap(find.byTooltip('Open quick actions'));
  await tester.pumpAndSettle();
}

Future<void> openPlayground(WidgetTester tester) async {
  await tester.tap(find.byTooltip('Animation playground'));
  await tester.pumpAndSettle();
}
