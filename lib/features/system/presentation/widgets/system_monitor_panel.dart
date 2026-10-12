import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../domain/entities/system_stats.dart';
import '../controllers/system_monitor_controller.dart';

/// Real-time hardware panel: battery, CPU, RAM, SoC temperature and clock.
class SystemMonitorPanel extends StatelessWidget {
  const SystemMonitorPanel({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final SystemStats stats = context.watch<SystemMonitorController>().stats;

    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _Metric(
            icon: stats.charging ? Icons.bolt_rounded : Icons.battery_full_rounded,
            label: 'BATERÍA',
            value: stats.batteryLevel >= 0 ? '${stats.batteryLevel}%' : '--',
            progress: stats.batteryLevel >= 0 ? stats.batteryLevel / 100 : 0,
            color: stats.batteryLevel <= 15 ? AppColors.danger : AppColors.success,
          ),
          if (!compact) ...<Widget>[
            const _Divider(),
            _Metric(
              icon: Icons.memory_rounded,
              label: 'RAM',
              value: '${stats.ramUsagePercent.toStringAsFixed(0)}%',
              progress: stats.ramUsagePercent / 100,
              color: AppColors.neonBlue,
            ),
            const _Divider(),
            _Metric(
              icon: Icons.speed_rounded,
              label: 'CPU',
              value: '${stats.cpuLoad.toStringAsFixed(0)}%',
              progress: stats.cpuLoad / 100,
              color: AppColors.neonPink,
            ),
            const _Divider(),
            _Metric(
              icon: Icons.thermostat_rounded,
              label: 'TEMP',
              value: '${stats.temperature.toStringAsFixed(1)}°',
              progress: (stats.temperature / 90).clamp(0, 1).toDouble(),
              color: _tempColor(stats.temperature),
            ),
            const _Divider(),
          ],
          _Clock(stats: stats),
        ],
      ),
    );
  }

  Color _tempColor(double temperature) {
    if (temperature >= 70) return AppColors.danger;
    if (temperature >= 55) return AppColors.warning;
    return AppColors.neonCyan;
  }
}

class _Metric extends StatelessWidget {
  const _Metric({
    required this.icon,
    required this.label,
    required this.value,
    required this.progress,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final double progress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 76,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 4),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress.clamp(0, 1).toDouble(),
              minHeight: 3,
              backgroundColor: AppColors.divider,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      color: AppColors.divider,
    );
  }
}

class _Clock extends StatelessWidget {
  const _Clock({required this.stats});

  final SystemStats stats;

  @override
  Widget build(BuildContext context) {
    final DateTime now = stats.clock ?? DateTime.now();
    final String time =
        '${_two(now.hour)}:${_two(now.minute)}:${_two(now.second)}';
    final String date = '${_two(now.day)}/${_two(now.month)}/${now.year}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Text(
          'SISTEMA',
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.1,
            color: AppColors.textMuted,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          time,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
          ),
        ),
        const SizedBox(height: 2),
        Text(date, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }

  String _two(int value) => value.toString().padLeft(2, '0');
}
