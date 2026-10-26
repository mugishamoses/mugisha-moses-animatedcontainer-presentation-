import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// One button in the quick-actions panel.
class QuickAction {
  const QuickAction({required this.label, required this.message, this.icon});

  final String label;

  /// Shown in a snackbar after tapping, so every action visibly does something.
  final String message;

  /// null means the tile draws the "Aa" glyph instead of an icon (Text).
  final IconData? icon;
}

/// The 11 actions from the reference design, in the same order.
const List<QuickAction> quickActions = [
  QuickAction(
    label: 'Trim',
    icon: LucideIcons.scissors,
    message: 'Trim tool opened',
  ),
  QuickAction(
    label: 'Crop',
    icon: LucideIcons.crop,
    message: 'Crop tool opened',
  ),
  QuickAction(
    label: 'Enhance',
    icon: LucideIcons.wandSparkles,
    message: 'Auto-enhance applied',
  ),
  QuickAction(label: 'Text', message: 'Text layer added'),
  QuickAction(
    label: 'Audio',
    icon: LucideIcons.music,
    message: 'Audio library opened',
  ),
  QuickAction(
    label: 'Speed',
    icon: LucideIcons.rabbit,
    message: 'Speed set to 2×',
  ),
  QuickAction(
    label: 'Duplicate',
    icon: LucideIcons.copy,
    message: 'Clip duplicated',
  ),
  QuickAction(
    label: 'Undo',
    icon: LucideIcons.undo2,
    message: 'Last edit undone',
  ),
  QuickAction(
    label: 'Share',
    icon: LucideIcons.share,
    message: 'Share sheet opened',
  ),
  QuickAction(
    label: 'Save',
    icon: LucideIcons.bookmark,
    message: 'Saved to drafts',
  ),
  QuickAction(
    label: 'Delete',
    icon: LucideIcons.trash2,
    message: 'Clip moved to trash',
  ),
];
