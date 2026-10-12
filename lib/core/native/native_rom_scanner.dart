import 'package:flutter/services.dart';

import 'native_channels.dart';

/// Dart facade over the native asynchronous ROM scanner.
class NativeRomScanner {
  const NativeRomScanner();

  /// Returns every readable storage root (internal + mounted MicroSD volumes).
  Future<List<String>> discoverRoots() async {
    try {
      final List<dynamic>? result =
          await NativeChannels.romScanner.invokeMethod<List<dynamic>>('discoverRoots');
      return (result ?? const <dynamic>[])
          .map((dynamic e) => e.toString())
          .toList(growable: false);
    } on PlatformException {
      return const <String>[];
    } on MissingPluginException {
      return const <String>[];
    }
  }

  /// Scans the given roots and returns raw ROM descriptors.
  Future<List<Map<String, dynamic>>> scan(List<String> roots) async {
    try {
      final List<dynamic>? result =
          await NativeChannels.romScanner.invokeMethod<List<dynamic>>(
        'scan',
        <String, dynamic>{'roots': roots},
      );
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
}
