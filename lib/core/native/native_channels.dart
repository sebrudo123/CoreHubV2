import 'package:flutter/services.dart';

/// Central registry of the native platform channels exposed by [MainActivity].
class NativeChannels {
  NativeChannels._();

  static const MethodChannel romScanner = MethodChannel('com.gamehub/rom_scanner');
  static const MethodChannel emulator = MethodChannel('com.gamehub/emulator');
  static const MethodChannel system = MethodChannel('com.gamehub/system');
  static const MethodChannel apps = MethodChannel('com.gamehub/apps');
  static const EventChannel gamepad = EventChannel('com.gamehub/gamepad');
}
