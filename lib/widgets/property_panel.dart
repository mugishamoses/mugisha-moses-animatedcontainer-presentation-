import 'package:flutter/material.dart';

import 'package:parcel_tracker/models/animation_settings.dart';

/// Controls for changing duration, curve and decoration while the app runs.
class PropertyPanel extends StatelessWidget {
  const PropertyPanel({
    super.key,
    required this.settings,
    required this.onChanged,
    required this.onReset,
  });

  final AnimationSettings settings;
  final ValueChanged<AnimationSettings> onChanged;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: colors.surfaceContainerHigh,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text('AnimatedContainer properties',
                        style: textTheme.titleSmall,
                        overflow: TextOverflow.ellipsis),
                  ),
                  TextButton.icon(
                    key: const Key('reset'),
                    onPressed: onReset,
                    icon: const Icon(Icons.restart_alt),
                    label: const Text('Reset'),
                  ),
                ],
              ),
              // 1. duration
              Text('duration: ${settings.durationMs} ms'),
              Slider(
                key: const Key('duration-slider'),
                min: 100,
                max: 2000,
                divisions: 19,
                value: settings.durationMs.toDouble(),
                onChanged: (v) =>
                    onChanged(settings.copyWith(durationMs: v.round())),
              ),
              // 2. curve
              const Text('curve'),
              Wrap(
                spacing: 6,
                children: [
                  for (var i = 0; i < curveOptions.length; i++)
                    ChoiceChip(
                      label: Text(curveOptions[i].name),
                      selected: settings.curveIndex == i,
                      onSelected: (_) =>
                          onChanged(settings.copyWith(curveIndex: i)),
                    ),
                ],
              ),
              // 3. decoration
              SwitchListTile(
                key: const Key('decoration-switch'),
                contentPadding: EdgeInsets.zero,
                dense: true,
                title: Text(settings.useDecoration
                    ? 'decoration: BoxDecoration'
                    : 'decoration: null (default)'),
                value: settings.useDecoration,
                onChanged: (v) =>
                    onChanged(settings.copyWith(useDecoration: v)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
