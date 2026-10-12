import 'package:flutter/services.dart';

/// Central registry of the native platform channels exposed by [MainActivity].
class NativeChannels {
  NativeChannels._();

  static const MethodChannel romScanner = MethodChannel('com.corehub/rom_scanner');
  static const MethodChannel emulator = MethodChannel('com.corehub/emulator');
  static const MethodChannel system = MethodChannel('com.corehub/system');
  static const MethodChannel apps = MethodChannel('com.corehub/apps');
  static const EventChannel gamepad = EventChannel('com.corehub/gamepad');
}
