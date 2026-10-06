import 'package:flutter/material.dart';

import 'package:brew_lane/models/menu_item.dart';

/// A menu entry: icon, name, short description, price and an Add button.
class MenuItemCard extends StatelessWidget {
  const MenuItemCard({super.key, required this.item, required this.onAdd});

  final MenuItem item;
  final VoidCallback onAdd;

  /// Matches the 48 dp minimum touch target so the row lines up evenly.
  static const double _iconTileSize = 48;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: _iconTileSize,
              height: _iconTileSize,
              decoration: BoxDecoration(
                color: colors.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(item.icon, color: colors.onPrimaryContainer),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name, style: textTheme.titleMedium),
                  Text(
                    item.description,
                    style: textTheme.bodySmall?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formatRwf(item.priceRwf),
                    style: textTheme.labelLarge?.copyWith(
                      color: colors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filledTonal(
              onPressed: onAdd,
              tooltip: 'Add ${item.name}',
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}
