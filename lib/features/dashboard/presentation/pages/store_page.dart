import 'package:flutter/material.dart';

import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/widgets/game_focus.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../streaming/domain/entities/streaming_service.dart';
import '../../../streaming/presentation/widgets/streaming_card.dart';
import '../../data/home_feed.dart';

/// Store tab: curated promos plus cloud/streaming services.
class StorePage extends StatelessWidget {
  const StorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.fromLTRB(28, 16, 28, 10),
          child: SectionHeader(
            title: 'Store',
            subtitle: 'Ofertas, novedades y juegos en la nube',
            accent: AppColors.neonBlue,
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(28, 8, 28, 40),
            children: <Widget>[
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 320,
                  childAspectRatio: 2.4,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                ),
                itemCount: HomeFeed.storePromos.length,
                itemBuilder: (BuildContext context, int index) {
                  return _PromoCard(
                    promo: HomeFeed.storePromos[index],
                    autofocus: index == 0,
                  );
                },
              ),
              const SizedBox(height: 26),
              const SectionHeader(
                title: 'Juega en streaming',
                subtitle: 'Xbox Cloud, GeForce NOW, Moonlight y más',
                accent: AppColors.neonPink,
              ),
              const SizedBox(height: 14),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 340,
                  childAspectRatio: 1.7,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                ),
                itemCount: StreamingService.all.length,
                itemBuilder: (BuildContext context, int index) {
                  return StreamingCard(service: StreamingService.all[index]);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PromoCard extends StatelessWidget {
  const _PromoCard({required this.promo, this.autofocus = false});

  final FeaturedTitle promo;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return GameFocus(
      autofocus: autofocus,
      builder: (BuildContext context, bool focused) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: <Color>[
                promo.palette.first.withAlpha(focused ? 80 : 46),
                promo.palette.last.withAlpha(14),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: focused
                  ? promo.palette.first
                  : promo.palette.first.withAlpha(70),
              width: focused ? 1.6 : 1.0,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      promo.badge,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.arrow_outward_rounded,
                    size: 16,
                    color: focused
                        ? promo.palette.first
                        : AppColors.textMuted,
                  ),
                ],
              ),
              const Spacer(),
              Text(
                promo.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 2),
              Text(
                promo.tagline,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 11.5,
                    ),
              ),
            ],
          ),
        );
      },
    );
  }
}