import 'package:flutter/material.dart';

import 'package:clipo/models/quick_action.dart';
import 'package:clipo/theme/app_colors.dart';

/// A rounded icon square with its caption underneath.
class ActionTile extends StatelessWidget {
  const ActionTile({super.key, required this.action, required this.onTap});

  final QuickAction action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Semantics(
        button: true,
        label: action.label,
        excludeSemantics: true,
        child: Column(
          children: [
            Container(
              width: AppSizes.tileSize,
              height: AppSizes.tileSize,
              decoration: BoxDecoration(
                color: AppColors.tile,
                borderRadius: BorderRadius.circular(AppSizes.tileRadius),
              ),
              alignment: Alignment.center,
              child: _glyph(),
            ),
            const SizedBox(height: 6),
            Text(
              action.label,
              maxLines: 1,
              softWrap: false,
              overflow: TextOverflow.visible,
              style: const TextStyle(
                fontSize: 12,
                height: 1,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _glyph() {
    final icon = action.icon;
    if (icon == null) {
      return const Text(
        'Aa',
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, height: 1),
      );
    }
    return Icon(icon, size: 25, color: Colors.white);
  }
}
