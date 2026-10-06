import 'package:flutter/material.dart';

/// AppBar action that opens the current order. The badge shows how many
/// items are in it and hides itself while the order is empty.
class CartButton extends StatelessWidget {
  const CartButton({
    super.key,
    required this.itemCount,
    required this.onPressed,
  });

  final int itemCount;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'View order',
      onPressed: onPressed,
      icon: Badge.count(
        count: itemCount,
        isLabelVisible: itemCount > 0,
        child: const Icon(Icons.shopping_bag_outlined),
      ),
    );
  }
}
