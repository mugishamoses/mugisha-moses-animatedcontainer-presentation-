import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:clipo/models/animation_settings.dart';
import 'package:clipo/models/project.dart';
import 'package:clipo/models/quick_action.dart';
import 'package:clipo/theme/app_colors.dart';
import 'package:clipo/widgets/action_grid.dart';
import 'package:clipo/widgets/empty_tab.dart';
import 'package:clipo/widgets/morphing_bar.dart';
import 'package:clipo/widgets/nav_icons.dart';
import 'package:clipo/widgets/playground_panel.dart';
import 'package:clipo/widgets/recent_projects.dart';
import 'package:clipo/widgets/toggle_button.dart';

/// Home screen of the Clipo video editor.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tab = 0;

  /// The single piece of state that drives the whole morph.
  bool _isOpen = false;

  /// The "Tap + for quick actions" hint disappears after the first use.
  bool _hasOpenedOnce = false;

  /// The three AnimatedContainer properties, edited live in the playground.
  AnimationSettings _settings = AnimationSettings.polished;

  bool _playgroundOpen = false;
  bool _replaying = false;

  void _setOpen(bool open) {
    setState(() {
      _isOpen = open;
      if (open) _hasOpenedOnce = true;
    });
  }

  /// Opens the bar, holds it open briefly, then closes it again, so the
  /// presenter can talk while the class watches the animation.
  Future<void> _replay() async {
    setState(() => _replaying = true);
    _setOpen(false);
    await Future<void>.delayed(const Duration(milliseconds: 150));
    if (!mounted) return;
    _setOpen(true);
    await Future<void>.delayed(
      _settings.duration + const Duration(milliseconds: 900),
    );
    if (!mounted) return;
    _setOpen(false);
    await Future<void>.delayed(_settings.duration);
    if (mounted) setState(() => _replaying = false);
  }

  void _runAction(QuickAction action) {
    _setOpen(false);
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          // Float just above the bar.
          margin: EdgeInsets.fromLTRB(
            AppSizes.barSideMargin,
            0,
            AppSizes.barSideMargin,
            bottomInset + AppSizes.barBottomMargin + AppSizes.barHeight + 12,
          ),
          content: Text('${action.message} · ${recentProjects.first.title}'),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final barBottom = bottomInset + AppSizes.barBottomMargin;

    // Android back button closes the panel before leaving the app.
    return PopScope(
      canPop: !_isOpen,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _setOpen(false);
      },
      child: Scaffold(
        body: Stack(
          children: [
            SafeArea(
              bottom: false,
              child: Column(
                children: [
                  SizedBox(
                    height: 52,
                    width: double.infinity,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: Text(
                            navTabs[_tab].label,
                            key: ValueKey(_tab),
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 16,
                          child: _TuneButton(
                            active: _playgroundOpen,
                            onTap: () => setState(
                              () => _playgroundOpen = !_playgroundOpen,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: KeyedSubtree(
                        key: ValueKey(_tab),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: _tab == 0
                              ? const RecentProjects()
                              : EmptyTab(tab: _tab),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // First-run hint above the + button.
            Positioned(
              right: AppSizes.barSideMargin,
              bottom: barBottom + AppSizes.barHeight + 14,
              child: IgnorePointer(
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: _hasOpenedOnce ? 0 : 1,
                  child: const Text(
                    'Tap + for quick actions',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ),
              ),
            ),

            // Dims the screen behind the open panel; tapping it closes.
            Positioned.fill(
              child: IgnorePointer(
                ignoring: !_isOpen,
                child: GestureDetector(
                  onTap: () => _setOpen(false),
                  child: AnimatedOpacity(
                    duration: _settings.duration,
                    curve: Curves.easeOut,
                    opacity: _isOpen ? 1 : 0,
                    child: const ColoredBox(color: AppColors.scrim),
                  ),
                ),
              ),
            ),

            // Drops down from the top so the bar stays visible below it.
            Positioned(
              top: MediaQuery.paddingOf(context).top + 52,
              left: 16,
              right: 16,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight:
                      (MediaQuery.sizeOf(context).height -
                              MediaQuery.paddingOf(context).top -
                              52 -
                              barBottom -
                              AppSizes.panelHeight -
                              16)
                          .clamp(160, double.infinity),
                ),
                child: IgnorePointer(
                  ignoring: !_playgroundOpen,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 220),
                    opacity: _playgroundOpen ? 1 : 0,
                    child: AnimatedSlide(
                      duration: const Duration(milliseconds: 280),
                      curve: Curves.easeOutCubic,
                      offset: _playgroundOpen
                          ? Offset.zero
                          : const Offset(0, -0.04),
                      child: PlaygroundPanel(
                        settings: _settings,
                        replaying: _replaying,
                        onChanged: (s) => setState(() => _settings = s),
                        onReplay: _replay,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Positioned(
              left: AppSizes.barSideMargin,
              right: AppSizes.barSideMargin,
              bottom: barBottom,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: MorphingBar(
                      isOpen: _isOpen,
                      settings: _settings,
                      navigation: NavIcons(
                        selected: _tab,
                        hidden: _isOpen,
                        settings: _settings,
                        onSelected: (i) => setState(() => _tab = i),
                      ),
                      actions: ActionGrid(
                        visible: _isOpen,
                        settings: _settings,
                        onAction: _runAction,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSizes.toggleGap),
                  ToggleButton(
                    isOpen: _isOpen,
                    settings: _settings,
                    onPressed: () => _setOpen(!_isOpen),
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

/// Round button in the header that opens the animation playground.
class _TuneButton extends StatelessWidget {
  const _TuneButton({required this.active, required this.onTap});

  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Animation playground',
      child: Semantics(
        button: true,
        label: 'Animation playground',
        child: GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: active ? Colors.white : AppColors.highlight,
              shape: BoxShape.circle,
            ),
            child: Icon(
              LucideIcons.slidersHorizontal,
              size: 17,
              color: active ? Colors.black : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
