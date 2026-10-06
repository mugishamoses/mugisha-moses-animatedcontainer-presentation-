// Widget tests for the Brew Lane AppBar demo. They check what each of the
// three demonstrated properties actually renders, not just the value passed
// in, so the claims made during the demo are backed by Flutter itself.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:brew_lane/data/todays_menu.dart';
import 'package:brew_lane/main.dart';
import 'package:brew_lane/models/app_bar_color_option.dart';
import 'package:brew_lane/widgets/brand_title.dart';
import 'package:brew_lane/widgets/property_panel.dart';

/// Logical size of the demo emulator's screen (1080 × 2400 px at 2.625).
const Size _phoneSize = Size(411, 914);

Future<void> _pumpApp(WidgetTester tester, {Size size = _phoneSize}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(const BrewLaneApp());
}

AppBar _appBar(WidgetTester tester) =>
    tester.widget<AppBar>(find.byType(AppBar));

/// The Material that paints the AppBar's background.
Material _appBarMaterial(WidgetTester tester) => tester.widget<Material>(
  find
      .descendant(of: find.byType(AppBar), matching: find.byType(Material))
      .first,
);

/// The status bar style the AppBar requests from Android.
SystemUiOverlayStyle _statusBarStyle(WidgetTester tester) => tester
    .widget<AnnotatedRegion<SystemUiOverlayStyle>>(
      find.descendant(
        of: find.byType(AppBar),
        matching: find.byType(AnnotatedRegion<SystemUiOverlayStyle>),
      ),
    )
    .value;

double _appBarHeight(WidgetTester tester) =>
    tester.getSize(find.byType(AppBar)).height;

double _titleLeft(WidgetTester tester) =>
    tester.getTopLeft(find.byType(BrandTitle)).dx;

Finder _badgeLabel(String count) =>
    find.descendant(of: find.byType(Badge), matching: find.text(count));

