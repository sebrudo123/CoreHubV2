import 'package:flutter/material.dart';

import '../../domain/entities/game.dart';
import 'game_card.dart';

class GameGrid extends StatelessWidget {
  const GameGrid({
    super.key,
    required this.games,
    required this.onLaunch,
    this.onToggleFavorite,
    this.firstAutofocus = true,
  });

  final List<Game> games;
  final ValueChanged<Game> onLaunch;
  final ValueChanged<Game>? onToggleFavorite;
  final bool firstAutofocus;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(28, 8, 28, 64),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 220,
        childAspectRatio: 0.72,
        crossAxisSpacing: 18,
        mainAxisSpacing: 18,
      ),
      itemCount: games.length,
      itemBuilder: (BuildContext context, int index) {
        return GameCard(
          game: games[index],
          onLaunch: onLaunch,
          onToggleFavorite: onToggleFavorite,
          autofocus: firstAutofocus && index == 0,
        );
      },
    );
  }
}
