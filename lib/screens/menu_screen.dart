import 'package:flutter/material.dart';

import 'package:brew_lane/data/todays_menu.dart';
import 'package:brew_lane/models/menu_item.dart';
import 'package:brew_lane/widgets/menu_header.dart';
import 'package:brew_lane/widgets/menu_item_card.dart';

/// The café's menu screen, where customers build a pickup order.
class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  /// Quantity of each menu item in the current order.
  final Map<MenuItem, int> _order = {};

  void _addToOrder(MenuItem item) {
    setState(() {
      _order.update(item, (quantity) => quantity + 1, ifAbsent: () => 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