void main() {
  testWidgets('starts with all three properties null and resolves defaults', (
    tester,
  ) async {
    await _pumpApp(tester);

    final appBar = _appBar(tester);
    expect(appBar.backgroundColor, isNull);
    expect(appBar.centerTitle, isNull);
    expect(appBar.toolbarHeight, isNull);

    final colors = Theme.of(tester.element(find.byType(AppBar))).colorScheme;
    // backgroundColor: null → colorScheme.surface in Material 3.
    expect(_appBarMaterial(tester).color, colors.surface);
    expect(_statusBarStyle(tester).statusBarIconBrightness, Brightness.dark);
    // centerTitle: null → start-aligned on Android, after the 16 dp spacing.
    expect(_titleLeft(tester), NavigationToolbar.kMiddleSpacing);
    // toolbarHeight: null → kToolbarHeight, which is 56 (not M3's 64).
    expect(kToolbarHeight, 56);
    expect(_appBarHeight(tester), kToolbarHeight);
  });

  testWidgets('backgroundColor paints the bar and flips status bar icons', (
    tester,
  ) async {
    await _pumpApp(tester);

    await tester.tap(find.text('Mocha'));
    await tester.pump();

    final appBar = _appBar(tester);
    expect(appBar.backgroundColor, AppBarColorOption.mocha.background);
    expect(appBar.foregroundColor, Colors.white);
    expect(_appBarMaterial(tester).color, AppBarColorOption.mocha.background);
    expect(_statusBarStyle(tester).statusBarIconBrightness, Brightness.light);
    expect(find.text('Color(0xFF3B2418)'), findsOneWidget);

    await tester.tap(find.text('Caramel'));
    await tester.pump();

    // A light background keeps dark status bar icons.
    expect(_appBarMaterial(tester).color, AppBarColorOption.caramel.background);
    expect(_statusBarStyle(tester).statusBarIconBrightness, Brightness.dark);
  });

  testWidgets('centerTitle moves the title between start and centre', (
    tester,
  ) async {
    await _pumpApp(tester);

    await tester.tap(find.text('Center'));
    await tester.pump();

    expect(_appBar(tester).centerTitle, isTrue);
    expect(
      tester.getCenter(find.byType(BrandTitle)).dx,
      moreOrLessEquals(_phoneSize.width / 2, epsilon: 0.5),
    );

    await tester.tap(find.text('Start'));
    await tester.pump();

    // false looks the same as the Android default (null).
    expect(_appBar(tester).centerTitle, isFalse);
    expect(_titleLeft(tester), NavigationToolbar.kMiddleSpacing);
  });

  testWidgets('toolbarHeight resizes the bar', (tester) async {
    await _pumpApp(tester);

    await tester.drag(find.byType(Slider), const Offset(1000, 0));
    await tester.pump();

    expect(_appBar(tester).toolbarHeight, PropertyPanel.maxToolbarHeight);
    expect(_appBarHeight(tester), PropertyPanel.maxToolbarHeight);
    expect(find.text('128.0'), findsOneWidget);

    await tester.drag(find.byType(Slider), const Offset(-1000, 0));
    await tester.pump();

    expect(_appBarHeight(tester), PropertyPanel.minToolbarHeight);
  });

  testWidgets('Reset returns every property to null', (tester) async {
    await _pumpApp(tester);

    await tester.tap(find.text('Matcha'));
    await tester.pump();
    await tester.tap(find.text('Center'));
    await tester.pump();
    await tester.drag(find.byType(Slider), const Offset(1000, 0));
    await tester.pump();

    await tester.tap(find.text('Reset'));
    await tester.pump();

    final appBar = _appBar(tester);
    expect(appBar.backgroundColor, isNull);
    expect(appBar.centerTitle, isNull);
    expect(appBar.toolbarHeight, isNull);
    expect(_appBarHeight(tester), kToolbarHeight);
  });

  testWidgets('cart badge counts items and the order can be placed', (
    tester,
  ) async {
    await _pumpApp(tester);
    expect(find.byType(Badge), findsOneWidget);
    expect(_badgeLabel('0'), findsNothing);

    await tester.tap(find.byTooltip('Add Espresso'));
    await tester.tap(find.byTooltip('Add Espresso'));
    await tester.tap(find.byTooltip('Add Cappuccino'));
    await tester.pump();

    expect(_badgeLabel('3'), findsOneWidget);

    await tester.tap(find.byTooltip('View order'));
    await tester.pumpAndSettle();

    // 2 × RWF 1,500 + 1 × RWF 2,500.
    expect(find.text('RWF 5,500'), findsOneWidget);

    await tester.tap(find.text('Place pickup order'));
    await tester.pumpAndSettle();

    expect(
      find.text('Order placed! It will be ready in about 10 minutes.'),
      findsOneWidget,
    );
    expect(_badgeLabel('3'), findsNothing);
  });

  testWidgets('collapsing the panel hides the controls', (tester) async {
    await _pumpApp(tester);

    await tester.tap(find.byTooltip('Hide properties'));
    await tester.pumpAndSettle();

    expect(find.byType(Slider), findsNothing);

    await tester.tap(find.byTooltip('Show properties'));
    await tester.pumpAndSettle();

    expect(find.byType(Slider), findsOneWidget);
  });

  // Any layout overflow throws during these tests and fails them.
  for (final size in const [Size(320, 568), Size(914, 411)]) {
    testWidgets(
      'fits a ${size.width.toInt()}×${size.height.toInt()} screen at the '
      'tallest toolbar with a full order',
      (tester) async {
        await _pumpApp(tester, size: size);

        await tester.ensureVisible(find.byType(Slider));
        await tester.drag(find.byType(Slider), const Offset(1000, 0));
        await tester.pump();
        expect(_appBarHeight(tester), PropertyPanel.maxToolbarHeight);

        for (final item in todaysMenu) {
          final addButton = find.byTooltip('Add ${item.name}');
          await tester.ensureVisible(addButton);
          await tester.tap(addButton);
          await tester.pump();
        }
        expect(_badgeLabel('${todaysMenu.length}'), findsOneWidget);

        await tester.tap(find.byTooltip('View order'));
        await tester.pumpAndSettle();
        expect(find.text('Place pickup order'), findsOneWidget);
      },
    );
  }
}
