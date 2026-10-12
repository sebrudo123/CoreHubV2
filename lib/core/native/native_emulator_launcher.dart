import 'package:flutter/services.dart';

import 'native_channels.dart';

/// Dart facade over the native Android Intent emulator launcher.
class NativeEmulatorLauncher {
  const NativeEmulatorLauncher();

  /// Packages of known emulators currently installed on the device.
  Future<List<String>> listInstalledEmulators() async {
    try {
      final List<dynamic>? result =
          await NativeChannels.emulator.invokeMethod<List<dynamic>>('listEmulators');
      return (result ?? const <dynamic>[])
          .map((dynamic e) => e.toString())
          .toList(growable: false);
    } on PlatformException {
      return const <String>[];
    } on MissingPluginException {
      return const <String>[];
    }
  }

  /// Launches [romPath] on the best (or [preferredPackage]) emulator.
  ///
  /// Returns the package that handled the intent, or `null` on failure.
  Future<String?> launch({
    required String romPath,
    required String platform,
    String? preferredPackage,
    String? args,
  }) async {
    try {
      return await NativeChannels.emulator.invokeMethod<String>(
        'launch',
        <String, dynamic>{
          'romPath': romPath,
          'platform': platform,
          'package': preferredPackage,
          'args': args,
        },
      );
    } on PlatformException {
      return null;
    } on MissingPluginException {
      return null;
    }
  }
}
