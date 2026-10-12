import 'dart:math' as math;
import 'dart:ui' show MaskFilter;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Animated neon aurora background rendered on a canvas at display refresh rate.
class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({super.key, this.child});

  final Widget? child;

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 18),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget? child) {
          return CustomPaint(
            painter: _AuroraPainter(_controller.value),
            child: child,
          );
        },
        child: widget.child ?? const SizedBox.expand(),
      ),
    );
  }
}

class _AuroraPainter extends CustomPainter {
  _AuroraPainter(this.t);

  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = AppColors.background,
    );

    _blob(canvas, size, AppColors.neonBlue, t, 0.0);
    _blob(canvas, size, AppColors.neonPink, t, 0.5);
    _blob(canvas, size, AppColors.neonCyan, t, 0.25);
  }

  void _blob(Canvas canvas, Size size, Color color, double time, double phase) {
    final double progress = (time + phase) % 1.0;
    final Offset center = Offset(
      size.width * (0.5 + 0.34 * math.cos(progress * 2 * math.pi)),
      size.height * (0.5 + 0.34 * math.sin(progress * 2 * math.pi)),
    );
    final double radius = size.shortestSide * 0.55;
    final Paint paint = Paint()
      ..shader = RadialGradient(
        colors: <Color>[color.withAlpha(52), color.withAlpha(0)],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 48);
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant _AuroraPainter oldDelegate) =>
      oldDelegate.t != t;
}
