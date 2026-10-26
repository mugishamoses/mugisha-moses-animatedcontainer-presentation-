import 'package:flutter/material.dart';

import 'package:clipo/models/animation_settings.dart';
import 'package:clipo/models/quick_action.dart';
import 'package:clipo/widgets/action_tile.dart';

/// The 11 quick actions laid out 4 per row, as in the reference design.
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
      child: AnimatedOpacity(
        duration: settings.duration,
        opacity: visible ? 1 : 0,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(6, 14, 6, 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (final row in rows)
                Row(
                  children: [
                    // Each column gets an equal share of the panel's width.
                    for (var c = 0; c < columns; c++)
                      Expanded(
                        child: c < row.length
                            ? ActionTile(
                                action: row[c],
                                onTap: () => onAction(row[c]),
                              )
                            : const SizedBox.shrink(),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
