import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/widgets/game_focus.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../domain/entities/game.dart';
import '../../domain/entities/library_filter.dart';
import '../controllers/library_controller.dart';
import '../widgets/game_grid.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({
    super.key,
    required this.filter,
    required this.title,
    this.emptyMessage,
  });

  final LibraryFilter filter;
  final String title;
  final String? emptyMessage;

  Future<void> _launch(BuildContext context, Game game) async {
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    final LibraryController controller = context.read<LibraryController>();
    final bool ok = await controller.launch(game);
    if (ok) return;
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          'No se pudo iniciar "${game.title}". Verifica que el emulador esté instalado.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final LibraryController controller = context.watch<LibraryController>();
    final List<Game> games = controller.gamesFor(filter);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 16, 28, 10),
          child: SectionHeader(
            title: title,
            subtitle: _subtitle(controller, games),
            trailing: _RefreshButton(controller: controller),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          child: controller.isEnriching
              ? const LinearProgressIndicator(
                  minHeight: 2,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.neonPink),
                )
              : const SizedBox(height: 2),
        ),
        Expanded(child: _body(context, controller, games)),
      ],
    );
  }

  Widget _body(
    BuildContext context,
    LibraryController controller,
    List<Game> games,
  ) {
    if (controller.isScanning && controller.totalGames == 0) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              width: 42,
              height: 42,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: AppColors.neonBlue,
              ),
            ),
            SizedBox(height: 18),
            Text('Escaneando almacenamiento…'),
          ],
        ),
      );
    }

    if (games.isEmpty) {
      return _EmptyState(
        message: emptyMessage ?? 'No hay juegos en esta categoría.',
        onScan: controller.refresh,
      );
    }

    return GameGrid(
      games: games,
      onLaunch: (Game game) => _launch(context, game),
      onToggleFavorite: controller.toggleFavorite,
    );
  }

  String _subtitle(LibraryController controller, List<Game> games) {
    switch (filter) {
      case LibraryFilter.recent:
        return '${games.length} títulos jugados recientemente';
      case LibraryFilter.consoles:
        return '${games.length} ROMs · ${controller.totalGames} títulos totales';
      case LibraryFilter.android:
        return '${games.length} aplicaciones instaladas';
    }
  }
}

class _RefreshButton extends StatelessWidget {
  const _RefreshButton({required this.controller});

  final LibraryController controller;

  @override
  Widget build(BuildContext context) {
    return GameFocus(
      onSelect: () => controller.refresh(),
      builder: (BuildContext context, bool focused) {
        return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: focused ? AppColors.neonBlue.withAlpha(36) : AppColors.glass,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: focused ? AppColors.neonBlue : AppColors.glassBorder,
            ),
          ),
          child: controller.isScanning
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.refresh_rounded, size: 18),
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message, required this.onScan});

  final String message;
  final VoidCallback onScan;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(Icons.inbox_rounded, size: 56, color: AppColors.textMuted),
          const SizedBox(height: 16),
          Text(message, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 20),
          GameFocus(
            autofocus: true,
            onSelect: onScan,
            builder: (BuildContext context, bool focused) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                decoration: BoxDecoration(
                  gradient: focused ? AppColors.primaryGradient : null,
                  color: focused ? null : AppColors.glass,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.glassBorder),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(Icons.search_rounded, size: 18),
                    SizedBox(width: 8),
                    Text('Escanear biblioteca'),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
