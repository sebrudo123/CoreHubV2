import 'package:flutter/material.dart';

import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/widgets/game_focus.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../domain/entities/game.dart';

class GameCard extends StatelessWidget {
  const GameCard({
    super.key,
    required this.game,
    required this.onLaunch,
    this.onToggleFavorite,
    this.autofocus = false,
  });

  final Game game;
  final ValueChanged<Game> onLaunch;
  final ValueChanged<Game>? onToggleFavorite;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return GameFocus(
      autofocus: autofocus,
      onBack: () => FocusManager.instance.primaryFocus?.unfocus(),
      onSelect: () => onLaunch(game),
      builder: (BuildContext context, bool focused) {
        return AnimatedScale(
          scale: focused ? 1.06 : 1.0,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          child: GlassCard(
            padding: EdgeInsets.zero,
            borderColor: focused ? AppColors.neonBlue : AppColors.glassBorder,
            borderWidth: focused ? 2 : 1.2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(child: _Artwork(game: game, focused: focused)),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        game.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: <Widget>[
                          _PlatformBadge(game: game),
                          const Spacer(),
                          _FavoriteButton(
                            game: game,
                            onToggle: onToggleFavorite,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Artwork extends StatelessWidget {
  const _Artwork({required this.game, required this.focused});

  final Game game;
  final bool focused;

  @override
  Widget build(BuildContext context) {
    final String? url = game.metadata.boxArtUrl;
    final Widget art = (url != null && url.isNotEmpty)
        ? Image.network(
            url,
            fit: BoxFit.cover,
            errorBuilder: (BuildContext context, Object error,
                    StackTrace? stackTrace) =>
                _placeholder(context),
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent? progress) {
              if (progress == null) return child;
              return _placeholder(context, loading: true);
            },
          )
        : _placeholder(context);

    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        art,
        const IgnorePointer(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.center,
                end: Alignment.bottomCenter,
                colors: <Color>[Colors.transparent, Color(0xCC090B10)],
              ),
            ),
          ),
        ),
        if (focused)
          IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[AppColors.neonBlue.withAlpha(60), Colors.transparent],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _placeholder(BuildContext context, {bool loading = false}) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            AppColors.surfaceHigh,
            game.platform.isKnown ? AppColors.neonBlue.withAlpha(60) : AppColors.surface,
          ],
        ),
      ),
      child: Center(
        child: loading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.neonBlue,
                ),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Icon(Icons.videogame_asset_rounded,
                      color: AppColors.textSecondary, size: 30),
                  const SizedBox(height: 8),
                  Text(
                    game.platform.shortLabel,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _PlatformBadge extends StatelessWidget {
  const _PlatformBadge({required this.game});

  final Game game;

  @override
  Widget build(BuildContext context) {
    final Color color = game.isAndroidApp ? AppColors.neonPink : AppColors.neonBlue;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withAlpha(36),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withAlpha(120)),
      ),
      child: Text(
        game.isAndroidApp ? 'ANDROID' : game.platform.shortLabel,
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w800,
          letterSpacing: 1,
          color: color,
        ),
      ),
    );
  }
}

class _FavoriteButton extends StatelessWidget {
  const _FavoriteButton({required this.game, this.onToggle});

  final Game game;
  final ValueChanged<Game>? onToggle;

  @override
  Widget build(BuildContext context) {
    if (onToggle == null) {
      return game.isFavorite
          ? const Icon(Icons.star_rounded, size: 16, color: AppColors.warning)
          : const SizedBox.shrink();
    }
    return GestureDetector(
      onTap: () => onToggle!(game),
      child: Icon(
        game.isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
        size: 18,
        color: game.isFavorite ? AppColors.warning : AppColors.textMuted,
      ),
    );
  }
}
