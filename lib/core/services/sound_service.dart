import 'package:flutter/services.dart';

/// Interactive system sounds + haptics for D-Pad focus movement and selection.
///
/// Uses the platform feedback APIs so no binary audio assets are required.
class SoundService {
  SoundService._();

  static final SoundService instance = SoundService._();

  bool enabled = true;

  /// Short tick played when focus moves between elements.
  Future<void> tick() async {
    if (!enabled) return;
    await SystemSound.play(SystemSoundType.click);
    await HapticFeedback.selectionClick();
  }

  /// Confirmation feedback when an element is activated.
  Future<void> select() async {
    if (!enabled) return;
    await SystemSound.play(SystemSoundType.click);
    await HapticFeedback.lightImpact();
  }

  /// Error / blocked action feedback.
  Future<void> error() async {
    if (!enabled) return;
    await SystemSound.play(SystemSoundType.alert);
    await HapticFeedback.mediumImpact();
  }
}
