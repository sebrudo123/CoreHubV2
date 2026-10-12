import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/widgets/animated_background.dart';
import '../../../../shared/widgets/game_focus.dart';
import '../../../library/domain/entities/library_filter.dart';
import '../../../library/presentation/controllers/library_controller.dart';
import '../../../library/presentation/pages/library_page.dart';
import '../../../system/presentation/pages/settings_page.dart';
import '../widgets/app_header.dart';
import '../widgets/app_sidebar.dart';
import '../widgets/home_side_panel.dart';
import '../widgets/home_view.dart';
import 'cloud_saves_page.dart';
import 'community_page.dart';
import 'downloads_page.dart';
import 'stats_page.dart';
import 'store_page.dart';

/// Main launcher shell: sidebar navigation, header and per-section content.
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  DashboardSection _section = DashboardSection.home;

  Widget _buildContent() {
    switch (_section) {
      case DashboardSection.home:
        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final double panelWidth =
                (constraints.maxWidth * 0.28).clamp(240.0, 320.0).toDouble();
            return Row(
              children: <Widget>[
                const Expanded(child: HomeView()),
                const SizedBox(width: 18),
                SizedBox(width: panelWidth, child: const HomeSidePanel()),
              ],
            );
          },
        );
      case DashboardSection.library:
        return const _LibraryShell();
      case DashboardSection.store:
        return const StorePage();
      case DashboardSection.community:
        return const CommunityPage();
      case DashboardSection.downloads:
        return const DownloadsPage();
      case DashboardSection.stats:
        return const StatsPage();
      case DashboardSection.cloudSaves:
        return const CloudSavesPage();
      case DashboardSection.settings:
        return const SettingsPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final LibraryController library = context.watch<LibraryController>();
    return Scaffold(
      body: Stack(
        children: <Widget>[
          const Positioned.fill(child: AnimatedBackground()),
          SafeArea(
            child: Column(
              children: <Widget>[
                AppHeader(onSearchChanged: library.search),
                Expanded(
                  child: Row(
                    children: <Widget>[
                      AppSidebar(
                        sections: DashboardSection.values,
                        selected: _section,
                        onSelect: (DashboardSection section) {
                          setState(() => _section = section);
                        },
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: _buildContent()),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LibraryShell extends StatefulWidget {
  const _LibraryShell();

  @override
  State<_LibraryShell> createState() => _LibraryShellState();
}

class _LibraryShellState extends State<_LibraryShell> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final LibraryFilter filter = LibraryFilter.values[_tab];
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 10, 28, 6),
          child: Row(
            children: <Widget>[
              for (int i = 0; i < LibraryFilter.values.length; i++)
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: _FilterChip(
                    filter: LibraryFilter.values[i],
                    active: i == _tab,
                    onSelect: () => setState(() => _tab = i),
                    autofocus: i == 0,
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: switch (_tab) {
            0 => LibraryPage(
                key: const ValueKey<String>('recent'),
                filter: LibraryFilter.recent,
                title: 'Recientes',
                emptyMessage: 'Aún no has jugado nada. ¡Dale play a un título!',
              ),
            1 => LibraryPage(
                key: const ValueKey<String>('consoles'),
                filter: LibraryFilter.consoles,
                title: 'Consolas / Emuladores',
                emptyMessage: 'No se encontraron ROMs. Revisa el almacenamiento.',
              ),
            _ => LibraryPage(
                key: const ValueKey<String>('android'),
                filter: LibraryFilter.android,
                title: 'Juegos Android',
                emptyMessage: 'No hay juegos Android instalados.',
              ),
          },
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.filter,
    required this.active,
    required this.onSelect,
    this.autofocus = false,
  });

  final LibraryFilter filter;
  final bool active;
  final VoidCallback onSelect;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return GameFocus(
      autofocus: autofocus,
      onSelect: onSelect,
      builder: (BuildContext context, bool focused) {
        final bool highlight = active || focused;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
          decoration: BoxDecoration(
            gradient: highlight ? AppColors.primaryGradient : null,
            color: highlight ? null : AppColors.glass,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: highlight ? Colors.transparent : AppColors.glassBorder,
            ),
          ),
          child: Text(
            filter.label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontSize: 11,
                  color: highlight ? Colors.white : AppColors.textSecondary,
                ),
          ),
        );
      },
    );
  }
}