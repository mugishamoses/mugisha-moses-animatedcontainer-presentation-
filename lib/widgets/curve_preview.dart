import 'package:flutter/material.dart';

/// A tiny drawing of an animation curve (time left→right, progress
/// bottom→top), so the class can see how easeOutBack overshoots or
/// bounceOut bounces before even tapping +.
class CurvePreview extends StatelessWidget {
  const CurvePreview({super.key, required this.curve, required this.color});

  final Curve curve;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(40, 22),
      painter: _CurvePainter(curve, color),
    );
  }
}

class _CurvePainter extends CustomPainter {
  _CurvePainter(this.curve, this.color);

  final Curve curve;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    // Leave room above 1.0 for curves that overshoot.
    const top = 1.25;
    const bottom = -0.05;
    double y(double v) => size.height * (top - v) / (top - bottom);

    // Faint line at "finished" (value 1.0).
    canvas.drawLine(
      Offset(0, y(1)),
      Offset(size.width, y(1)),
      Paint()
        ..color = color.withValues(alpha: 0.2)
        ..strokeWidth = 1,
    );

    final path = Path()..moveTo(0, y(curve.transform(0)));
    for (var i = 1; i <= 40; i++) {
      final t = i / 40;
      path.lineTo(size.width * t, y(curve.transform(t)));
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(_CurvePainter old) =>
      old.curve != curve || old.color != color;
}
