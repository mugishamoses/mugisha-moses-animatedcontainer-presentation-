import 'package:flutter/material.dart';

import 'package:brew_lane/models/app_bar_color_option.dart';

/// Font family Android maps to its system monospace font.
const String _monospace = 'monospace';

/// Live controls for the AppBar properties this app demonstrates. Each row
/// shows the value currently passed to the AppBar's constructor.
class PropertyPanel extends StatelessWidget {
  const PropertyPanel({
    super.key,
    required this.colorOption,
    required this.onColorOptionChanged,
  });

  final AppBarColorOption colorOption;
  final ValueChanged<AppBarColorOption> onColorOptionChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.surfaceContainerHigh,
      elevation: 8,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: kMinInteractiveDimension,
              child: Row(
                children: [
                  Icon(Icons.tune, size: 20, color: theme.colorScheme.primary),
                  const SizedBox(width: 8),
                  Text('AppBar properties', style: theme.textTheme.titleSmall),
                ],
              ),
            ),
            _PropertyRow(
              number: 1,
              name: 'backgroundColor',
              value: _codeValue(
                colorOption.backgroundCode,
                whenNull: 'surface',
              ),
              control: _ColorSwatchPicker(
                selected: colorOption,
                onSelected: onColorOptionChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Shows a value the way it appears in code and, when it is null, what the
  /// AppBar falls back to.
  static String _codeValue(Object? value, {required String whenNull}) =>
      value == null ? 'null → $whenNull' : '$value';
}

/// One property: numbered name, current value and the control that changes it.
class _PropertyRow extends StatelessWidget {
  const _PropertyRow({
    required this.number,
    required this.name,
    required this.value,
    required this.control,
  });

  final int number;
  final String name;
  final String value;
  final Widget control;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 10,
                backgroundColor: colors.primary,
                child: Text(
                  '$number',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colors.onPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                name,
                style: const TextStyle(
                  fontFamily: _monospace,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: _CodeChip(value),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          control,
        ],
      ),
    );
  }
}

/// Small monospace label showing a value as source code.
class _CodeChip extends StatelessWidget {
  const _CodeChip(this.code);

  final String code;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.secondaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        child: Text(
          code,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: _monospace,
            fontSize: 12,
            color: colors.onSecondaryContainer,
          ),
        ),
      ),
    );
  }
}

/// Row of colour swatches, one per [AppBarColorOption]. Each swatch takes an
/// equal share of the width, so the row fits any screen without wrapping.
class _ColorSwatchPicker extends StatelessWidget {
  const _ColorSwatchPicker({required this.selected, required this.onSelected});

  final AppBarColorOption selected;
  final ValueChanged<AppBarColorOption> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      children: [
        for (final option in AppBarColorOption.values)
          Expanded(
            child: _ColorSwatch(
              label: option.label,
              // The default swatch previews what the AppBar falls back to.
              color: option.background ?? colors.surface,
              checkColor: option.foreground ?? colors.onSurface,
              isSelected: option == selected,
              onTap: () => onSelected(option),
            ),
          ),
      ],
    );
  }
}

class _ColorSwatch extends StatelessWidget {
  const _ColorSwatch({
    required this.label,
    required this.color,
    required this.checkColor,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final Color color;
  final Color checkColor;
  final bool isSelected;
  final VoidCallback onTap;

  static const double _size = 36;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Semantics(
      button: true,
      selected: isSelected,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            children: [
              Container(
                width: _size,
                height: _size,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? colors.primary : colors.outlineVariant,
                    width: isSelected ? 3 : 1,
                  ),
                ),
                child: isSelected
                    ? Icon(Icons.check, size: 18, color: checkColor)
                    : null,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
