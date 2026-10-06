import 'package:flutter/material.dart';

import 'package:brew_lane/models/app_bar_color_option.dart';

/// Font family Android maps to its system monospace font.
const String _monospace = 'monospace';

/// Live controls for the three AppBar properties this app demonstrates. Each
/// row shows the value currently passed to the AppBar's constructor.
class PropertyPanel extends StatefulWidget {
  const PropertyPanel({
    super.key,
    required this.maxHeight,
    required this.colorOption,
    required this.centerTitle,
    required this.toolbarHeight,
    required this.onColorOptionChanged,
    required this.onCenterTitleChanged,
    required this.onToolbarHeightChanged,
    required this.onReset,
  });

  /// Smallest toolbarHeight offered: just enough for a 48 dp touch target.
  static const double minToolbarHeight = 48;

  /// Largest toolbarHeight offered: tall enough to make the effect obvious.
  static const double maxToolbarHeight = 128;

  /// Slider step. 8 dp follows the Material spacing grid and makes the
  /// default of 56 dp one of the stops.
  static const double toolbarHeightStep = 8;

  /// The panel never grows taller than this; extra content scrolls instead.
  final double maxHeight;

  final AppBarColorOption colorOption;
  final bool? centerTitle;
  final double? toolbarHeight;
  final ValueChanged<AppBarColorOption> onColorOptionChanged;
  final ValueChanged<bool?> onCenterTitleChanged;
  final ValueChanged<double> onToolbarHeightChanged;
  final VoidCallback onReset;

  @override
  State<PropertyPanel> createState() => _PropertyPanelState();
}

class _PropertyPanelState extends State<PropertyPanel> {
  bool _isExpanded = true;

  static const Duration _expandDuration = Duration(milliseconds: 250);

  bool get _allDefaults =>
      widget.colorOption == AppBarColorOption.themeDefault &&
      widget.centerTitle == null &&
      widget.toolbarHeight == null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.surfaceContainerHigh,
      elevation: 8,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: widget.maxHeight),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(theme),
            Flexible(
              child: AnimatedSize(
                duration: _expandDuration,
                curve: Curves.easeOutCubic,
                alignment: Alignment.topCenter,
                child: _isExpanded
                    ? _buildPropertyRows()
                    : const SizedBox(width: double.infinity),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 4, 0),
      child: Row(
        children: [
          Icon(Icons.tune, size: 20, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text('AppBar properties', style: theme.textTheme.titleSmall),
          ),
          TextButton.icon(
            onPressed: _allDefaults ? null : widget.onReset,
            icon: const Icon(Icons.restart_alt, size: 18),
            label: const Text('Reset'),
          ),
          IconButton(
            tooltip: _isExpanded ? 'Hide properties' : 'Show properties',
            onPressed: () => setState(() => _isExpanded = !_isExpanded),
            icon: Icon(_isExpanded ? Icons.expand_more : Icons.expand_less),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyRows() {
    final effectiveHeight = widget.toolbarHeight ?? kToolbarHeight;

    // Swallow the panel's own scroll notifications: the AppBar listens for
    // scrolling to switch to its "scrolled under" look, and only the menu
    // should trigger that.
    return NotificationListener<ScrollNotification>(
      onNotification: (_) => true,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _PropertyRow(
              number: 1,
              name: 'backgroundColor',
              value: _codeValue(
                widget.colorOption.backgroundCode,
                whenNull: 'surface',
              ),
              control: _ColorSwatchPicker(
                selected: widget.colorOption,
                onSelected: widget.onColorOptionChanged,
              ),
            ),
            _PropertyRow(
              number: 2,
              name: 'centerTitle',
              value: _codeValue(widget.centerTitle, whenNull: 'platform'),
              control: SegmentedButton<bool?>(
                expandedInsets: EdgeInsets.zero,
                showSelectedIcon: false,
                segments: const [
                  ButtonSegment(value: null, label: Text('Default')),
                  ButtonSegment(value: false, label: Text('Start')),
                  ButtonSegment(value: true, label: Text('Center')),
                ],
                selected: {widget.centerTitle},
                onSelectionChanged: (selection) =>
                    widget.onCenterTitleChanged(selection.single),
              ),
            ),
            _PropertyRow(
              number: 3,
              name: 'toolbarHeight',
              value: _codeValue(
                widget.toolbarHeight,
                whenNull: '$kToolbarHeight',
              ),
              control: Slider(
                min: PropertyPanel.minToolbarHeight,
                max: PropertyPanel.maxToolbarHeight,
                divisions:
                    (PropertyPanel.maxToolbarHeight -
                        PropertyPanel.minToolbarHeight) ~/
                    PropertyPanel.toolbarHeightStep,
                value: effectiveHeight,
                label: effectiveHeight.toStringAsFixed(0),
                onChanged: widget.onToolbarHeightChanged,
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
