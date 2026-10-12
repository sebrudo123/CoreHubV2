/// Immutable snapshot of device telemetry.
class SystemStats {
  const SystemStats({
    this.batteryLevel = -1,
    this.charging = false,
    this.cpuLoad = 0,
    this.ramTotalMb = 0,
    this.ramUsedMb = 0,
    this.temperature = 0,
    this.clock,
    this.uptimeMillis = 0,
  });

  final int batteryLevel;
  final bool charging;
  final double cpuLoad;
  final double ramTotalMb;
  final double ramUsedMb;
  final double temperature;
  final DateTime? clock;
  final int uptimeMillis;

  static const SystemStats empty = SystemStats();

  double get ramUsagePercent =>
      ramTotalMb <= 0 ? 0 : (ramUsedMb / ramTotalMb).clamp(0, 1).toDouble() * 100;

  Duration get uptime => Duration(milliseconds: uptimeMillis);

  factory SystemStats.fromMap(Map<String, dynamic> map) {
    return SystemStats(
      batteryLevel: (map['batteryLevel'] as num?)?.toInt() ?? -1,
      charging: map['charging'] as bool? ?? false,
      cpuLoad: (map['cpuLoad'] as num?)?.toDouble() ?? 0,
      ramTotalMb: (map['ramTotalMb'] as num?)?.toDouble() ?? 0,
      ramUsedMb: (map['ramUsedMb'] as num?)?.toDouble() ?? 0,
      temperature: (map['temperature'] as num?)?.toDouble() ?? 0,
      clock: map['clock'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch((map['clock'] as num).toInt()),
      uptimeMillis: (map['uptime'] as num?)?.toInt() ?? 0,
    );
  }
}
