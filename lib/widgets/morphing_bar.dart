import 'package:flutter/material.dart';

import 'package:clipo/models/animation_settings.dart';
import 'package:clipo/theme/app_colors.dart';

/// The bottom bar that grows into the quick-actions panel.
///
/// This is the AnimatedContainer being presented. We never write animation
/// code here: when [isOpen] flips, we hand AnimatedContainer a new `height`
/// and `decoration`, and it animates from the old values to the new ones
/// on its own, using the `duration` and `curve` we pass in.
class MorphingBar extends StatelessWidget {
  const MorphingBar({
    super.key,
    required this.isOpen,
    required this.settings,
    required this.navigation,
    required this.actions,
  });

  final bool isOpen;
  final AnimationSettings settings;

  /// Shown when the bar is closed (the 4 nav icons).
  final Widget navigation;

  /// Shown when the bar is open (the quick-actions grid).
  final Widget actions;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      key: const Key('morphing-bar'),

      // Property 1 – duration: how long the bar takes to change shape.
      duration: settings.duration,

      // Property 2 – curve: how the speed changes along the way
      // (linear = constant speed, easeOutBack = overshoots and settles).
      curve: settings.curve,

      // The value that actually changes: a short pill or a tall panel.
      height: isOpen ? AppSizes.panelHeight : AppSizes.barHeight,

      // Property 3 – decoration: the pill's fill, border and rounded
      // corners. null (the default) paints nothing, so only the icons show.
      decoration: settings.useDecoration
          ? BoxDecoration(
              color: isOpen ? AppColors.glassOpen : AppColors.glass,
              borderRadius: BorderRadius.circular(
                isOpen ? AppSizes.panelRadius : AppSizes.barHeight / 2,
              ),
              border: Border.all(color: AppColors.glassBorder),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x66000000),
                  blurRadius: 24,
                  offset: Offset(0, 8),
                ),
              ],
            )
          : null,

      // Keep the content inside the rounded shape while it grows.
      clipBehavior: settings.useDecoration ? Clip.antiAlias : Clip.none,
      child: ClipRect(
        child: Stack(
          children: [
            // The grid is always laid out at full panel size and pinned to
            // the bottom, so the growing bar reveals it instead of squeezing
            // it (no overflow stripes, even at slow durations).
            Positioned.fill(
              child: OverflowBox(
                alignment: Alignment.bottomCenter,
                minHeight: AppSizes.panelHeight,
                maxHeight: AppSizes.panelHeight,
                child: actions,
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: AppSizes.barHeight,
              child: navigation,
            ),
          ],
        ),
      ),
    );
  }
}
