import 'package:flutter/animation.dart';

/// A curve the presenter can pick in the property panel.
class CurveOption {
  const CurveOption(this.name, this.curve);

  final String name;
  final Curve curve;
}

/// `Curves.linear` comes first because it is AnimatedContainer's default.
const List<CurveOption> curveOptions = [
  CurveOption('linear (default)', Curves.linear),
  CurveOption('easeInOut', Curves.easeInOut),
  CurveOption('easeOutBack', Curves.easeOutBack),
  CurveOption('bounceOut', Curves.bounceOut),
];

/// The three AnimatedContainer properties being demonstrated.
///
/// The starting values match the widget's own defaults, so "Reset" always
/// shows how AnimatedContainer behaves out of the box:
/// - duration: required, no default; 300 ms is the usual Material value.
/// - curve: defaults to Curves.linear.
/// - decoration: defaults to null (no colour, border or shadow).
class AnimationSettings {
  const AnimationSettings({
    this.durationMs = 300,
    this.curveIndex = 0,
    this.useDecoration = false,
  });

  final int durationMs;
  final int curveIndex;
  final bool useDecoration;

  Duration get duration => Duration(milliseconds: durationMs);
  Curve get curve => curveOptions[curveIndex].curve;

  AnimationSettings copyWith({
    int? durationMs,
    int? curveIndex,
    bool? useDecoration,
  }) {
    return AnimationSettings(
      durationMs: durationMs ?? this.durationMs,
      curveIndex: curveIndex ?? this.curveIndex,
      useDecoration: useDecoration ?? this.useDecoration,
    );
  }
}
