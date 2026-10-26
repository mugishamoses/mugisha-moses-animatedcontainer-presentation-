import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:clipo/models/animation_settings.dart';
import 'package:clipo/theme/app_colors.dart';

class NavTab {
  const NavTab(this.label, this.icon);

  final String label;
  final IconData icon;
}

const List<NavTab> navTabs = [
  NavTab('Home', LucideIcons.house),
  NavTab('Inbox', LucideIcons.inbox),
  NavTab('Notifications', LucideIcons.bell),
  NavTab('Library', LucideIcons.layers),
];

/// The 4 icons inside the closed bar, with a highlight that slides to the
/// selected one. They fade away while the bar opens.
class NavIcons extends StatelessWidget {
  const NavIcons({
    super.key,
    required this.selected,
    required this.onSelected,
    required this.hidden,
    required this.settings,
  });

  final int selected;
  final ValueChanged<int> onSelected;
  final bool hidden;
  final AnimationSettings settings;

  @override
  Widget build(BuildContext context) {
    // Fade out early when opening, fade back in late when closing,
    // so the icons never overlap the grid.
    final fadeCurve = hidden
        ? const Interval(0, 0.35, curve: Curves.easeOut)
        : const Interval(0.55, 1, curve: Curves.easeOut);

    return IgnorePointer(
      ignoring: hidden,
      child: AnimatedOpacity(
        duration: settings.duration,
        curve: fadeCurve,
        opacity: hidden ? 0 : 1,
        child: AnimatedSlide(
          duration: settings.duration,
          curve: fadeCurve,
          offset: hidden ? const Offset(0, 0.25) : Offset.zero,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Stack(
              children: [
                // Sliding highlight behind the selected icon.
                AnimatedAlign(
                  duration: const Duration(milliseconds: 280),
                  curve: Curves.easeOutCubic,
                  alignment: Alignment(
                    -1 + 2 * selected / (navTabs.length - 1),
                    0,
                  ),
                  child: FractionallySizedBox(
                    widthFactor: 1 / navTabs.length,
                    heightFactor: 1,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.highlight,
                        borderRadius: BorderRadius.circular(AppSizes.barHeight),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    for (var i = 0; i < navTabs.length; i++)
                      Expanded(
                        child: _NavButton(
                          tab: navTabs[i],
                          selected: i == selected,
                          showDot: i == 2,
                          onTap: () {
                            HapticFeedback.selectionClick();
                            onSelected(i);
                          },
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.tab,
    required this.selected,
    required this.showDot,
    required this.onTap,
  });

  final NavTab tab;
  final bool selected;
  final bool showDot;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: tab.label,
      child: Tooltip(
        message: tab.label,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Center(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: selected ? 1 : 0.8,
                  child: Icon(tab.icon, size: 22, color: Colors.white),
                ),
                if (showDot)
                  const Positioned(top: -1, right: -1, child: _PulsingDot()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Unread dot on the bell. It pops in with a small bounce on launch.
class _PulsingDot extends StatelessWidget {
  const _PulsingDot();

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 900),
      curve: Curves.elasticOut,
      builder: (_, scale, child) => Transform.scale(scale: scale, child: child),
      child: Container(
        width: 7,
        height: 7,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.surface, width: 1.2),
        ),
      ),
    );
  }
}
