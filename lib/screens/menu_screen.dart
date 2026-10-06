import 'package:flutter/material.dart';

import 'package:brew_lane/data/todays_menu.dart';
import 'package:brew_lane/models/menu_item.dart';
import 'package:brew_lane/widgets/brand_title.dart';
import 'package:brew_lane/widgets/cart_button.dart';
import 'package:brew_lane/widgets/menu_header.dart';
import 'package:brew_lane/widgets/menu_item_card.dart';
import 'package:brew_lane/widgets/order_summary_sheet.dart';

/// The café's menu screen, where customers build a pickup order.
///
/// Its [AppBar] carries the café's brand and keeps the cart, with a live item
/// count, in reach while the customer scrolls the menu.
class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  /// Quantity of each menu item in the current order.
  final Map<MenuItem, int> _order = {};

  int get _itemCount =>
      _order.values.fold(0, (count, quantity) => count + quantity);

  void _addToOrder(MenuItem item) {
    setState(() {
      _order.update(item, (quantity) => quantity + 1, ifAbsent: () => 1);
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
        title: const BrandTitle(),
        actions: [
          CartButton(itemCount: _itemCount, onPressed: _showOrderSummary),
        ],
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.only(top: 8, bottom: 16),
          children: [
            const MenuHeader(),
            for (final item in todaysMenu)
              MenuItemCard(item: item, onAdd: () => _addToOrder(item)),
          ],
        ),
      ),
    );
  }
}
