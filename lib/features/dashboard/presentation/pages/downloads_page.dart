import 'package:flutter/material.dart';

import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/widgets/game_focus.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../data/home_feed.dart';

/// Downloads tab: full queue with pause/resume controls.
class DownloadsPage extends StatelessWidget {
  const DownloadsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.fromLTRB(28, 16, 28, 10),
          child: SectionHeader(
            title: 'Downloads',
            subtitle: 'Cola de descargas e instalaciones',
            accent: AppColors.neonPink,
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(28, 8, 28, 32),
            children: <Widget>[
              GlassCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.neonPink.withAlpha(24),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.neonPink.withAlpha(70),
                        ),
                      ),
                      child: const Icon(
                        Icons.speed_rounded,
                        size: 20,
                        color: AppColors.neonPink,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Ancho de banda',
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                          Text(
                            '42 MB/s',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(color: AppColors.neonPink),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.success.withAlpha(20),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.success.withAlpha(70),
                        ),
                      ),
                      child: Text(
                        'EN CURSO',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppColors.success,
                              fontSize: 9,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              for (final DownloadTask task in HomeFeed.downloads)
                Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _DownloadTaskCard(task: task),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DownloadTaskCard extends StatefulWidget {
  const _DownloadTaskCard({required this.task});

  final DownloadTask task;

  @override
  State<_DownloadTaskCard> createState() => _DownloadTaskCardState();
}

class _DownloadTaskCardState extends State<_DownloadTaskCard> {
  bool _paused = false;

  @override
  Widget build(BuildContext context) {
    final DownloadTask task = widget.task;
    final double done = (task.percent / 100).clamp(0, 1);
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: <Widget>[
          Container(
            width: 50,
            height: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[
                  AppColors.neonPink.withAlpha(60),
                  AppColors.neonPink.withAlpha(16),
                ],
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.neonPink.withAlpha(80)),
            ),
            child: Icon(
              _paused ? Icons.pause_rounded : Icons.download_rounded,
              color: AppColors.neonPink,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  task.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 3),
                Text(task.size, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: done,
                    minHeight: 6,
                    backgroundColor: AppColors.glassBorder,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.neonPink,
                    ),
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  '${task.percent.toInt()}% · ${_paused ? 'En pausa' : task.state}',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          GameFocus(
            onSelect: () => setState(() => _paused = !_paused),
            builder: (BuildContext context, bool focused) {
              return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    gradient: focused ? AppColors.primaryGradient : null,
                    color: focused ? null : AppColors.glass,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.glassBorder),
                  ),
                  child: Text(
                    _paused ? 'Reanudar' : 'Pausar',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontSize: 11,
                          color: focused ? Colors.white : AppColors.textSecondary,
                        ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}