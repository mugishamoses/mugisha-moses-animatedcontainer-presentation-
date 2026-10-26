import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:clipo/models/animation_settings.dart';
import 'package:clipo/theme/app_colors.dart';
import 'package:clipo/widgets/curve_preview.dart';

/// Controls for changing AnimatedContainer's duration, curve and
/// decoration while the app runs. It drops down from the top so the
/// bar at the bottom stays visible during the demo.
class PlaygroundPanel extends StatelessWidget {
  const PlaygroundPanel({
    super.key,
    required this.settings,
    required this.onChanged,
    required this.onReplay,
    required this.replaying,
  });

  final AnimationSettings settings;
  final ValueChanged<AnimationSettings> onChanged;
  final VoidCallback onReplay;
  final bool replaying;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.glassBorder),
        boxShadow: const [
          BoxShadow(
            color: Color(0x99000000),
            blurRadius: 32,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(
              onChanged: onChanged,
              onReplay: onReplay,
              replaying: replaying,
            ),
            const SizedBox(height: 10),
            _CodeLine(settings: settings),
            const SizedBox(height: 12),
            _DurationControl(settings: settings, onChanged: onChanged),
            const SizedBox(height: 8),
            _CurveControl(settings: settings, onChanged: onChanged),
            const SizedBox(height: 10),
            _DecorationControl(settings: settings, onChanged: onChanged),
          ],
        ),
      ),
    );
  }
}

/// Title plus the Reset, Polished and Replay buttons.
class _Header extends StatelessWidget {
  const _Header({
    required this.onChanged,
    required this.onReplay,
    required this.replaying,
  });

  final ValueChanged<AnimationSettings> onChanged;
  final VoidCallback onReplay;
  final bool replaying;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Playground',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
          ),
        ),
        _RoundIconButton(
          key: const Key('reset'),
          icon: LucideIcons.rotateCcw,
          tooltip: 'Reset to Flutter defaults',
          onTap: () => onChanged(AnimationSettings.flutterDefaults),
        ),
        const SizedBox(width: 8),
        _RoundIconButton(
          key: const Key('polished'),
          icon: LucideIcons.sparkles,
          tooltip: 'Polished preset',
          onTap: () => onChanged(AnimationSettings.polished),
        ),
        const SizedBox(width: 8),
        _PillButton(
          key: const Key('replay'),
          icon: LucideIcons.play,
          label: replaying ? 'Playing' : 'Replay',
          filled: true,
          onTap: replaying ? null : onReplay,
        ),
      ],
    );
  }
}

/// The constructor call as it currently runs, so the class can match the
/// code to what they see.
class _CodeLine extends StatelessWidget {
  const _CodeLine({required this.settings});

  final AnimationSettings settings;

  @override
  Widget build(BuildContext context) {
    const base = TextStyle(
      fontFamily: 'JetBrainsMono',
      fontSize: 11.5,
      height: 1.3,
      color: AppColors.textSecondary,
    );
    const value = TextStyle(color: Colors.white, fontWeight: FontWeight.w600);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF0E0E10),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text.rich(
        key: const Key('code-line'),
        TextSpan(
          style: base,
          children: [
            const TextSpan(text: 'AnimatedContainer(\n  duration: '),
            TextSpan(text: '${settings.durationMs}ms', style: value),
            const TextSpan(text: ',\n  curve: Curves.'),
            TextSpan(text: settings.curveName, style: value),
            const TextSpan(text: ',\n  decoration: '),
            TextSpan(
              text: settings.useDecoration ? 'BoxDecoration(…)' : 'null',
              style: value,
            ),
            const TextSpan(text: ',\n)'),
          ],
        ),
      ),
    );
  }
}

class _DurationControl extends StatelessWidget {
  const _DurationControl({required this.settings, required this.onChanged});

