// Renders the README screenshots with the real fonts.
// Run: flutter test tool/screenshots_test.dart
// (Kept out of test/ so the normal `flutter test` run has no side effects.)
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:clipo/main.dart';

Future<void> _loadFont(String family, List<String> assets) async {
  final loader = FontLoader(family);
  for (final asset in assets) {
    loader.addFont(rootBundle.load(asset));
  }
  await loader.load();
}

Future<void> _capture(WidgetTester tester, String name) async {
  final boundary = tester.renderObject<RenderRepaintBoundary>(
    find.byKey(const Key('shot')),
  );
  await tester.runAsync(() async {
    final image = await boundary.toImage(pixelRatio: 2);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    final dir = Directory('screenshots')..createSync();
    File('${dir.path}/$name.png').writeAsBytesSync(bytes!.buffer.asUint8List());
  });
}

void main() {
  testWidgets('capture screenshots', (tester) async {
    await _loadFont('Inter', [
      'assets/fonts/Inter-Regular.ttf',
      'assets/fonts/Inter-Medium.ttf',
      'assets/fonts/Inter-SemiBold.ttf',
      'assets/fonts/Inter-Bold.ttf',
    ]);
    await _loadFont('JetBrainsMono', [
      'assets/fonts/JetBrainsMono-Regular.ttf',
      'assets/fonts/JetBrainsMono-Bold.ttf',
    ]);
    await _loadFont('packages/lucide_icons_flutter/Lucide', [
      'packages/lucide_icons_flutter/assets/lucide.ttf',
    ]);

    // iPhone 15-sized screen with a home indicator inset.
    tester.view.physicalSize = const Size(393 * 3, 852 * 3);
    tester.view.devicePixelRatio = 3;
    tester.view.padding = const FakeViewPadding(top: 59 * 3, bottom: 34 * 3);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      const RepaintBoundary(key: Key('shot'), child: ClipoApp()),
    );
    await tester.pumpAndSettle();
    await _capture(tester, 'closed');

    await tester.tap(find.byTooltip('Open quick actions'));
    await tester.pumpAndSettle();
    await _capture(tester, 'open');

    // Close the panel, open the playground, then open the panel again so
    // both are visible together.
    await tester.tap(find.byTooltip('Close quick actions'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Animation playground'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Open quick actions'));
    await tester.pumpAndSettle();
    await _capture(tester, 'playground');
  });
}
