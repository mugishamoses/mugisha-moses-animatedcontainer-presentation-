import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:clipo/models/quick_action.dart';
import 'package:clipo/theme/app_colors.dart';

/// A rounded icon square with its caption underneath.
/// It shrinks slightly while pressed and springs back on release.
class ActionTile extends StatefulWidget {
  const ActionTile({super.key, required this.action, required this.onTap});

  final QuickAction action;
  final VoidCallback onTap;

  @override
  State<ActionTile> createState() => _ActionTileState();
}

class _ActionTileState extends State<ActionTile> {
  bool _pressed = false;

  void _setPressed(bool value) => setState(() => _pressed = value);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => _setPressed(true),
      onTapCancel: () => _setPressed(false),
      onTapUp: (_) => _setPressed(false),
      onTap: () {
        HapticFeedback.selectionClick();
        widget.onTap();
      },
      child: Semantics(
        button: true,
        label: widget.action.label,
        excludeSemantics: true,
        child: Column(
          children: [
            AnimatedScale(
              duration: const Duration(milliseconds: 160),
              curve: _pressed ? Curves.easeOut : Curves.easeOutBack,
              scale: _pressed ? 0.92 : 1,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                width: AppSizes.tileSize,
                height: AppSizes.tileSize,
                decoration: BoxDecoration(
                  color: _pressed ? AppColors.tilePressed : AppColors.tile,
                  borderRadius: BorderRadius.circular(AppSizes.tileRadius),
                ),
                alignment: Alignment.center,
                child: _glyph(),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              widget.action.label,
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
    final icon = widget.action.icon;
    if (icon == null) {
      return const Text(
        'Aa',
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, height: 1),
      );
    }
    return Icon(icon, size: 25, color: Colors.white);
  }
}
