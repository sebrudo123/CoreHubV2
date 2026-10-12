import 'package:flutter/services.dart';

import 'native_channels.dart';

/// Dart facade over the native hardware telemetry collector.
class NativeSystemMonitor {
  const NativeSystemMonitor();

  Future<Map<String, dynamic>?> fetchStats() async {
    try {
      final Map<dynamic, dynamic>? result =
          await NativeChannels.system.invokeMethod<Map<dynamic, dynamic>>('getStats');
      return result?.cast<String, dynamic>();
    } on PlatformException {
      return null;
    } on MissingPluginException {
      return null;
    }
  }
}
