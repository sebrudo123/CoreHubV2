import 'package:flutter/material.dart';

/// "Dark Gaming UI" corporate palette.
///
/// Base background `#090B10`, glass surfaces and neon accents
/// (`#007AFF` / `#FF0055`).
class AppColors {
  AppColors._();

  static const Color background = Color(0xFF090B10);
  static const Color backgroundElevated = Color(0xFF0E1220);
  static const Color surface = Color(0xFF121826);
  static const Color surfaceHigh = Color(0xFF1A2236);

  static const Color glass = Color(0x1AFFFFFF);
  static const Color glassStrong = Color(0x26FFFFFF);
  static const Color glassBorder = Color(0x33FFFFFF);
  static const Color divider = Color(0x1FFFFFFF);

  static const Color neonBlue = Color(0xFF007AFF);
  static const Color neonPink = Color(0xFFFF0055);
  static const Color neonCyan = Color(0xFF00E5FF);

  static const Color textPrimary = Color(0xFFF4F7FF);
  static const Color textSecondary = Color(0xFF9BA6BC);
  static const Color textMuted = Color(0xFF5C6472);

  static const Color success = Color(0xFF2EE6A8);
  static const Color warning = Color(0xFFFFB020);
  static const Color danger = Color(0xFFFF3B30);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: <Color>[neonBlue, neonPink],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient glassGradient = LinearGradient(
    colors: <Color>[Color(0x26FFFFFF), Color(0x0AFFFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient focusGradient = LinearGradient(
    colors: <Color>[Color(0x33007AFF), Color(0x22FF0055)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