  final AnimationSettings settings;
  final ValueChanged<AnimationSettings> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Expanded(
              child: _PropertyLabel(name: 'duration', note: 'required'),
            ),
            const SizedBox(width: 8),
            Text(
              '${settings.durationMs} ms',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                fontFeatures: [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context)
              .copyWith(overlayShape: SliderComponentShape.noOverlay),
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Slider(
              key: const Key('duration-slider'),
              min: 100,
              max: 2000,
              divisions: 38,
              value: settings.durationMs.toDouble(),
              onChanged: (v) =>
                  onChanged(settings.copyWith(durationMs: v.round())),
            ),
          ),
        ),
      ],
    );
  }
}

class _CurveControl extends StatelessWidget {
  const _CurveControl({required this.settings, required this.onChanged});

  final AnimationSettings settings;
  final ValueChanged<AnimationSettings> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _PropertyLabel(name: 'curve', note: 'default: linear'),
        const SizedBox(height: 10),
        Row(
          children: [
            for (var i = 0; i < curveOptions.length; i++) ...[
              if (i > 0) const SizedBox(width: 8),
              Expanded(
                child: _SelectableCard(
                  key: Key('curve-${curveOptions[i].name}'),
                  selected: settings.curveIndex == i,
                  onTap: () => onChanged(settings.copyWith(curveIndex: i)),
                  child: Column(
                    children: [
                      CurvePreview(
                        curve: curveOptions[i].curve,
                        color: settings.curveIndex == i
                            ? Colors.black
                            : Colors.white,
                      ),
                      const SizedBox(height: 6),
                      FittedBox(
                        child: Text(
                          curveOptions[i].name,
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: settings.curveIndex == i
                                ? Colors.black
                                : Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _DecorationControl extends StatelessWidget {
  const _DecorationControl({required this.settings, required this.onChanged});

  final AnimationSettings settings;
  final ValueChanged<AnimationSettings> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _PropertyLabel(name: 'decoration', note: 'default: null'),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _SelectableCard(
                key: const Key('decoration-null'),
                selected: !settings.useDecoration,
                onTap: () => onChanged(settings.copyWith(useDecoration: false)),
                child: _DecorationOption(
                  label: 'null',
                  selected: !settings.useDecoration,
                  pill: false,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _SelectableCard(
                key: const Key('decoration-box'),
                selected: settings.useDecoration,
                onTap: () => onChanged(settings.copyWith(useDecoration: true)),
                child: _DecorationOption(
                  label: 'BoxDecoration',
                  selected: settings.useDecoration,
                  pill: true,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Mini picture of the bar: three dots, with or without the pill behind.
class _DecorationOption extends StatelessWidget {
  const _DecorationOption({
    required this.label,
    required this.selected,
    required this.pill,
  });

  final String label;
  final bool selected;
  final bool pill;

  @override
  Widget build(BuildContext context) {
    final fg = selected ? Colors.black : Colors.white;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 40,
          height: 16,
          decoration: pill
              ? BoxDecoration(
                  color: fg.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: fg.withValues(alpha: 0.35)),
                )
              : null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (var i = 0; i < 3; i++)
                Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(color: fg, shape: BoxShape.circle),
                ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: FittedBox(
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: fg,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PropertyLabel extends StatelessWidget {
  const _PropertyLabel({required this.name, required this.note});

  final String name;
  final String note;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: _labelRow(),
    );
  }

  Widget _labelRow() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          name,
          style: const TextStyle(
            fontFamily: 'JetBrainsMono',
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: AppColors.highlight,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            note,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

/// A card that turns white when selected.
class _SelectableCard extends StatelessWidget {
  const _SelectableCard({
    super.key,
    required this.selected,
    required this.onTap,
    required this.child,
  });

  final bool selected;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
          decoration: BoxDecoration(
            color: selected ? Colors.white : AppColors.tile,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? Colors.white : AppColors.glassBorder,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _PillButton extends StatelessWidget {
  const _PillButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.filled = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final fg = filled ? Colors.black : Colors.white;
    return Semantics(
      button: true,
      enabled: onTap != null,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 150),
          opacity: onTap == null ? 0.5 : 1,
          child: Container(
            height: 36,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: filled ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(19),
              border: Border.all(
                color: filled ? Colors.white : const Color(0x33FFFFFF),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 15, color: fg),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: fg,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Semantics(
        button: true,
        label: tooltip,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: AppColors.highlight,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 17, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
