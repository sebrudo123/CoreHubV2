import 'package:flutter/services.dart';

import 'native_channels.dart';

/// Dart facade over native installed-Android-game discovery and launching.
class NativeInstalledApps {
  const NativeInstalledApps();

  Future<List<Map<String, dynamic>>> getInstalledGames() async {
    try {
      final List<dynamic>? result =
          await NativeChannels.apps.invokeMethod<List<dynamic>>('getGames');
      return (result ?? const <dynamic>[])
          .whereType<Map<dynamic, dynamic>>()
          .map((Map<dynamic, dynamic> e) => e.cast<String, dynamic>())
          .toList(growable: false);
    } on PlatformException {
      return const <Map<String, dynamic>>[];
    } on MissingPluginException {
      return const <Map<String, dynamic>>[];
    }
  }

  Future<bool> launchPackage(String packageName) async {
    try {
      final bool? result = await NativeChannels.apps.invokeMethod<bool>(
        'launch',
        <String, dynamic>{'package': packageName},
      );
      return result ?? false;
    } on PlatformException {
      return false;
    } on MissingPluginException {
      return false;
    }
  }
}
