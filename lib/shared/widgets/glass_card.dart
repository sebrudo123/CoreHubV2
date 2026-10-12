import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

/// Translucent glassmorphism surface with a subtle neon border and blur.
class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.width,
    this.height,
    this.borderRadius,
    this.blur = 18,
    this.borderColor = AppColors.glassBorder,
    this.borderWidth = 1.2,
    this.gradient,
    this.color,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final double blur;
  final Color borderColor;
  final double borderWidth;
  final Gradient? gradient;
  final Color? color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius =
        borderRadius ?? BorderRadius.circular(AppTheme.radius);

    Widget content = Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        gradient: color == null ? (gradient ?? AppColors.glassGradient) : null,
        borderRadius: radius,
        border: Border.all(color: borderColor, width: borderWidth),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: borderColor.withAlpha(36),
            blurRadius: 22,
            spreadRadius: -6,
          ),
        ],
      ),
      child: child,
    );

    if (onTap != null) {
      content = GestureDetector(onTap: onTap, child: content);
    }

    return ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: content,
      ),
    );
  }
}
