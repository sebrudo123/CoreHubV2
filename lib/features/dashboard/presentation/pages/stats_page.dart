import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../system/domain/entities/system_stats.dart';
import '../../../system/presentation/controllers/system_monitor_controller.dart';

/// Stats tab: live CPU, RAM, battery, temperature, clock and uptime.
class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  String _fmtUptime(Duration duration) {
    final int hours = duration.inHours;
    final int minutes = duration.inMinutes % 60;
    if (hours == 0) {
      return '$minutes min';
    }
    return '$hours h $minutes min';
  }

  String _fmtClock(DateTime? clock) {
    if (clock == null) {
      return '--:--:--';
    }
    String two(int value) => value.toString().padLeft(2, '0');
    return '${two(clock.hour)}:${two(clock.minute)}:${two(clock.second)}';
  }

  @override
  Widget build(BuildContext context) {
    final SystemStats stats = context.watch<SystemMonitorController>().stats;
    final double battery = stats.batteryLevel <= 0
        ? 0
        : (stats.batteryLevel / 100).clamp(0, 1).toDouble();
    final double temperature =
        (stats.temperature / 80).clamp(0, 1).toDouble();
    final String ram =
        '${(stats.ramUsedMb / 1024).toStringAsFixed(1)} / '
        '${(stats.ramTotalMb / 1024).toStringAsFixed(1)} GB';
    final double ramProgress = stats.ramUsagePercent / 100;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.fromLTRB(28, 16, 28, 10),
          child: SectionHeader(
            title: 'Stats',
            subtitle: 'Rendimiento del dispositivo',
            accent: AppColors.neonCyan,
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(28, 8, 28, 40),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 260,
              childAspectRatio: 1.5,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: 6,
            itemBuilder: (BuildContext context, int index) {
              switch (index) {
                case 0:
                  return _MetricCard(
                    title: 'CPU',
                    icon: Icons.memory_rounded,
                    accent: AppColors.neonCyan,
                    value: '${(stats.cpuLoad * 100).round()}%',
                    progress: stats.cpuLoad.clamp(0, 1).toDouble(),
                    footnote: 'Carga total',
                  );
                case 1:
                  return _MetricCard(
                    title: 'RAM',
                    icon: Icons.data_usage_rounded,
                    accent: AppColors.neonPink,
                    value: ram,
                    progress: ramProgress,
                    footnote:
                        '${stats.ramUsagePercent.toStringAsFixed(0)}% en uso',
                  );
                case 2:
                  return _MetricCard(
                    title: 'Battery',
                    icon: stats.charging
                        ? Icons.battery_charging_full_rounded
                        : Icons.battery_std_rounded,
                    accent: AppColors.success,
                    value: stats.batteryLevel <= 0
                        ? '--'
                        : '${stats.batteryLevel}%',
                    progress: battery,
                    footnote: stats.charging ? 'Cargando' : 'Batería',
                  );
                case 3:
                  return _MetricCard(
                    title: 'Temperature',
                    icon: Icons.thermostat_rounded,
                    accent: temperature > 0.75
                        ? AppColors.danger
                        : AppColors.warning,
                    value: '${stats.temperature.round()} °C',
                    progress: temperature,
                    footnote: 'Sensor principal',
                  );
                case 4:
                  return _MetricCard(
                    title: 'Clock',
                    icon: Icons.schedule_rounded,
                    accent: AppColors.neonBlue,
                    value: _fmtClock(stats.clock),
                    footnote: 'Hora del sistema',
                  );
                default:
                  return _MetricCard(
                    title: 'Uptime',
                    icon: Icons.timer_rounded,
                    accent: AppColors.neonCyan,
                    value: _fmtUptime(stats.uptime),
                    footnote: 'Tiempo encendido',
                  );
              }
            },
          ),
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.title,
    required this.icon,
    required this.accent,
    required this.value,
    required this.footnote,
    this.progress,
  });

  final String title;
  final IconData icon;
  final Color accent;
  final String value;
  final String footnote;
  final double? progress;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderColor: accent.withAlpha(50),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(icon, size: 18, color: accent),
              const SizedBox(width: 8),
              Text(
                title.toUpperCase(),
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: accent,
                    ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 4),
          Text(footnote, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 10),
          if (progress != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 4,
                backgroundColor: AppColors.glassBorder,
                valueColor: AlwaysStoppedAnimation<Color>(accent),
              ),
            ),
        ],
      ),
    );
  }
}