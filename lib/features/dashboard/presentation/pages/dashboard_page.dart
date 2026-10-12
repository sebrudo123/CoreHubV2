import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/widgets/animated_background.dart';
import '../../../../shared/widgets/game_focus.dart';
import '../../../library/domain/entities/library_filter.dart';
import '../../../library/presentation/controllers/library_controller.dart';
import '../../../library/presentation/pages/library_page.dart';
import '../../../streaming/presentation/pages/streaming_page.dart';
import '../../../system/presentation/pages/settings_page.dart';
import '../../../system/presentation/widgets/system_monitor_panel.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  static const List<_NavItem> _items = <_NavItem>[
    _NavItem('Recientes', Icons.history_rounded),
    _NavItem('Consolas', Icons.videogame_asset_rounded),
    _NavItem('Android', Icons.android_rounded),
    _NavItem('Streaming', Icons.cloud_rounded),
    _NavItem('Ajustes', Icons.settings_rounded),
  ];

  final TextEditingController _search = TextEditingController();
  int _index = 0;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _select(int index) {
    if (index == _index) return;
    setState(() => _index = index);
  }

  Widget _buildPage() {
    switch (_index) {
      case 0:
        return const LibraryPage(
          key: ValueKey<String>('recent'),
          filter: LibraryFilter.recent,
          title: 'Recientes',
          emptyMessage: 'Aún no has jugado nada. ¡Dale play a un título!',
        );
      case 1:
        return const LibraryPage(
          key: ValueKey<String>('consoles'),
          filter: LibraryFilter.consoles,
          title: 'Consolas / Emuladores',
          emptyMessage: 'No se encontraron ROMs. Revisa el almacenamiento.',
        );
      case 2:
        return const LibraryPage(
          key: ValueKey<String>('android'),
          filter: LibraryFilter.android,
          title: 'Juegos Android',
          emptyMessage: 'No hay juegos Android instalados.',
        );
      case 3:
        return const StreamingPage(key: ValueKey<String>('streaming'));
      default:
        return const SettingsPage(key: ValueKey<String>('settings'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          const Positioned.fill(child: AnimatedBackground()),
          SafeArea(
            child: Row(
              children: <Widget>[
                _NavRail(
                  items: _items,
                  selected: _index,
                  onSelect: _select,
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      _Header(search: _search),
                      Expanded(child: _buildPage()),
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

class _NavItem {
  const _NavItem(this.label, this.icon);

  final String label;
  final IconData icon;
}

class _NavRail extends StatelessWidget {
  const _NavRail({
    required this.items,
    required this.selected,
    required this.onSelect,
  });

  final List<_NavItem> items;
  final int selected;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 104,
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 16),
      child: Column(
        children: <Widget>[
          const _Brand(),
          const SizedBox(height: 24),
          for (int i = 0; i < items.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _NavButton(
                item: items[i],
                active: i == selected,
                onSelect: () => onSelect(i),
              ),
            ),
        ],
      ),
    );
  }
}

class _Brand extends StatelessWidget {
  const _Brand();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(14),
            boxShadow: <BoxShadow>[
              BoxShadow(color: AppColors.neonBlue.withAlpha(90), blurRadius: 18),
            ],
          ),
          child: const Icon(Icons.sports_esports_rounded, color: Colors.white),
        ),
        const SizedBox(height: 8),
        ShaderMask(
          shaderCallback: (Rect bounds) =>
              AppColors.primaryGradient.createShader(bounds),
          child: const Text(
            'CORE\nHUB',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 12,
              height: 1.1,
              letterSpacing: 1.5,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.item,
    required this.active,
    required this.onSelect,
  });

  final _NavItem item;
  final bool active;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    return GameFocus(
      onSelect: onSelect,
      builder: (BuildContext context, bool focused) {
        final bool highlight = active || focused;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            gradient: active ? AppColors.primaryGradient : null,
            color: active
                ? null
                : (focused ? AppColors.neonBlue.withAlpha(36) : AppColors.glass),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: highlight ? AppColors.neonBlue : AppColors.glassBorder,
              width: focused ? 1.6 : 1.2,
            ),
          ),
          child: Column(
            children: <Widget>[
              Icon(item.icon, size: 22, color: Colors.white),
              const SizedBox(height: 6),
              Text(
                item.label.toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.search});

  final TextEditingController search;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 18, 28, 8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: search,
              onChanged: context.read<LibraryController>().search,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Buscar juegos…',
                hintStyle: const TextStyle(color: AppColors.textMuted),
                prefixIcon:
                    const Icon(Icons.search_rounded, color: AppColors.textSecondary),
                filled: true,
                fillColor: AppColors.glass,
                contentPadding: const EdgeInsets.symmetric(vertical: 4),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(999),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(999),
                  borderSide: const BorderSide(color: AppColors.neonBlue, width: 1.4),
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          const SystemMonitorPanel(),
        ],
      ),
    );
  }
}
