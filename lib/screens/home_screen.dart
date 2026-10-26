import 'package:flutter/material.dart';

import 'package:clipo/models/animation_settings.dart';
import 'package:clipo/theme/app_colors.dart';
import 'package:clipo/models/quick_action.dart';
import 'package:clipo/widgets/action_grid.dart';
import 'package:clipo/widgets/morphing_bar.dart';
import 'package:clipo/widgets/nav_icons.dart';
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
  final AnimationSettings _settings = AnimationSettings.polished;

  void _toggle() => setState(() => _isOpen = !_isOpen);

  void _runAction(QuickAction action) {
    setState(() => _isOpen = false);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                SizedBox(
                  height: 52,
                  child: Center(
                    child: Text(
                      navTabs[_tab].label,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                if (_tab == 0) const RecentProjects(),
              ],
            ),
          ),
          Positioned(
            left: AppSizes.barSideMargin,
            right: AppSizes.barSideMargin,
            bottom: bottomInset + AppSizes.barBottomMargin,
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
                  onPressed: _toggle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
