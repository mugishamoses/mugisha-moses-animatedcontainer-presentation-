import 'package:flutter/material.dart';

import 'package:brew_lane/models/menu_item.dart';

/// Bottom sheet listing the current order. It pops with `true` when the
/// customer places the order.
class OrderSummarySheet extends StatelessWidget {
  const OrderSummarySheet({super.key, required this.order});

  /// Quantity of each item in the order.
  final Map<MenuItem, int> order;

  int get _totalRwf => order.entries.fold(
    0,
    (total, line) => total + line.key.priceRwf * line.value,
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Your order', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            if (order.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  'Your order is empty. Tap + on a menu item to add it.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              )
            else ...[
              // Scrolls when a long order is taller than the sheet allows.
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (final MapEntry(key: item, value: quantity)
                        in order.entries)
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Text(
                          '$quantity×',
                          style: theme.textTheme.titleMedium,
                        ),
                        title: Text(item.name),
                        trailing: Text(formatRwf(item.priceRwf * quantity)),
                      ),
                  ],
                ),
              ),
              const Divider(height: 24),
              Row(
                children: [
                  Text('Total', style: theme.textTheme.titleMedium),
                  const Spacer(),
                  Text(
                    formatRwf(_totalRwf),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () => Navigator.pop(context, true),
                icon: const Icon(Icons.check),
                label: const Text('Place pickup order'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
