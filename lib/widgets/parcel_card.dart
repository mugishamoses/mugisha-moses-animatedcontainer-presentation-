import 'package:flutter/material.dart';

import 'package:parcel_tracker/models/animation_settings.dart';
import 'package:parcel_tracker/models/parcel.dart';

/// A parcel summary that grows to show the delivery timeline when tapped.
///
/// This is the AnimatedContainer being demonstrated. We never write any
/// animation code ourselves: we only change `height` and `decoration`
/// inside setState, and AnimatedContainer animates from the old values to
/// the new ones using the `duration` and `curve` we give it.
class ParcelCard extends StatelessWidget {
  const ParcelCard({
    super.key,
    required this.parcel,
    required this.expanded,
    required this.settings,
    required this.onTap,
  });

  static const double collapsedHeight = 84;
  static const double expandedHeight = 300;

  final Parcel parcel;
  final bool expanded;
  final AnimationSettings settings;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        key: ValueKey('card-${parcel.trackingId}'),
        // Property 1 – duration: how long the change takes.
        duration: settings.duration,
        // Property 2 – curve: how the speed changes during the animation.
        curve: settings.curve,
        height: expanded ? expandedHeight : collapsedHeight,
        padding: const EdgeInsets.all(16),
        // Property 3 – decoration: background, corners and shadow.
        // null (the default) paints nothing behind the content.
        decoration: settings.useDecoration
            ? BoxDecoration(
                color: expanded ? colors.primaryContainer : colors.surface,
                borderRadius: BorderRadius.circular(expanded ? 24 : 12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: expanded ? 0.18 : 0.08),
                    blurRadius: expanded ? 16 : 4,
                    offset: const Offset(0, 4),
                  ),
                ],
              )
            : null,
        // Hide whatever doesn't fit while the card is still small.
        clipBehavior: settings.useDecoration ? Clip.antiAlias : Clip.none,
        child: ClipRect(
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Summary(parcel: parcel, expanded: expanded),
                const SizedBox(height: 16),
                _Details(parcel: parcel),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary({required this.parcel, required this.expanded});

  final Parcel parcel;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        const Icon(Icons.local_shipping_outlined, size: 32),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(parcel.title, style: textTheme.titleMedium),
              Text('${parcel.status} · ${parcel.trackingId}',
                  style: textTheme.bodySmall),
            ],
          ),
        ),
        Icon(expanded ? Icons.expand_less : Icons.expand_more),
      ],
    );
  }
}

class _Details extends StatelessWidget {
  const _Details({required this.parcel});

  final Parcel parcel;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(parcel.eta, style: textTheme.titleSmall),
        Text('Courier: ${parcel.courier}', style: textTheme.bodySmall),
        const SizedBox(height: 8),
        for (final step in parcel.steps)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              children: [
                Icon(
                  step.done ? Icons.check_circle : Icons.radio_button_unchecked,
                  size: 18,
                  color: step.done ? Colors.green : Colors.grey,
                ),
                const SizedBox(width: 8),
                Expanded(child: Text(step.label)),
                Text(step.time, style: textTheme.bodySmall),
              ],
            ),
          ),
      ],
    );
  }
}
