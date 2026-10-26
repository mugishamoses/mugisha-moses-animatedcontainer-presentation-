import 'package:flutter/animation.dart';

/// A curve the presenter can pick in the playground.
class CurveOption {
  const CurveOption(this.name, this.curve);

  final String name;
  final Curve curve;
}

/// `Curves.linear` is listed first because it is AnimatedContainer's default.
const List<CurveOption> curveOptions = [
  CurveOption('linear', Curves.linear),
  CurveOption('easeInOut', Curves.easeInOut),
  CurveOption('easeOutBack', Curves.easeOutBack),
  CurveOption('bounceOut', Curves.bounceOut),
];

/// The three AnimatedContainer properties demonstrated in the app.
///
/// - duration: required by AnimatedContainer, so it has no default.
/// - curve: defaults to Curves.linear.
/// - decoration: defaults to null, which paints nothing.
class AnimationSettings {
  const AnimationSettings({
    required this.durationMs,
    required this.curveIndex,
    required this.useDecoration,
  });

  /// The values Flutter uses when we don't pass curve or decoration.
  /// duration has no default, so we keep the same 350 ms in both presets.
  static const flutterDefaults = AnimationSettings(
    durationMs: 350,
    curveIndex: 0,
    useDecoration: false,
  );

  /// The tuned values the app starts with.
  static const polished = AnimationSettings(
    durationMs: 350,
    curveIndex: 2,
    useDecoration: true,
  );

  final int durationMs;
  final int curveIndex;
  final bool useDecoration;

  Duration get duration => Duration(milliseconds: durationMs);
  Curve get curve => curveOptions[curveIndex].curve;
  String get curveName => curveOptions[curveIndex].name;

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
