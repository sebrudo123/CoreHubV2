import 'package:flutter/material.dart';

import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/widgets/game_focus.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../data/home_feed.dart';

/// Home tab: featured hero, recently played and library highlights.
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 10, 24, 36),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const _HeroBanner(),
          const SizedBox(height: 24),
          const SectionHeader(
            title: 'Recently Played',
            subtitle: 'Continúa donde lo dejaste',
            accent: AppColors.neonCyan,
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 176,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: HomeFeed.recentlyPlayed.length,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemBuilder: (BuildContext context, int index) {
                return _RecentlyCard(entry: HomeFeed.recentlyPlayed[index]);
              },
            ),
          ),
          const SizedBox(height: 24),
          const SectionHeader(
            title: 'Library Highlights',
            subtitle: 'Tu colección estelar',
            accent: AppColors.neonPink,
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 92,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: HomeFeed.highlights.length,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemBuilder: (BuildContext context, int index) {
                return _HighlightCard(entry: HomeFeed.highlights[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroBanner extends StatelessWidget {
  const _HeroBanner();

  void _snack(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final FeaturedTitle hero = HomeFeed.hero;
    return GlassCard(
      blur: 26,
      borderColor: hero.palette.first.withAlpha(90),
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        height: 250,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Wrap(
                    spacing: 10,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          hero.badge,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.4,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      for (final String genre in hero.genres)
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.glass,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.glassBorder),
                            ),
                            child: Text(
                              genre,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    hero.title,
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    hero.tagline,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: hero.palette.first,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Text(
                      hero.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: <Widget>[
                      GameFocus(
                        autofocus: true,
                        onSelect: () => _snack(
                          context,
                          'Iniciando playtest: ${hero.title}',
                        ),
                        builder: (BuildContext context, bool focused) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              gradient: focused
                                  ? AppColors.primaryGradient
                                  : AppColors.glassGradient,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: focused
                                    ? Colors.white70
                                    : AppColors.glassBorder,
                              ),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Icon(
                                  Icons.play_arrow_rounded,
                                  color: Colors.white,
                                  size: 22,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  'Jugar ahora',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 12),
                      GameFocus(
                        onSelect: () => _snack(
                          context,
                          'Detalles de ${hero.title}: próximamente',
                        ),
                        builder: (BuildContext context, bool focused) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: focused
                                  ? AppColors.glassStrong
                                  : AppColors.glass,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: focused
                                    ? hero.palette.last
                                    : AppColors.glassBorder,
                              ),
                            ),
                            child: Text(
                              'Ver detalles',
                              style: TextStyle(
                                color: focused
                                    ? hero.palette.last
                                    : AppColors.textSecondary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 18),
            Container(
              width: 118,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[
                    hero.palette.first.withAlpha(64),
                    hero.palette.last.withAlpha(28),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: hero.palette.first.withAlpha(90)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.radar_rounded,
                    color: hero.palette.first,
                    size: 46,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'S7',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: hero.palette.last,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecentlyCard extends StatelessWidget {
  const _RecentlyCard({required this.entry});

  final GameEntry entry;

  @override
  Widget build(BuildContext context) {
    return GameFocus(
      builder: (BuildContext context, bool focused) {
        return AnimatedScale(
          scale: focused ? 1.04 : 1.0,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          child: GlassCard(
            padding: const EdgeInsets.all(10),
            borderColor: focused ? entry.accent : AppColors.glassBorder,
            borderWidth: focused ? 1.6 : 1.2,
            child: SizedBox(
              width: 142,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 62,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[
                          entry.accent.withAlpha(52),
                          entry.accent.withAlpha(10),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(11),
                      border: Border.all(color: entry.accent.withAlpha(70)),
                    ),
                    child: Icon(
                      Icons.sports_esports_rounded,
                      color: entry.accent,
                      size: 26,
                    ),
                  ),
                  const SizedBox(height: 9),
                  Text(
                    entry.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontSize: 13.5,
                        ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    entry.tag,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: <Widget>[
                      Text(
                        '${entry.hours.toStringAsFixed(1)} h',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: entry.accent,
                            ),
                      ),
                      const Spacer(),
                      Text(
                        '${(entry.progress * 100).round()}%',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 7),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: entry.progress,
                      minHeight: 4,
                      backgroundColor: AppColors.glassBorder,
                      valueColor: AlwaysStoppedAnimation<Color>(entry.accent),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _HighlightCard extends StatelessWidget {
  const _HighlightCard({required this.entry});

  final GameEntry entry;

  @override
  Widget build(BuildContext context) {
    return GameFocus(
      builder: (BuildContext context, bool focused) {
        return AnimatedScale(
          scale: focused ? 1.03 : 1.0,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          child: GlassCard(
            padding: const EdgeInsets.all(12),
            borderColor: focused ? entry.accent : AppColors.glassBorder,
            borderWidth: focused ? 1.6 : 1.2,
            child: SizedBox(
              width: 246,
              child: Row(
                children: <Widget>[
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[
                          entry.accent.withAlpha(54),
                          entry.accent.withAlpha(12),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(13),
                      border: Border.all(color: entry.accent.withAlpha(80)),
                    ),
                    child: Icon(
                      Icons.videogame_asset_rounded,
                      color: entry.accent,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          entry.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          entry.tag,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: focused ? entry.accent : AppColors.textMuted,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}