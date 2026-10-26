import 'package:flutter/material.dart';

import 'package:clipo/models/animation_settings.dart';
import 'package:clipo/models/quick_action.dart';
import 'package:clipo/widgets/action_tile.dart';

/// The 11 quick actions laid out 4 per row, as in the reference design.
///
/// Rows appear one after another from the bottom up, so the grid looks like
/// it grows out of the bar. Every row reuses the bar's duration and curve.
class ActionGrid extends StatelessWidget {
  const ActionGrid({
    super.key,
    required this.visible,
    required this.settings,
    required this.onAction,
  });

  static const int columns = 4;

  final bool visible;
  final AnimationSettings settings;
  final ValueChanged<QuickAction> onAction;

  @override
  Widget build(BuildContext context) {
    final rows = <List<QuickAction>>[
      for (var i = 0; i < quickActions.length; i += columns)
        quickActions.sublist(i, (i + columns).clamp(0, quickActions.length)),
    ];

    return IgnorePointer(
      ignoring: !visible,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(6, 14, 6, 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (var r = 0; r < rows.length; r++)
              _StaggeredRow(
                visible: visible,
                settings: settings,
                // 0 for the bottom row, which appears first.
                orderFromBottom: rows.length - 1 - r,
                child: Row(
                  children: [
                    // Each column gets an equal share of the panel's width.
                    for (var c = 0; c < columns; c++)
                      Expanded(
                        child: c < rows[r].length
                            ? ActionTile(
                                action: rows[r][c],
                                onTap: () => onAction(rows[r][c]),
                              )
                            : const SizedBox.shrink(),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _StaggeredRow extends StatelessWidget {
  const _StaggeredRow({
    required this.visible,
    required this.settings,
    required this.orderFromBottom,
    required this.child,
  });

  final bool visible;
  final AnimationSettings settings;
  final int orderFromBottom;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // Opening: wait until the panel has grown a little, then start each
    // row slightly later than the one below it.
    // Closing: every row fades out quickly, before the bar shrinks.
    final start = visible ? 0.2 + 0.12 * orderFromBottom : 0.0;
    final end = visible ? 1.0 : 0.35;

    return AnimatedOpacity(
      duration: settings.duration,
      // Opacity must stay between 0 and 1, so it never uses overshooting
      // curves like easeOutBack.
      curve: Interval(start, end, curve: Curves.easeOut),
      opacity: visible ? 1 : 0,
      child: AnimatedScale(
        duration: settings.duration,
        curve: Interval(start, end, curve: settings.curve),
        scale: visible ? 1 : 0.9,
        child: AnimatedSlide(
          duration: settings.duration,
          curve: Interval(start, end, curve: settings.curve),
          offset: visible ? Offset.zero : const Offset(0, 0.15),
          child: child,
        ),
      ),
    );
  }
}
