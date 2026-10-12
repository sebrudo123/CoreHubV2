import 'package:flutter/material.dart';

import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/widgets/game_focus.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../data/home_feed.dart';

/// Cloud Saves tab: sync preview for local save games.
class CloudSavesPage extends StatelessWidget {
  const CloudSavesPage({super.key});

  void _snack(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.fromLTRB(28, 16, 28, 10),
          child: SectionHeader(
            title: 'Cloud Saves',
            subtitle: 'Sincroniza tus partidas',
            accent: AppColors.neonCyan,
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(28, 8, 28, 40),
            children: <Widget>[
              GlassCard(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 52,
                      height: 52,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: <Color>[
                            AppColors.neonCyan.withAlpha(60),
                            AppColors.neonBlue.withAlpha(24),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.neonCyan.withAlpha(80),
                        ),
                      ),
                      child: const Icon(
                        Icons.cloud_done_rounded,
                        color: AppColors.neonCyan,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Guardado en la nube',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Sección experimental. Los respaldos se sincronizan '
                            'cuando hay conexión.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              SectionHeader(
                title: 'Últimos respaldos',
                subtitle: '${HomeFeed.cloudSaves.length} partidas sincronizadas',
                accent: AppColors.neonBlue,
              ),
              const SizedBox(height: 14),
              for (final CloudBackup backup in HomeFeed.cloudSaves)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GlassCard(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 40,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.neonCyan.withAlpha(22),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.neonCyan.withAlpha(70),
                            ),
                          ),
                          child: const Icon(
                            Icons.save_rounded,
                            color: AppColors.neonCyan,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                backup.game,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${backup.modified} · ${backup.size}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                        GameFocus(
                          onSelect: () => _snack(
                            context,
                            'Sincronizando ${backup.game}…',
                          ),
                          builder: (BuildContext context, bool focused) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 9,
                              ),
                              decoration: BoxDecoration(
                                gradient: focused
                                    ? AppColors.primaryGradient
                                    : AppColors.glassGradient,
                                borderRadius: BorderRadius.circular(11),
                                border: Border.all(color: AppColors.glassBorder),
                              ),
                              child: Text(
                                'Sincronizar',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge
                                    ?.copyWith(
                                      fontSize: 11,
                                      color: focused
                                          ? Colors.white
                                          : AppColors.textSecondary,
                                    ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}