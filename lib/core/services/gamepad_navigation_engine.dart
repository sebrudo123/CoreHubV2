import 'dart:async';

import 'package:flutter/widgets.dart';

import '../native/native_channels.dart';
import 'sound_service.dart';

/// Bridges physical gamepad input to the Flutter focus system.
///
/// * Digital D-Pad / face buttons are delivered by Flutter's own focus engine.
/// * Analog sticks & triggers arrive through [NativeChannels.gamepad] and are
///   translated into directional focus moves with dead-zone + repeat filtering.
class GamepadNavigationEngine {
  GamepadNavigationEngine({SoundService? soundService})
      : _sound = soundService ?? SoundService.instance;

  static final GamepadNavigationEngine instance = GamepadNavigationEngine();

  final SoundService _sound;

  StreamSubscription<dynamic>? _subscription;
  bool _started = false;
  DateTime _lastMove = DateTime.fromMillisecondsSinceEpoch(0);

  static const Duration _repeatDelay = Duration(milliseconds: 220);
  static const double _deadZone = 0.55;
  static const double _hatThreshold = 0.5;

  void start() {
    if (_started) return;
    _started = true;
    _subscription = NativeChannels.gamepad
        .receiveBroadcastStream()
        .listen(_onAxes, onError: (Object _) {});
  }

  void stop() {
    _subscription?.cancel();
    _subscription = null;
    _started = false;
  }

  void _onAxes(dynamic event) {
    if (event is! Map) return;

    final double x = _axis(event, 'x');
    final double y = _axis(event, 'y');
    final double hatX = _axis(event, 'hatX');
    final double hatY = _axis(event, 'hatY');

    final double dx = _resolve(x, hatX, _deadZone, _hatThreshold);
    final double dy = _resolve(y, hatY, _deadZone, _hatThreshold);
    if (dx == 0 && dy == 0) return;

    final DateTime now = DateTime.now();
    if (now.difference(_lastMove) < _repeatDelay) return;
    _lastMove = now;

    final TraversalDirection direction;
    if (dx.abs() >= dy.abs()) {
      direction = dx < 0 ? TraversalDirection.left : TraversalDirection.right;
    } else {
      direction = dy < 0 ? TraversalDirection.up : TraversalDirection.down;
    }

    FocusManager.instance.primaryFocus?.focusInDirection(direction);
    _sound.tick();
  }

  double _resolve(double analog, double hat, double deadZone, double hatThreshold) {
    if (analog.abs() > deadZone) return analog.sign;
    if (hat.abs() > hatThreshold) return hat.sign;
    return 0;
  }

  double _axis(Map<dynamic, dynamic> event, String key) {
    final dynamic value = event[key];
    return value is num ? value.toDouble() : 0;
  }
}
