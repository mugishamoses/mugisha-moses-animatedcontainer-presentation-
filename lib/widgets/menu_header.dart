import 'package:flutter/material.dart';

/// Greeting and pickup details shown above the menu.
class MenuHeader extends StatelessWidget {
  const MenuHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mutedColor = theme.colorScheme.onSurfaceVariant;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What are you craving?',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.storefront_outlined, size: 18, color: mutedColor),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Pickup at Kimihurura · ready in about 10 min',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: mutedColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
