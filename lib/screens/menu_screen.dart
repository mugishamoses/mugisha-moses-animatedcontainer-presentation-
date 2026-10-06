import 'package:flutter/material.dart';

import 'package:brew_lane/data/todays_menu.dart';
import 'package:brew_lane/models/app_bar_color_option.dart';
import 'package:brew_lane/models/menu_item.dart';
import 'package:brew_lane/widgets/brand_title.dart';
import 'package:brew_lane/widgets/cart_button.dart';
import 'package:brew_lane/widgets/menu_header.dart';
import 'package:brew_lane/widgets/menu_item_card.dart';
import 'package:brew_lane/widgets/order_summary_sheet.dart';
import 'package:brew_lane/widgets/property_panel.dart';

/// Share of the body height the property panel may take; the rest always
/// stays available for the menu.
const double _maxPanelHeightFraction = 0.5;

/// The café's menu screen, where customers build a pickup order.
///
/// Its [AppBar] carries the café's brand and keeps the cart, with a live item
/// count, in reach while the customer scrolls the menu. The [PropertyPanel]
/// changes three of the AppBar's constructor properties while the app runs.
class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  /// Quantity of each menu item in the current order.
  final Map<MenuItem, int> _order = {};

  // The three demonstrated AppBar properties. null means "not set", so the
  // AppBar falls back to its theme and then to Flutter's built-in default.
  AppBarColorOption _colorOption = AppBarColorOption.themeDefault;
  bool? _centerTitle;
  double? _toolbarHeight;

  int get _itemCount =>
      _order.values.fold(0, (count, quantity) => count + quantity);

  void _addToOrder(MenuItem item) {
    setState(() {
      _order.update(item, (quantity) => quantity + 1, ifAbsent: () => 1);
    });
  }

  void _resetAppBarProperties() {
    setState(() {
      _colorOption = AppBarColorOption.themeDefault;
      _centerTitle = null;
      _toolbarHeight = null;
    });
  }

  Future<void> _showOrderSummary() async {
    final placed = await showModalBottomSheet<bool>(
      context: context,
      showDragHandle: true,
      builder: (context) => OrderSummarySheet(order: Map.of(_order)),
    );
    if (placed != true || !mounted) return;

    setState(_order.clear);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Order placed! It will be ready in about 10 minutes.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Property 1: backgroundColor, the fill colour of the bar.
        // null → AppBarTheme → colorScheme.surface (Material 3).
        backgroundColor: _colorOption.background,
        // backgroundColor does not recolour the title or icons; foregroundColor
        // does. Each colour option pairs a readable one (null → onSurface).
        foregroundColor: _colorOption.foreground,
        // Property 2: centerTitle, whether the title sits in the middle.
        // null → AppBarTheme → platform default (start-aligned on Android).
        centerTitle: _centerTitle,
        // Property 3: toolbarHeight, the height of the toolbar row.
        // null → AppBarTheme → kToolbarHeight (56.0).
        toolbarHeight: _toolbarHeight,
        title: const BrandTitle(),
        actions: [
          CartButton(itemCount: _itemCount, onPressed: _showOrderSummary),
        ],
      ),
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) => Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(top: 8, bottom: 16),
                  children: [
                    const MenuHeader(),
                    for (final item in todaysMenu)
                      MenuItemCard(item: item, onAdd: () => _addToOrder(item)),
                  ],
                ),
              ),
              PropertyPanel(
                maxHeight: constraints.maxHeight * _maxPanelHeightFraction,
                colorOption: _colorOption,
                centerTitle: _centerTitle,
                toolbarHeight: _toolbarHeight,
                onColorOptionChanged: (option) =>
                    setState(() => _colorOption = option),
                onCenterTitleChanged: (value) =>
                    setState(() => _centerTitle = value),
                onToolbarHeightChanged: (value) =>
                    setState(() => _toolbarHeight = value),
                onReset: _resetAppBarProperties,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
