import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:clipo/models/animation_settings.dart';
import 'package:clipo/theme/app_colors.dart';

/// The round button beside the bar. Its + turns 45° into an × when open.
class ToggleButton extends StatefulWidget {
  const ToggleButton({
    super.key,
    required this.isOpen,
    required this.settings,
    required this.onPressed,
  });

  final bool isOpen;
  final AnimationSettings settings;
  final VoidCallback onPressed;

  @override
  State<ToggleButton> createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final label = widget.isOpen ? 'Close quick actions' : 'Open quick actions';

    return Semantics(
      button: true,
      label: label,
      child: Tooltip(
        message: label,
        child: GestureDetector(
          onTapDown: (_) => setState(() => _pressed = true),
          onTapCancel: () => setState(() => _pressed = false),
          onTapUp: (_) => setState(() => _pressed = false),
          onTap: () {
            HapticFeedback.lightImpact();
            widget.onPressed();
          },
          child: AnimatedScale(
            duration: const Duration(milliseconds: 120),
            scale: _pressed ? 0.9 : 1,
            child: Container(
              width: AppSizes.barHeight,
              height: AppSizes.barHeight,
              decoration: BoxDecoration(
                color: AppColors.glass,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.glassBorder),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x66000000),
                    blurRadius: 24,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              // Uses the same duration and curve as the bar so they move
              // together; 0.125 turns = 45°.
              child: AnimatedRotation(
                duration: widget.settings.duration,
                curve: widget.settings.curve,
                turns: widget.isOpen ? 0.125 : 0,
                child: const Icon(
                  LucideIcons.plus,
                  size: 24,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
