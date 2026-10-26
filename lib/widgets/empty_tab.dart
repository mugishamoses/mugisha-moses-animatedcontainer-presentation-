import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:clipo/theme/app_colors.dart';

/// Placeholder content for the Inbox, Notifications and Library tabs.
class EmptyTab extends StatelessWidget {
  const EmptyTab({super.key, required this.tab});

  final int tab;

  static const _content = {
    1: (
      LucideIcons.inbox,
      'No messages yet',
      'Comments on shared videos show up here.',
    ),
    2: (
      LucideIcons.bell,
      'You’re all caught up',
      'We’ll let you know when an export finishes.',
    ),
    3: (
      LucideIcons.layers,
      'Library is empty',
      'Exported videos will appear here.',
    ),
  };

  @override
  Widget build(BuildContext context) {
    final (icon, title, subtitle) = _content[tab]!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 120, 40, 0),
      child: Column(
        children: [
          Icon(icon, size: 40, color: AppColors.textTertiary),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
